import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/chats_repository.dart';
import '../../data/repositories/events_repository.dart';
import '../../models/chat.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    ChatsRepository chatsRepository,
    EventsRepository eventsRepository,
  ) : super(
          HomeState(
            chatsRepository: chatsRepository,
            eventsRepository: eventsRepository,
            listOfChats: [],
            events: [],
          ),
        );

  void updateList() async {
    emit(
      state.copyWith(
        events: await state.eventsRepository.getEvents(),
      ),
    );
  }

  void init() async {
    emit(
      state.copyWith(
        listOfChats: await state.chatsRepository.getChats(),
        events: await state.eventsRepository.getEvents(),
      ),
    );
  }

  void addChat(Chat chat) {
    state.listOfChats.add(chat);
    state.chatsRepository.insertChat(chat);
    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }

  void remove(String title) {
    state.chatsRepository.removeChat(
        state.listOfChats.where((element) => element.category == title).first);
    state.listOfChats.removeWhere((element) => element.category == title);

    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }
}
