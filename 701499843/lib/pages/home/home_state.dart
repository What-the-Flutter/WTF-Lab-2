import '../../data/repositories/chats_repository.dart';
import '../../data/repositories/events_repository.dart';
import '../../models/chat.dart';
import '../../models/event.dart';

class HomeState {
  final ChatsRepository chatsRepository;
  final EventsRepository eventsRepository;
  final List<Chat> listOfChats;
  late final List<Event> events;

  HomeState({
    required this.chatsRepository,
    required this.eventsRepository,
    required this.listOfChats,
    required this.events,
  });

  HomeState copyWith({List<Chat>? listOfChats, List<Event>? events}) {
    return HomeState(
      chatsRepository: chatsRepository,
      eventsRepository: eventsRepository,
      listOfChats: listOfChats ?? this.listOfChats,
      events: events ?? this.events,
    );
  }
}
