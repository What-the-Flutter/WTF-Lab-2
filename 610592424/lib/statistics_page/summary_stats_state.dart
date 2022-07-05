import 'package:diploma/models/event_scale.dart';

class SummaryStatsState {
  final List<int> eventHoldersFilter;
  final List<EventScale> totalEventsScales;
  final List<EventScale> eventsWithLabelScales;
  final String selectedPeriod;

  SummaryStatsState(
    this.eventHoldersFilter,
    this.totalEventsScales,
    this.eventsWithLabelScales,
    this.selectedPeriod,
  );

  SummaryStatsState copyWith({
    List<int>? eventHoldersFilter,
    List<EventScale>? totalEventsScales,
    List<EventScale>? eventsWithLabelScales,
    String? selectedPeriod,
  }) {
    return SummaryStatsState(
      eventHoldersFilter ?? this.eventHoldersFilter,
      totalEventsScales ?? this.totalEventsScales,
      eventsWithLabelScales ?? this.eventsWithLabelScales,
      selectedPeriod ?? this.selectedPeriod,
    );
  }
}
