import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_provider.dart';
import '../../models/chat.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            listOfChats: [],
            events: [],
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        listOfChats: await DatabaseProvider.db.getChats(),
        events: await DatabaseProvider.db.getEvents(),
      ),
    );
  }

  void addChat(Chat chat) {
    state.listOfChats.add(chat);
    DatabaseProvider.db.insertChat(chat);
    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }

  void remove(String title) {
    DatabaseProvider.db.removeChat(
        state.listOfChats.where((element) => element.category == title).first);
    state.listOfChats.removeWhere((element) => element.category == title);

    emit(
      state.copyWith(
        listOfChats: state.listOfChats,
      ),
    );
  }
}
