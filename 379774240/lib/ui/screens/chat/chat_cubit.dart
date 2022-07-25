import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/models/app_state.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  ChatCubit(super._chatEmpty);

  //TODO fix exception (Unhandled Exception: Bad state: Cannot emit new states after calling close)
  Future<void> init() async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _fetchAppState(docAppState);

    _readEvents().listen((events) {
      late Event event;
      for (var element in events) {
        if (element.id == appState.chatEventId) {
          event = element;
        }
      }
      emit(state.copyWith(event: event, events: events));
    });
    _readMessages().listen((messages) {
      var eventMessages = <Message>[];
      for (var element in messages) {
        if (element.eventId == appState.chatEventId) {
          eventMessages.add(element);
        }
      }
      emit(state.copyWith(messages: eventMessages));
    });
  }

  Future<void> addMessage(Message message) async {
    final docMessage = _instance.collection('messages').doc();
    var newMessage = message.copyWith(id: docMessage.id);
    await docMessage.set(newMessage.toMap());
  }

  Future<void> deleteMessage(int index, String id) async {
    var docMessage = _instance.collection('messages').doc(id);
    docMessage.delete();
  }

  void setEditingState(int editingMessageIndex) {
    emit(state.copyWith(
      isEditing: state.isEditing ? false : true,
      editingMessageIndex: editingMessageIndex,
    ));
  }

  Future<void> editMessage(Message msg, String text) async {
    var docMessage = _instance.collection('messages').doc(msg.id);
    var message = msg.copyWith(text: text);
    docMessage.update(message.toMap());
    emit(state.copyWith(
      isEditing: false,
      editingMessageIndex: -1,
    ));
  }

  Future<void> likeEvent() async {
    var docEvent = _instance.collection('events').doc(state.event.id);
    var event = state.event;
    docEvent.update(event
        .copyWith(
          isFavorite: event.isFavorite ? false : true,
        )
        .toMap());
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
    var eventId = state.events[state.selectedItemInEventBar].id;
    var msg = Message(
      eventId: eventId,
      text: message.text,
      date: message.date,
    );
    var docMessages = _instance.collection('messages').doc();
    docMessages.set(msg.toMap());
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
    var event = state.events[state.selectedItemInEventBar];
    var forwwardMsgs = <Message>[];

    for (var i = 0; i < state.messages.length; i++) {
      if (state.forwardMessagesIndex.contains(i)) {
        forwwardMsgs.add(state.messages[i]);
      }
    }

    _readMessages().listen((messages) {
      for (var element in messages) {
        if (forwwardMsgs.contains(element)) {
          var docMessages = _instance.collection('messages').doc(element.id);
          docMessages.update(element
              .copyWith(
                eventId: event.id,
                date: DateTime.now(),
              )
              .toMap());
        }
      }
    });

    emit(state.copyWith(
      isForward: false,
      isEventBarOpen: false,
      selectedItemInEventBar: -1,
      forwardMessagesIndex: {},
    ));
  }

  Future<void> editAppState() async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _fetchAppState(docAppState);
    docAppState.update(appState.copyWith(chatEventId: '').toMap());
  }

  Stream<List<Event>> _readEvents() =>
      _instance.collection('events').snapshots().map((event) =>
          event.docs.map((doc) => Event.fromMap(doc.data())).toList());

  Stream<List<Message>> _readMessages() => _instance
      .collection('messages')
      .orderBy('date', descending: true)
      .snapshots()
      .map((messages) =>
          messages.docs.map((doc) => Message.fromMap(doc.data())).toList());

  Future<AppState> _fetchAppState(
      DocumentReference<Map<String, dynamic>> docAppState) async {
    var appStateSnapshot = await docAppState.snapshots().first;
    var appStateMap = appStateSnapshot.data();
    var appState = AppState.fromMap(appStateMap!);
    return appState;
  }

  //TODO: make this function work
  Future<void> _setEventSubtitle() async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _fetchAppState(docAppState);

    var lastMessageSnapshot = await _instance
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots()
        .last;
    var lastMessage = Message.fromMap(lastMessageSnapshot.docs.last.data());

    final docEvent = FirebaseFirestore.instance
        .collection('events')
        .doc(appState.chatEventId);
    docEvent.update(state.event.copyWith(subtitle: lastMessage.text).toMap());
  }

  void addImageState(XFile imageFile) {
    emit(state.copyWith(
      isImagePicked: true,
      imageFile: imageFile,
    ));
  }

  //TODO upload file
  void _uploadImage() {
    if (!state.isImagePicked) return;
    var file = state.imageFile!;
    var storage = FirebaseStorage.instance;
    try {
      storage.ref('images/${file.name}');
    } catch (e) {
      print(e);
    }
  }
}
