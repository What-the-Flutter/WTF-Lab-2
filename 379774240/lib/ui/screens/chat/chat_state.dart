part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final ChatStatus status;
  final XFile? image;
  final Event? event;
  final List<Note> notes;
  final List<Note> searchingNotes;
  final List<Event> events;
  final Note? editingNote;
  final Event? selectedEvent;
  final Set<String> forwardNotes;

  const ChatState({
    this.status = ChatStatus.primary,
    this.image,
    this.event,
    this.notes = const [],
    this.searchingNotes = const [],
    this.events = const [],
    this.editingNote,
    this.selectedEvent,
    this.forwardNotes = const {},
  });

  @override
  List<Object?> get props => [
        status,
        image,
        event,
        notes,
        searchingNotes,
        events,
        editingNote,
        selectedEvent,
        forwardNotes,
      ];

  ChatState copyWith({
    ChatStatus? status,
    XFile? image,
    Event? event,
    List<Note>? notes,
    List<Note>? searchingNotes,
    List<Event>? events,
    Note? editingNote,
    Event? selectedEvent,
    Set<String>? forwardNotes,
  }) {
    return ChatState(
      status: status ?? this.status,
      image: image ?? this.image,
      event: event ?? this.event,
      notes: notes ?? this.notes,
      searchingNotes: searchingNotes ?? this.searchingNotes,
      events: events ?? this.events,
      editingNote: editingNote ?? this.editingNote,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      forwardNotes: forwardNotes ?? this.forwardNotes,
    );
  }
}

enum ChatStatus {
  primary,
  editingMessage,
  sendTo,
  searchingNotes,
  forwarding,
  noteWithImage,
}
