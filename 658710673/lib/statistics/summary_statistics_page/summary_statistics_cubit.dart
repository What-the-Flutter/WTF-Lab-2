import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/firebase_provider.dart';
import '../../models/category.dart';
import '../../models/event.dart';
import '../../utils/constants.dart';
import 'summary_statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final User? _user;
  late final FirebaseProvider _db = FirebaseProvider(user: _user);

  StatisticsCubit({required User? user})
      : _user = user,
        super(
          StatisticsState(
            summaryTotalList: [],
            summaryBookmarkList: [],
            timePeriod: 'Past 30 days',
          ),
        );

  void selectTimePeriod(String timePeriod) {
    emit(
      state.copyWith(
        timePeriod: timePeriod,
      ),
    );
  }

  List<Event> _selectedPageList(
    List<Event> eventList,
    List selectedPageList,
  ) {
    final eventByPagesList = <Event>[];
    for (var i = 0; i < selectedPageList.length; i++) {
      final tempPagesList =
          eventList.where((event) => event.category == selectedPageList[i].id).toList();
      eventByPagesList.addAll(tempPagesList);
    }
    return eventByPagesList;
  }

  void showTotalListThisYear(List? result) async {
    final eventList = await _db.getAllEvents();
    var eventByPagesList = <Event>[];
    var yearEventList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      yearEventList = eventByPagesList
          .where((event) => event.timeOfCreation.year == DateTime.now().year)
          .toList();
    } else {
      yearEventList =
          eventList.where((event) => event.timeOfCreation.year == DateTime.now().year).toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: yearEventList,
      ),
    );
  }

  void showBookmarkListThisYear(List? result) async {
    final eventList = await _db.getAllEvents();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = <Category>[];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isBookmarked == true && event.timeOfCreation.year == DateTime.now().year)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isBookmarked == true && event.timeOfCreation.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showTotalListToday(List? result) async {
    final eventList = await _db.getAllEvents();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) => event.timeOfCreation.day == DateTime.now().day)
          .toList();
    } else {
      todayEventList =
          eventList.where((event) => event.timeOfCreation.day == DateTime.now().day).toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListToday(List? result) async {
    final eventList = await _db.getAllEvents();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isBookmarked == true && event.timeOfCreation.day == DateTime.now().day)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isBookmarked == true && event.timeOfCreation.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showTotalListPastMonth(List? result) async {
    final eventList = await _db.getAllEvents();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) =>
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInMonth)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) =>
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInMonth)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastMonth(List? result) async {
    final eventList = await _db.getAllEvents();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isBookmarked == true &&
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInMonth)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isBookmarked == true &&
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInMonth)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showTotalListPastWeek(List? result) async {
    final eventList = await _db.getAllEvents();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) =>
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInWeek)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) =>
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInWeek)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastWeek(List? result) async {
    final eventList = await _db.getAllEvents();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isBookmarked == true &&
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInWeek)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isBookmarked == true &&
              DateTime.now().difference(event.timeOfCreation).inDays <= StatisticsConst.daysInWeek)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }
}
