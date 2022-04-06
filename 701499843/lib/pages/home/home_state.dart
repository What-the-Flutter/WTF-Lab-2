import '../../models/chat.dart';
import '../../models/event.dart';

class HomeState {
  final List<Chat> listOfChats;
  late final List<Event> events;

  HomeState({
    required this.listOfChats,
    required this.events,
  });

  HomeState copyWith({List<Chat>? listOfChats, List<Event>? events}) {
    return HomeState(
      listOfChats: listOfChats ?? this.listOfChats,
      events: events ?? this.events,
    );
  }
}
