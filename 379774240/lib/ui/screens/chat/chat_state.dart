part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final bool isEditing;
  final bool isSearchBarOpen;
  final bool isEventBarOpen;
  final bool isForward;

  final int editingMessageIndex;
  final int selectedItemInEventBar;

  final Event event;

  final Set<int> forwardMessagesIndex;
  final List<Event> events;
  final List<Message> searchingMessages;
  final List<Message> messages;

  const ChatState({
    this.isEditing = false,
    this.isSearchBarOpen = false,
    this.isEventBarOpen = false,
    this.isForward = false,
    this.editingMessageIndex = -1,
    this.selectedItemInEventBar = -1,
    required this.event,
    this.forwardMessagesIndex = const {},
    this.events = const [],
    this.searchingMessages = const [],
    this.messages = const [],
  });

  @override
  List<Object?> get props => [
        isEditing,
        isSearchBarOpen,
        isEventBarOpen,
        isForward,
        editingMessageIndex,
        selectedItemInEventBar,
        event,
        forwardMessagesIndex,
        events,
        searchingMessages,
        messages
      ];

  ChatState copyWith({
    bool? isEditing,
    bool? isSearchBarOpen,
    bool? isEventBarOpen,
    bool? isForward,
    int? editingMessageIndex,
    int? selectedItemInEventBar,
    Event? event,
    Set<int>? forwardMessagesIndex,
    List<Event>? events,
    List<Message>? searchingMessages,
    final List<Message>? messages,
  }) {
    return ChatState(
      isEditing: isEditing ?? this.isEditing,
      isSearchBarOpen: isSearchBarOpen ?? this.isSearchBarOpen,
      isEventBarOpen: isEventBarOpen ?? this.isEventBarOpen,
      isForward: isForward ?? this.isForward,
      editingMessageIndex: editingMessageIndex ?? this.editingMessageIndex,
      selectedItemInEventBar:
          selectedItemInEventBar ?? this.selectedItemInEventBar,
      event: event ?? this.event,
      forwardMessagesIndex: forwardMessagesIndex ?? this.forwardMessagesIndex,
      events: events ?? this.events,
      searchingMessages: searchingMessages ?? this.searchingMessages,
      messages: messages ?? this.messages,
    );
  }
}
