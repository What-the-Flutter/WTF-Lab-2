import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';
import 'package:diploma/data_base/firebase_provider.dart';
import 'eventholder_state.dart';

class EventHolderCubit extends Cubit<EventHolderState> {
  final User _user;
  late final FireBaseProvider _db;

  EventHolderCubit(this._user) : super(EventHolderState([])){
    _db = FireBaseProvider(_user);
  }

  void init() async{
    emit(EventHolderState(await _db.getAllEventHolders()));
  }

  User get getUser => _user;

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
