import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/event.dart';
import '../../../data/models/note.dart';
import '../../../domain/database/database_provider.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final _dbProvider = DatabaseProvider();
  final _storage = FirebaseStorage.instance;

  ChatCubit() : super(const ChatState());

  Future init() async {
    var appState = await _dbProvider.readAppState();
    var event = await _dbProvider.readEvent(appState.selectedEventId!);
    emit(state.copyWith(event: event));
    _fetchNotesToState(event.id!);
  }

  void addNote(String text) async {
    if (state.status == ChatStatus.noteWithImage) {
      var imageFile = File(state.image!.path);

      try {
        await _storage.ref('images/${state.image!.name}').putFile(imageFile);
      } catch (e) {
        print(e);
      }
    }

    var note = Note(
      eventId: state.event!.id!,
      text: text,
      imageName:
          state.status == ChatStatus.noteWithImage ? state.image!.name : '',
      date: DateTime.now(),
    );
    await _dbProvider.createNote(note);

    var lastActivity =
        '${note.date.day < 10 ? '0${note.date.day}' : note.date.day}.${note.date.month < 10 ? '0${note.date.month}' : note.date.month}';

    if (note.text.length >= 20) {
      var cutedMessage = '${note.text.substring(0, 17)}...';
      _dbProvider.updateEvent(
        state.event!.id!,
        state.event!.copyWith(
          lastMessage: cutedMessage,
          lastActivity: lastActivity,
        ),
      );
    } else {
      _dbProvider.updateEvent(
        state.event!.id!,
        state.event!.copyWith(
          lastMessage: note.text,
          lastActivity: lastActivity,
        ),
      );
    }

    emit(state.copyWith(status: ChatStatus.primary));
  }

  void setImage(XFile image) {
    emit(state.copyWith(
      image: image,
      status: ChatStatus.noteWithImage,
    ));
  }

  void _fetchNotesToState(String eventId) async {
    _dbProvider.listenNotes(eventId).listen((event) {
      var notes = <Note>[];
      var data = (event.snapshot.value ?? {}) as Map;
      data.forEach(((key, value) {
        notes.add(Note.fromMap({'id': key, ...value}));
      }));
      notes.sort(((a, b) => b.date.compareTo(a.date)));

      emit(state.copyWith(notes: notes));
    });
  }

  void deleteNote(Note note) {
    _dbProvider.deleteNote(note.eventId, note.id!);
  }

  void setEditingStatus(Note note) {
    emit(state.copyWith(
      status: ChatStatus.editingMessage,
      editingNote: note,
    ));
  }

  void setSendToStatus() async {
    var events = await _dbProvider.fetchEvents();
    emit(state.copyWith(
      events: events,
      status: ChatStatus.sendTo,
    ));
  }

  void setSearchingStatus() {
    emit(state.copyWith(
      status: ChatStatus.searchingNotes,
      searchingNotes: state.notes,
    ));
  }

  void cancelSendTo() {
    emit(state.copyWith(
      selectedEvent: null,
      events: [],
      status: ChatStatus.primary,
    ));
  }

  void cancelSearching() async {
    await init();
    emit(state.copyWith(
      searchingNotes: [],
      status: ChatStatus.primary,
    ));
  }

  void editNote(String newText) {
    _dbProvider.editNote(
      state.editingNote!,
      newText,
    );
    emit(state.copyWith(
      status: ChatStatus.primary,
      editingNote: null,
    ));
  }

  void addNoteToSelectedEvent(String text) {
    var note = Note(
      eventId: state.selectedEvent!.id!,
      text: text,
      date: DateTime.now(),
    );
    _dbProvider.createNote(note);

    var lastActivity =
        '${note.date.day < 10 ? '0${note.date.day}' : note.date.day}.${note.date.month < 10 ? '0${note.date.month}' : note.date.month}';

    if (note.text.length >= 20) {
      var cutedMessage = '${note.text.substring(0, 17)}...';
      _dbProvider.updateEvent(
        state.selectedEvent!.id!,
        state.selectedEvent!.copyWith(
          lastMessage: cutedMessage,
          lastActivity: lastActivity,
        ),
      );
    } else {
      _dbProvider.updateEvent(
        state.selectedEvent!.id!,
        state.selectedEvent!.copyWith(
          lastMessage: note.text,
          lastActivity: lastActivity,
        ),
      );
    }
    emit(state.copyWith(
      status: ChatStatus.primary,
      selectedEvent: null,
      events: [],
    ));
  }

  void selectItemInEventBar(Event event) {
    emit(state.copyWith(selectedEvent: event));
  }

  void searchNote(String text) {
    var searchingNotes =
        state.notes.where((element) => element.text.contains(text)).toList();
    searchingNotes.sort((a, b) => b.date.compareTo(a.date));
    emit(state.copyWith(searchingNotes: searchingNotes));
  }

  void selectNote(String id) async {
    var events = await _dbProvider.fetchEvents();
    var selectedMessages = Set<String>.from(state.forwardNotes);

    if (selectedMessages.isEmpty) {
      selectedMessages.add(id);
      emit(state.copyWith(
        events: events,
        status: ChatStatus.forwarding,
        forwardNotes: selectedMessages,
      ));
    } else {
      if (selectedMessages.contains(id)) {
        selectedMessages.remove(id);
      } else {
        selectedMessages.add(id);
      }
      if (selectedMessages.isEmpty) {
        emit(state.copyWith(
          status: ChatStatus.primary,
          forwardNotes: {},
          selectedEvent: null,
        ));
      } else {
        emit(state.copyWith(
          forwardNotes: selectedMessages,
        ));
      }
    }
  }

  void forwardNotes() async {
    for (var note in state.notes) {
      for (var id in state.forwardNotes) {
        if (id == note.id!) {
          await _dbProvider.deleteNote(note.eventId, note.id!);
          await _dbProvider
              .createNote(note.copyWith(eventId: state.selectedEvent!.id));
        }
      }
    }
    emit(state.copyWith(
      status: ChatStatus.primary,
      forwardNotes: {},
      selectedEvent: null,
    ));
  }

  Future<String> imageURL(String imageName) async {
    return await _storage.ref('images/$imageName').getDownloadURL();
  }
}
