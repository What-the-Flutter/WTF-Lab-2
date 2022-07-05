import 'package:bloc/bloc.dart';
import 'package:diploma/data_base/repositories/eventholders_repository.dart';
import 'package:diploma/data_base/repositories/events_repository.dart';
import 'package:diploma/models/event_holder.dart';
import 'package:diploma/models/event_scale.dart';
import 'package:time_machine/time_machine.dart';

import 'package:diploma/models/event.dart';
import 'summary_stats_state.dart';

class SummaryStatsCubit extends Cubit<SummaryStatsState> {
  late final EventsRepository _eventsRepo;
  late final EventHoldersRepository _eventHoldersRepo;

  SummaryStatsCubit()
      : super(SummaryStatsState(
          [],
          [],
          [],
          'Last 30 days',
        )) {
    _eventsRepo = EventsRepository();
    _eventHoldersRepo = EventHoldersRepository();
    updateChart();
  }

  Future<List<EventHolder>> get getEventHoldersFiltersList async =>
      await _eventHoldersRepo.loadAllEventHolders();

  void setNewPeriod(String newPeriod) {
    emit(state.copyWith(selectedPeriod: newPeriod));
    updateChart();
  }

  void onEventholderFilterTap(int id) {
    if (isEventholderSelected(id)) {
      state.eventHoldersFilter.removeWhere((element) => element == id);
    } else {
      state.eventHoldersFilter.add(id);
    }
    emit(state.copyWith());
  }

  bool isEventholderSelected(int id) {
    return state.eventHoldersFilter.any((element) => element == id);
  }

  int fetchEventsAmount() {
    var result = 0;
    for(var element in state.totalEventsScales){
      result += element.amount;
    }
    return result;
  }

  int fetchEventsWithLabelAmount() {
    var result = 0;
    for(var element in state.eventsWithLabelScales){
      result += element.amount;
    }
    return result;
  }

  Future<List<Event>> _fetchEventsWithFilter() async {
    if (state.eventHoldersFilter.isNotEmpty) {
      final List<Event> _events = [];
      for (var id in state.eventHoldersFilter) {
        _events.addAll(await _eventsRepo.getAllEventsForEventHolder(id));
      }
      _events.sort((a, b) => a.eventId.compareTo(b.eventId));
      return _events;
    } else {
      return await _eventsRepo.loadAllEvents();
    }
  }

  List<Event> _extractEventsWithLabel(List<Event> allEvents) {
    return allEvents.where((element) => element.iconIndex != null).toList();
  }

  void updateChart() async {
    final allEvents = await _fetchEventsWithFilter();
    final labelEvents = _extractEventsWithLabel(allEvents);
    switch(state.selectedPeriod){
      case 'Today':
        _loadTimeChartForToday(allEvents: allEvents, labelEvents: labelEvents);
        break;
      case 'Last 7 days':
        _loadTimeChart(allEvents: allEvents, labelEvents: labelEvents, days: 7);
        break;
      case 'Last 30 days':
        _loadTimeChart(allEvents: allEvents, labelEvents: labelEvents, days: 30);
        break;
      case 'Last year':
        _loadTimeChartForYear(allEvents: allEvents, labelEvents: labelEvents);
        break;
    }
  }

  void _loadTimeChart({
    required List<Event> allEvents,
    required List<Event> labelEvents,
    required int days,
  }) {
    final List<EventScale> allEventsScale = [];
    final List<EventScale> allLabelEventsScale = [];
    for (var i = 0; i <= days; i++) {
      allEventsScale.add(EventScale(
        amount: allEvents
            .where((element) =>
                DateTime.now().difference(element.timeOfCreation!).inDays == i)
            .length,
        period: '$i',
      ));
      allLabelEventsScale.add(EventScale(
        amount: labelEvents
            .where((element) =>
                DateTime.now().difference(element.timeOfCreation!).inDays == i)
            .length,
        period: '$i',
      ));
    }
    emit(state.copyWith(
      totalEventsScales: allEventsScale,
      eventsWithLabelScales: allLabelEventsScale,
    ));
  }

  void _loadTimeChartForYear({
    required List<Event> allEvents,
    required List<Event> labelEvents,
  }) {
    final List<EventScale> allEventsScale = [];
    final List<EventScale> allLabelEventsScale = [];
    for (var i = 0; i <= 12; i++) {
      allEventsScale.add(EventScale(
        amount: allEvents.where((element) {
          final elementDate = LocalDate.dateTime(element.timeOfCreation!);
          return elementDate.periodUntil(LocalDate.today()).months == i;
        }).length,
        period: '$i',
      ));
      allLabelEventsScale.add(EventScale(
        amount: labelEvents.where((element) {
          final elementDate = LocalDate.dateTime(element.timeOfCreation!);
          return elementDate.periodUntil(LocalDate.today()).months == i;
        }).length,
        period: '$i',
      ));
    }
    emit(state.copyWith(
      totalEventsScales: allEventsScale,
      eventsWithLabelScales: allLabelEventsScale,
    ));
  }

  void _loadTimeChartForToday({
    required List<Event> allEvents,
    required List<Event> labelEvents,
  }) {
    final List<EventScale> allEventsScale = [
      EventScale(
        amount: allEvents
            .where((element) =>
                DateTime.now().difference(element.timeOfCreation!).inDays == 0)
            .length,
        period: '1',
      )
    ];
    final List<EventScale> allLabelEventsScale = [
      EventScale(
        amount: labelEvents
            .where((element) =>
                DateTime.now().difference(element.timeOfCreation!).inDays == 0)
            .length,
        period: '1',
      )
    ];
    emit(state.copyWith(
      totalEventsScales: allEventsScale,
      eventsWithLabelScales: allLabelEventsScale,
    ));
  }
}
