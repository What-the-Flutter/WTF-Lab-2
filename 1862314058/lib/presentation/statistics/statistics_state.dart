import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/message.dart';
import '../../repository/firebase_repository.dart';

part 'statistics_cubit.dart';

class StatisticsState {
  final List<Message> messages;
  final String selectedPeriod;
  final int countOfMessages;

  StatisticsState({
    this.messages = const [],
    this.selectedPeriod = 'week',
    this.countOfMessages = 0,
  });

  StatisticsState copyWith({
    List<Message>? messages,
    String? selectedPeriod,
    int? countOfMessages,
  }) {
    return StatisticsState(
      messages: messages ?? this.messages,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      countOfMessages: countOfMessages ?? this.countOfMessages,
    );
  }
}
