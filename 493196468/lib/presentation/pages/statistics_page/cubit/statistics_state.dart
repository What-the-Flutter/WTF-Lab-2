part of 'statistics_cubit.dart';

enum Period {
  today,
  lastSevenDays,
  pastThirtyDays,
  thisYear,
}

class StatisticsState extends Equatable {
  final List<Message> messages;
  final Period period;

  StatisticsState(this.messages, this.period);

  StatisticsState copyWith({
    List<Message>? messages,
    Period? period,
  }) {
    return StatisticsState(
      messages ?? this.messages,
      period ?? this.period,
    );
  }

  @override
  String toString() {
    return '$messages, $period';
  }

  @override
  List<Object?> get props => [messages, period];
}
