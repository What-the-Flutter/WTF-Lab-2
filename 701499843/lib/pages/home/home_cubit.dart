import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/chats_repository.dart';
import '../../data/repositories/events_repository.dart';
import '../../data/repositories/icons_repository.dart';
import '../../models/chat.dart';
import '../../models/event.dart';
import '../../models/event_icon.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ChatsRepository chatsRepository;
  final EventsRepository eventsRepository;
  final IconsRepository iconsRepository;
  HomeCubit(
    this.chatsRepository,
    this.eventsRepository,
    this.iconsRepository,
  ) : super(
          HomeState(
            listOfChats: [],
            events: [],
          ),
        );

  void updateList() async {
    emit(
      state.copyWith(
        events: await eventsRepository.getEvents(),
      ),
    );
  }

  void init() async {
    addIcons();
    addChats();
    addEvents();

    emit(
      state.copyWith(
        listOfChats: await chatsRepository.getChats(),
        events: await eventsRepository.getEvents(),
      ),
    );
  }

  void addChat(Chat chat) {
    state.listOfChats.add(chat);
    chatsRepository.insertChat(chat);
    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }

  void remove(String title) {
    chatsRepository.removeChat(
        state.listOfChats.where((element) => element.category == title).first);
    state.listOfChats.removeWhere((element) => element.category == title);

    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }

  void addChats() {
    chatsRepository.insertChats(
      <Chat>[
        Chat(
          id: 0,
          category: 'Travel',
          icon: 12,
        ),
        Chat(
          id: 1,
          category: 'Family',
          icon: 13,
        ),
        Chat(
          id: 2,
          category: 'Sports',
          icon: 14,
        ),
      ],
    );
  }

  void addEvents() {
    eventsRepository.insertEvents(<Event>[
      Event(
        id: 0,
        category: 'Travel',
        description: 'qqqq',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
      Event(
        id: 1,
        category: 'Family',
        description: 'wwww',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
      Event(
        id: 2,
        category: 'Sports',
        description: 'eeee',
        isFavorite: false,
        isSelected: false,
        timeOfCreation: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      ),
    ]);
  }

  void addIcons() {
    iconsRepository.insertIcons(
      List.generate(
        11,
        (index) => EventIcon(id: index, icon: index),
      ),
    );
  }
}
