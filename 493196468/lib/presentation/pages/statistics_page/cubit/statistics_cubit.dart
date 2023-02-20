import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../repo/firebase/messages_repository.dart';
import '../../../../utils/message.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final MessagesRepository _messagesRepository;

  StatisticsCubit(this._messagesRepository)
      : super(
          StatisticsState(
            [],
            Period.pastThirtyDays,
          ),
        ) {
    _init();
  }

  void _init() async {
    updateStateFromRepo();
    _messagesRepository.listenForUpdates(onUpdate: updateStateFromRepo);
  }

  void updateStateFromRepo() async {
    final messages = await _messagesRepository.getAllMessages();
    final newState = StatisticsState(messages, state.period);

    return emit(newState);
  }

  List<Message> _usePeriodFilter() {
    var messages = <Message>[];
    switch (state.period) {
      case Period.today:
        {
          messages = state.messages
              .where((message) => message.sentTime
                  .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
              .toList();
        }
        break;
      case Period.lastSevenDays:
        {
          messages = state.messages
              .where((message) => message.sentTime
                  .isAfter(DateTime.now().subtract(const Duration(days: 7))))
              .toList();
        }
        break;
      case Period.pastThirtyDays:
        {
          messages = state.messages
              .where((message) => message.sentTime
                  .isAfter(DateTime.now().subtract(const Duration(days: 30))))
              .toList();
        }
        break;
      case Period.thisYear:
        {
          messages = state.messages
              .where((message) => DateTime.now().year == message.sentTime.year)
              .toList();
        }
        break;
    }
    return messages;
  }

  void setPeriod(Period period) => emit(state.copyWith(period: period));

  int getTotalNumberOfMessages() {
    return _usePeriodFilter().length;
  }

  int getNumberOfMessagesNDaysBefore(int n) {
    return _usePeriodFilter()
        .where((element) =>
            DateTime.now().difference(element.sentTime).inDays == n)
        .length;
  }

  int getBookmarkedNumberOfMessagesNDaysBefore(int n) {
    return _usePeriodFilter()
        .where((element) =>
            element.isBookmarked &&
            DateTime.now().difference(element.sentTime).inDays == n)
        .length;
  }

  int getNumberOfMessagesNMonthBefore(int n) {
    return _usePeriodFilter()
        .where(
          (element) =>
              element.sentTime.month == n &&
              element.sentTime.year == DateTime.now().year,
        )
        .length;
  }

  int getBookmarkedNumberOfMessagesNMonthBefore(int n) {
    return _usePeriodFilter()
        .where(
          (element) =>
              element.isBookmarked &&
              element.sentTime.month == n &&
              element.sentTime.year == DateTime.now().year,
        )
        .length;
  }

  int getBookmarkedNumberOfMessages() {
    return _usePeriodFilter().where((element) => element.isBookmarked).length;
  }

  int getLabeledNumberOfMessages() {
    return 0;
  }

  int getAnswersNumberOfMessages() {
    return 0;
  }

  int getMoodNumberOfMessages() {
    return 0;
  }
}
