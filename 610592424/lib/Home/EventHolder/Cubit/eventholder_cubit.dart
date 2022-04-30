import 'package:bloc/bloc.dart';
import 'package:diploma/NewHome/EventHolder/Models/event_holder.dart';
import 'package:diploma/NewHome/NominalDataBase/event_holders_list.dart';

class EventHolderCubit extends Cubit<List<EventHolder>> {
  EventHolderCubit() : super(myEventHolders);

  EventHolder getEventHolder(int id){
    return myEventHolders.firstWhere((element) => element.id == id);
  }

  void addEventHolder(EventHolder tempEventHolder) {
    myEventHolders.add(
      EventHolder(
        id: myEventHolders.isNotEmpty ? myEventHolders.last.id + 1 : 0,
        events: [],
        title: tempEventHolder.title,
        pictureIndex: tempEventHolder.pictureIndex,
      ),
    );

    emit(myEventHolders.toList());
  }

  void editEventHolder(EventHolder newEventHolder){
    var oldEventHolder = myEventHolders
        .firstWhere((element) => element.id == newEventHolder.id);

    oldEventHolder.pictureIndex = newEventHolder.pictureIndex;
    oldEventHolder.title = newEventHolder.title;

    emit(myEventHolders.toList());
  }

  void deleteEventHolder(int id){
    myEventHolders.removeWhere((element) => element.id == id);

    emit(myEventHolders.toList());
  }
}
