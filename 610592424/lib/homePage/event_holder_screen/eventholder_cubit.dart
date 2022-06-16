import 'package:bloc/bloc.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';
import 'package:diploma/data_base/firebase_provider.dart';
import 'eventholder_state.dart';

class EventHolderCubit extends Cubit<EventHolderState> {
  late final FireBaseProvider _db;

  EventHolderCubit() : super(EventHolderState([])){
    _db = FireBaseProvider();
  }

  void init() async => emit(EventHolderState(await _db.getAllEventHolders()));

  Future<EventHolder> getEventHolder(int id) async {
    return await _db.getEventHolder(id);
  }

  Future<String> getEventHolderLastEventText(int id) async {
    List<Event> events = await _db.getAllEventsForEventHolder(id);
    return events.last.text;
  }

  void addEventHolder(EventHolder tempEventHolder) async {
    await _db.addEventHolder(
      EventHolder.withoutId(
        tempEventHolder.title,
        tempEventHolder.iconIndex,
      ),
    );

    init();
  }

  void editEventHolder(EventHolder newEventHolder){
    _db.updateEventHolder(newEventHolder);

    init();
  }

  void deleteEventHolder(int id){
    _db.deleteEventHolder(id);

    init();
  }
}
