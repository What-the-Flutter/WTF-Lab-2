part of 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final _firebaseRepository = FirebaseRepository();

  StatisticsCubit() : super(StatisticsState());

  void init() async {
    final mList = await _firebaseRepository.getAllMessages();
    setMessagesList(mList);
  }

  void selectTimePeriod(String timePeriod) {
    emit(
      state.copyWith(
        selectedPeriod: timePeriod,
      ),
    );
    countStatisticsData();
  }

  void countStatisticsData() {
    int? dayDifference;
    int? yearDifference;

    switch (state.selectedPeriod) {
      case 'week':
        dayDifference = 8;
        yearDifference = 0;
        break;
      case 'month':
        dayDifference = 31;
        yearDifference = 0;
        break;
      case '365':
        dayDifference = 0;
        yearDifference = 1;
        break;
    }

    final countOfMessages = state.messages
        .where(
          (e) =>
              DateFormat().add_yMMMd().parse(e.createMessageTime).isAfter(
                    DateTime(
                      DateTime.now().year - yearDifference!,
                      DateTime.now().month,
                      DateTime.now().day - dayDifference!,
                    ),
                  ) &&
              DateFormat().add_yMMMd().parse(e.createMessageTime).isBefore(
                    DateTime(
                      DateTime.now().year + yearDifference,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                    ),
                  ),
        )
        .length;

    setCountOfMessages(countOfMessages);
  }

  void setCountOfMessages(int count) => emit(
        state.copyWith(
          countOfMessages: count,
        ),
      );

  void setMessagesList(List<Message> mess) => emit(
        state.copyWith(
          messages: mess,
        ),
      );
}
