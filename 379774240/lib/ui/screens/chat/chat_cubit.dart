import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/database_provider.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  bool isInited = false;

  ChatCubit(super._chatEmpty);

  Future<void> init() async {
    var dbProvider = DatabaseProvider.instance;
    var appState = await dbProvider.readAppState();
    var event = await dbProvider.readEvent(appState.chatEventId);
    var events = await dbProvider.readEvents();
    var messages = await dbProvider.readMessages(appState.chatEventId);

    emit(state.copyWith(
      event: event,
      events: events,
      messages: messages,
    ));

    isInited = true;
  }

  Future<void> addMessage(Message message) async {
    var dbProvider = DatabaseProvider.instance;
    await dbProvider.createMessage(message);

    var messages = await dbProvider.readMessages(state.event.id!);

    emit(state.copyWith(messages: messages));
  }

  Future<void> deleteMessage(int index) async {
    var dbProvider = DatabaseProvider.instance;
    var message = state.messages[index];
    await dbProvider.deleteMessage(message.id!);

    var messages = await dbProvider.readMessages(state.event.id!);

    emit(state.copyWith(messages: messages));
  }

  void setEditingState(int editingMessageIndex) {
    emit(state.copyWith(
      isEditing: state.isEditing ? false : true,
      editingMessageIndex: editingMessageIndex,
    ));
  }

  Future<void> editMessage(Message msg, String text) async {
    var dbProvider = DatabaseProvider.instance;
    var message = Message(
      id: msg.id,
      eventId: state.event.id!,
      text: text,
      date: DateTime.now(),
    );
    await dbProvider.updateMessage(message);

    var messages = await dbProvider.readMessages(state.event.id!);

    emit(state.copyWith(messages: messages));
  }

  Future<void> likeEvent() async {
    var event = state.event;
    event.isFavorite == true
        ? event = event.copyWith(isFavorite: false)
        : event = event.copyWith(isFavorite: true);

    await DatabaseProvider.instance.updateEvent(event);
    event = await DatabaseProvider.instance.readEvent(state.event.id!);

    emit(state.copyWith(event: event));
  }

  void openSearchBar() {
    emit(state.copyWith(
      isSearchBarOpen: true,
      searchingMessages: state.messages,
    ));
  }

  void closeSearchBar() {
    emit(state.copyWith(
      isSearchBarOpen: false,
      searchingMessages: [],
    ));
  }

  void searchMessages(String value) {
    var searchingMessages = state.messages
        .where((element) =>
            element.text.toLowerCase().contains(value.toLowerCase()))
        .toList();
    emit(state.copyWith(searchingMessages: searchingMessages));
  }

  void openEventBar() {
    emit(state.copyWith(isEventBarOpen: true));
  }

  void closeEventBar() {
    emit(state.copyWith(isEventBarOpen: false));
  }

  void selectItemInEventBar(int itemIndex) {
    emit(state.copyWith(
      selectedItemInEventBar:
          state.selectedItemInEventBar == itemIndex ? -1 : itemIndex,
    ));
  }

  Future<void> sendMessageToEvent(Message message) async {
    var dbProvider = DatabaseProvider.instance;

    var msg = Message(
      eventId: state.selectedItemInEventBar,
      text: message.text,
      date: message.date,
    );

    await dbProvider.createMessage(message);
    emit(state.copyWith(selectedItemInEventBar: -1));
  }

  void addToForward(int index) {
    var selectedMessages = Set<int>.from(state.forwardMessagesIndex);

    if (selectedMessages.isEmpty) {
      selectedMessages.add(index);
      emit(state.copyWith(
        isForward: true,
        forwardMessagesIndex: selectedMessages,
      ));
    } else {
      if (selectedMessages.contains(index)) {
        selectedMessages.remove(index);
      } else {
        selectedMessages.add(index);
      }
      if (selectedMessages.isEmpty) {
        emit(state.copyWith(
          isForward: false,
          forwardMessagesIndex: {},
          selectedItemInEventBar: -1,
        ));
      } else {
        emit(state.copyWith(
          forwardMessagesIndex: selectedMessages,
        ));
      }
    }
  }

  Future<void> forwardMessage() async {
    var dbProvider = DatabaseProvider.instance;
    var event = state.events[state.selectedItemInEventBar];

    for (var i = 0; i < state.messages.length; i++) {
      if (state.forwardMessagesIndex.contains(i)) {
        await dbProvider.updateMessage(
          state.messages[i].copyWith(
            eventId: event.id!,
          ),
        );
      }
    }

    var messages = await dbProvider.readMessages(state.event.id!);
    emit(state.copyWith(
      messages: messages,
      isForward: false,
      isEventBarOpen: false,
      selectedItemInEventBar: -1,
      forwardMessagesIndex: {},
    ));
  }

  Future<void> editAppState() async {
    var appState = await DatabaseProvider.instance.readAppState();
    await DatabaseProvider.instance
        .updateAppState(appState.copyWith(chatEventId: -1));
  }
}
