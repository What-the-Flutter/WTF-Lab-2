import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../repo/firebase/messages_repository.dart';
import '../utils/message.dart';

class MessageCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository = MessagesRepository();

  MessageCubit()
      : super(
          MessagesState(
            messages: [],
            filter: Filter(false, ''),
          ),
        );

  void init() async => emit(
        state.copyWith(messages: await messagesRepository.getAllMessages()),
      );

  void checkForUpdates() async =>
      await messagesRepository.checkForUpdates(onUpdate: init);

  void emitMessages() => emit(state.copyWith(messages: state.messages));

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
      String? id, Message message, String? filePath) async {
    if (filePath != null && id != null) {
      final pictureURL = await messagesRepository.uploadPicture(
        File(filePath),
        id,
      );
      messagesRepository
          .editMessage(message.copyWith(id: id, pictureURL: pictureURL));
      return pictureURL;
    }
    return null;
  }

  void editTextFromMessage(String text) {
    final editableMessage =
        state.messages.firstWhere((element) => element.onEdit);
    final editedMessage =
        editableMessage.copyWith(text: text, onEdit: false, isSelected: false);
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
    for (var element in selectedMessages) {
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
    for (var element in state.messages.where((element) => element.isSelected)) {
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

  List<Message> filterMessages(String filter, String chatId) {
    return state.messages
        .where((element) =>
            (element.text.startsWith(filter) && element.chatId == chatId))
        .toList();
  }

  void migrateMessages(String selectedChatId, String chatId) {
    final selectedMessages =
        state.messages.where((element) => element.isSelected);
    for (var element in selectedMessages) {
      final editedMessage =
          element.copyWith(isSelected: false, chatId: selectedChatId);
      messagesRepository.editMessage(editedMessage);
      editMessage(
        editedMessage,
      );
    }
    emitMessages();
  }

  void setFilter(String filter) => emit(
        state.copyWith(
          filter: Filter(true, filter),
        ),
      );

  void deleteFilter() => emit(
        state.copyWith(
          filter: Filter(false, ''),
        ),
      );

  bool isFiltered() => state.filter.isFiltered;

  List<Message> getMessagesFromChat(String chatId) {
    return state.filter.isFiltered
        ? filterMessages(state.filter.filterStr, chatId)
        : state.messages.where((element) => element.chatId == chatId).toList();
  }

  Future<bool> pickImage() async {
    final request = await Permission.photos.request();
    if (request.isDenied) {
      return false;
    } else {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        emit(state.copyWith(picturePath: PicturePath(image?.path)));
        print(state.picturePath?.picturePath);
      } on PlatformException catch (e) {
        print('Failed to pick image: $e');
        return false;
      }
      return true;
    }
  }

  void removePicture() => emit(state.copyWith(picturePath: PicturePath(null)));
}

class MessagesState {
  final List<Message> messages;
  final PicturePath? picturePath;
  final Filter filter;

  MessagesState({
    required this.messages,
    required this.filter,
    this.picturePath,
  });

  MessagesState copyWith({
    List<Message>? messages,
    Filter? filter,
    PicturePath? picturePath,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      filter: filter ?? this.filter,
      picturePath: picturePath ?? this.picturePath,
    );
  }

  @override
  String toString() {
    return messages.toString();
  }
}

class PicturePath extends Equatable {
  final String? picturePath;

  PicturePath(this.picturePath);

  @override
  List<Object?> get props => [picturePath];
}

class Filter extends Equatable {
  final bool isFiltered;
  final String filterStr;

  Filter(this.isFiltered, this.filterStr);

  @override
  List<Object?> get props => [isFiltered, filterStr];
}
