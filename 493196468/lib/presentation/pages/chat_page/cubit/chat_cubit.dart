import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hashtagable/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '/utils/message.dart';
import '../../../../repo/firebase/messages_repository.dart';

part 'chat_state.dart';

class MessageCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository;

  MessageCubit(this.messagesRepository)
      : super(
          MessagesState(
            messages: [],
            filter: Filter(
              isFiltered: false,
              filterStr: '',
              isBookmarkFilterOn: false,
              hashTagFilters: [],
            ),
          ),
        ) {
    _init();
  }

  void _init() async {
    _updateStateFromRepo();
    messagesRepository.listenForUpdates(onUpdate: _updateStateFromRepo);
  }

  void _updateStateFromRepo() async => emit(
        state.copyWith(messages: await messagesRepository.getAllMessages()),
      );

  void emitMessages() {
    final newState = state.copyWith(messages: state.messages);
    emit(newState);
  }

  Future addMessage(Message message) async {
    final inEdit = state.messages.indexWhere((element) => element.onEdit);
    if (message.text.isNotEmpty) {
      if (inEdit == -1) {
        final id = await messagesRepository.addMessage(message);
        state.messages.add(message.copyWith(
          id: id,
        ));
        final filePath = state.picturePath?.picturePath;
        emit(state.copyWith(picturePath: PicturePath(null)));
        final url = await _addPictureToMessage(id, message, filePath);
        editMessage(state.messages.last.copyWith(pictureURL: url));
      } else {
        editTextFromMessage(message.text);
      }
    }
    emitMessages();
  }

  Future<String?> _addPictureToMessage(
    String? id,
    Message message,
    String? filePath,
  ) async {
    if (filePath != null && id != null) {
      final pictureURL = await messagesRepository.uploadPicture(
        File(filePath),
        id,
      );
      messagesRepository.editMessage(
        message.copyWith(
          id: id,
          pictureURL: pictureURL,
        ),
      );
      return pictureURL;
    }
    return null;
  }

  void editTextFromMessage(String text) {
    final editableMessage =
        state.messages.firstWhere((element) => element.onEdit);
    final editedMessage = editableMessage.copyWith(
      text: text,
      onEdit: false,
      isSelected: false,
    );
    final indexOfEditableMessage = state.messages.indexOf(editableMessage);

    state.messages[indexOfEditableMessage] = editedMessage;
    messagesRepository.editMessage(editedMessage);

    emitMessages();
  }

  void editMessage(Message editedMessage) {
    final indexOfEditableMessage =
        state.messages.indexWhere((element) => element.id == editedMessage.id);
    state.messages[indexOfEditableMessage] = editedMessage;
  }

  void copyMessage() async {
    final selectedMessage =
        state.messages.firstWhere((element) => element.isSelected);
    await Clipboard.setData(
      ClipboardData(text: selectedMessage.text),
    );
    editMessage(
      selectedMessage.copyWith(isSelected: false),
    );

    emitMessages();
  }

  void deleteSelectedMessages() {
    final selectedMessages =
        state.messages.where((element) => element.isSelected).toList();
    for (final element in selectedMessages) {
      state.messages.remove(element);
      messagesRepository.deleteMessage(element);
    }

    emitMessages();
  }

  void deleteMessage(Message message) {
    state.messages.remove(message);
    messagesRepository.deleteMessage(message);
    emitMessages();
  }

  void selectMessage(Message message) {
    editMessage(
      message.copyWith(isSelected: message.isSelected ? false : true),
    );
    emitMessages();
  }

  void unselectAllMessages() {
    for (final element
        in state.messages.where((element) => element.isSelected)) {
      editMessage(
        element.copyWith(isSelected: false),
      );
    }
    emitMessages();
  }

  void startEditMessage(Message message) {
    editMessage(
      message.copyWith(onEdit: true),
    );
    emitMessages();
  }

  void startEditSelectedMessage() async {
    final selectedMessage =
        state.messages.firstWhere((element) => element.isSelected);
    startEditMessage(selectedMessage);
    emitMessages();
  }

  List<Message> filterMessages(String filter) {
    return state.messages
        .where((element) => (element.text.startsWith(filter)))
        .toList();
  }

  void migrateMessages(String selectedChatId) {
    final selectedMessages =
        state.messages.where((element) => element.isSelected);
    for (final element in selectedMessages) {
      final editedMessage =
          element.copyWith(isSelected: false, chatId: selectedChatId);
      messagesRepository.editMessage(editedMessage);
      editMessage(
        editedMessage,
      );
    }
    emitMessages();
  }

  void setBookmarkFilter() {
    final newFilter = state.filter.copyWith(
      isBookmarkFilterOn: !state.filter.isBookmarkFilterOn,
    );
    emit(
      state.copyWith(
        filter: newFilter,
      ),
    );
  }

  void setFilter(String filter) {
    final newFilter = state.filter.copyWith(
      isFiltered: true,
      filterStr: filter,
    );
    emit(
      state.copyWith(
        filter: newFilter,
      ),
    );
  }

  void deleteFilter() {
    final newFilter = Filter(
      isFiltered: false,
      filterStr: '',
      isBookmarkFilterOn: false,
      hashTagFilters: [],
    );
    emit(
      state.copyWith(
        filter: newFilter,
      ),
    );
  }

  bool isFiltered() => state.filter.isFiltered;

  List<Message> getAllMessages() {
    return applyAllFilters(state.messages);
  }

  List<Message> getMessagesFromChat(String chatId) {
    final messages =
        state.messages.where(((element) => element.chatId == chatId)).toList();
    return applyAllFilters(messages);
  }

  List<Message> applyAllFilters(List<Message> messages) {
    if (state.filter.hashTagFilters.isNotEmpty) {
      final hashTagFilters = state.filter.hashTagFilters;
      messages = messages.where((element) {
        for (final filter in hashTagFilters) {
          if (element.text.contains(filter)) return true;
        }
        return false;
      }).toList();
    }
    if (state.filter.isBookmarkFilterOn) {
      messages = messages.where((element) => element.isBookmarked).toList();
    }
    if (state.filter.isFiltered) {
      messages = messages
          .where((element) => (element.text.contains(state.filter.filterStr)))
          .toList();
    }
    return messages;
  }

  Future<bool> pickImage() async {
    if (Platform.isIOS) {
      final request = await Permission.photos.request();
      if (request.isDenied) {
        return false;
      }
    }
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      emit(state.copyWith(picturePath: PicturePath(image?.path)));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      return false;
    }
    return true;
  }

  void removePicture() => emit(state.copyWith(picturePath: PicturePath(null)));

  void changeBookmark() {
    final selectedMessages =
        state.messages.where((element) => element.isSelected);
    for (final element in selectedMessages) {
      final editableMessage = element.copyWith(
          isSelected: false, isBookmarked: !element.isBookmarked);
      messagesRepository.editMessage(editableMessage);
      editMessage(
        editableMessage,
      );
    }
    emitMessages();
  }

  void addHashTagFilters(List<String> hashTagFilters) {
    final newFilter = state.filter.copyWith(hashTagFilters: hashTagFilters);
    emit(state.copyWith(filter: newFilter));
  }

  List<String> getHashTagFiltersFromChat(String chatId) {
    final messagesWithTags = state.messages.where(
        (element) => hasHashTags(element.text) && element.chatId == chatId);
    final hashTegFilters = <String>{};
    for (var element in messagesWithTags) {
      extractHashTags(element.text).forEach(hashTegFilters.add);
    }
    return hashTegFilters.toList();
  }

  List<String> getHashTagFilters() {
    final messagesWithTags =
        state.messages.where((element) => hasHashTags(element.text));
    final hashTegFilters = <String>{};
    for (var element in messagesWithTags) {
      extractHashTags(element.text).forEach(hashTegFilters.add);
    }
    return hashTegFilters.toList();
  }
}
