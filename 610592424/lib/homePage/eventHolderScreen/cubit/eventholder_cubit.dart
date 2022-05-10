import 'package:bloc/bloc.dart';

import 'package:diploma/homePage/models/event.dart';
import 'package:diploma/homePage/models/event_holder.dart';
import 'package:diploma/homePage/theme/theme_widget.dart';
import 'package:flutter/material.dart';
import 'eventholder_state.dart';
import 'package:diploma/homePage/nominalDataBase/db_context.dart';
import 'package:diploma/homePage/nominalDataBase/shared_preferences_provider.dart';

class EventHolderCubit extends Cubit<EventHolderState> {
  EventHolderCubit() : super(EventHolderState([]));

  final DBContext _db = DBContext();

  void init() async{
    emit(EventHolderState(await _db.getAllEventHolders()));
  }

  Future<EventHolder> getEventHolder(int id) async{
    return await _db.getEventHolder(id);
  }

  Future<String> getEventHolderLastEventText(int id) async{
    List<Event> events = await _db.getAllEventsForEventHolder(id);
    return events.last.text;
  }

  void addEventHolder(EventHolder tempEventHolder) async{
    await _db.addEventHolder(
      EventHolder(
        eventholderId: -1,
        title: tempEventHolder.title,
        iconIndex: tempEventHolder.iconIndex,
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

  void changeTheme(BuildContext context) async{
    await SharedPreferencesProvider.init();
    var _provider = SharedPreferencesProvider();
    _provider.changeTheme();
    GeneralTheme.of(context).myTheme.themeData = _provider.getTheme();
  }
}
