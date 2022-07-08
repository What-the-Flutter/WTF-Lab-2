import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/database_provider.dart';
import '../../../domain/models/app_state.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/page_controller.dart' as models;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          pageController: models.PageController(),
        ));

  Future<void> init() async {
    var events = await DatabaseProvider.instance.readEvents();
    DatabaseProvider.instance.createAppState(AppState(chatEventId: -1));

    var likedEvents = <Event>[];
    var unlikedEvents = <Event>[];
    for (var i = 0; i < events.length; i++) {
      if (events[i].isFavorite) {
        likedEvents.add(events[i]);
      } else {
        unlikedEvents.add(events[i]);
      }
    }
    events = likedEvents + unlikedEvents;
    emit(state.copyWith(events: events));
  }

  void changePage(int currentPage) {
    emit(state.copyWith(
      pageController: state.pageController.copyWith(
        currentPage: currentPage,
      ),
    ));
  }

  Future<void> removeEvent(int index) async {
    var event = state.events[index];
    await DatabaseProvider.instance.deleteEvent(event.id!);
    var events = await DatabaseProvider.instance.readEvents();

    var likedEvents = <Event>[];
    var unlikedEvents = <Event>[];
    for (var i = 0; i < events.length; i++) {
      if (events[i].isFavorite) {
        likedEvents.add(events[i]);
      } else {
        unlikedEvents.add(events[i]);
      }
    }
    events = likedEvents + unlikedEvents;
    emit(state.copyWith(events: events));
  }

  Future<void> likeEvent(int index) async {
    var event = state.events[index];
    event.isFavorite == true
        ? event = event.copyWith(isFavorite: false)
        : event = event.copyWith(isFavorite: true);
    await DatabaseProvider.instance.updateEvent(event);
    var events = await DatabaseProvider.instance.readEvents();

    var likedEvents = <Event>[];
    var unlikedEvents = <Event>[];
    for (var i = 0; i < events.length; i++) {
      if (events[i].isFavorite) {
        likedEvents.add(events[i]);
      } else {
        unlikedEvents.add(events[i]);
      }
    }
    events = likedEvents + unlikedEvents;
    emit(state.copyWith(events: events));
  }

  Future<void> setAppState(Event event) async {
    var appState = await DatabaseProvider.instance.readAppState();
    DatabaseProvider.instance.updateAppState(
      appState.copyWith(
        chatEventId: event.id,
      ),
    );
  }

  // void updateFromChatScreen(int index, Event event) {
  //   var events = List<Event>.from(state.events);
  //   events[index].copyWith(messages: event.messages);
  //   emit(state.copyWith(events: events));
  // }
}
