import 'package:diploma/models/event_holder.dart';
import 'package:diploma/data_base/firebase_provider.dart';

class EventHoldersRepository {
  late final FireBaseProvider _db;

  EventHoldersRepository() {
    _db = FireBaseProvider();
  }

  Future<List<EventHolder>> loadAllEventHolders([exceptId = -1]) async {
    return await _db.fetchAllEventHolders(exceptId);
  }

  Future<EventHolder> fetchEventHolder(int id) async {
    return await _db.fetchEventHolder(id);
  }

  Future<String> fetchEventHolderLastEventText(int id) async {
    final events = await _db.fetchAllEventsForEventHolder(id);
    return events.last.text;
  }

  Future<void> addEventHolder(EventHolder tempEventHolder) async {
    await _db.addEventHolder(
      EventHolder.withoutId(
        tempEventHolder.title,
        tempEventHolder.iconIndex,
      ),
    );
  }

  Future<void> updateEventHolder(EventHolder newEventHolder) async {
    await _db.updateEventHolder(newEventHolder);
  }

  Future<void> deleteEventHolder(int id) async {
    await _db.deleteEventHolder(id);
  }
}
