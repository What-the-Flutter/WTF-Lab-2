import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chats.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            listOfChats: chats(),
          ),
        );

  void addChat(Iterable<MapEntry<String, Icon>> chat) {
    state.listOfChats.addEntries(chat);
    emit(
      HomeState(
        listOfChats: state.listOfChats,
      ),
    );
  }

  void remove(String title) {
    state.listOfChats.removeWhere((key, value) => key == title);
    emit(
      HomeState(
        listOfChats: state.listOfChats,
      ),
    );
  }
}
