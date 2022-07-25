import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/app_state.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/message.dart';
import '../../../domain/models/page_controller.dart' as models;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  HomeCubit()
      : super(HomeState(
          pageController: models.PageController(),
          appState: AppState(chatEventId: ''),
        ));

  void changePage(int currentPage) {
    emit(state.copyWith(
      pageController: state.pageController.copyWith(
        currentPage: currentPage,
      ),
    ));
  }

  Future<void> init() async {
    _readEvents().listen((events) {
      emit(state.copyWith(events: events));
    });
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _readAppState(docAppState);

    emit(state.copyWith(appState: appState));
  }

  Future<void> removeEvent(String id) async {
    var docEvent = _instance.collection('events').doc(id);
    docEvent.delete();

    var messagesSubscription = _readMessages().listen((messages) {
      for (var message in messages) {
        if (message.eventId == id) {
          _instance.collection('messages').doc(message.id).delete();
        }
      }
    });

    messagesSubscription.cancel();
  }

  Future<void> likeEvent(int index, String id) async {
    var docEvent = _instance.collection('events').doc(id);
    var isFavorive = state.events[index].isFavorite ? false : true;
    docEvent
        .update(state.events[index].copyWith(isFavorite: isFavorive).toMap());
  }

  Future<void> setAppState(String eventId) async {
    var docAppState = _instance.collection('appState').doc('appState');
    var appState = await _readAppState(docAppState);
    docAppState.update(appState.copyWith(chatEventId: eventId).toMap());
  }

  Stream<List<Event>> _readEvents() => _instance
      .collection('events')
      .orderBy('isFavorite', descending: true)
      .snapshots()
      .map((event) =>
          event.docs.map((doc) => Event.fromMap(doc.data())).toList());

  Stream<List<Message>> _readMessages() => _instance
      .collection('messages')
      .orderBy('date', descending: true)
      .snapshots()
      .map((messages) =>
          messages.docs.map((doc) => Message.fromMap(doc.data())).toList());

  Future<AppState> _readAppState(
      DocumentReference<Map<String, dynamic>> docAppState) async {
    var appStateSnapshot = await docAppState.snapshots().first;
    var appStateMap = appStateSnapshot.data();
    var appState = AppState.fromMap(appStateMap!);
    return appState;
  }
}
