part of 'chat_cubit.dart';

@immutable
abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  final String text = 'Here is empty';

  const ChatInitial();
}

class ChatError extends ChatState {
  final String errorMessage = 'Error';

  const ChatError();
}

class ChatLoadingData extends ChatState {
  const ChatLoadingData();
}

class ChatLoadedData extends ChatState {
  final List<Event> events;

  const ChatLoadedData({
    required this.events,
  });

  void addEvent(String message, String date) {
    events.add(Event(message: message, date: date));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatLoadedData && listEquals(other.events, events);
  }

  @override
  int get hashCode => events.hashCode;

  ChatLoadedData copyWith({
    List<Event>? events,
  }) {
    return ChatLoadedData(
      events: events ?? this.events,
    );
  }
}
