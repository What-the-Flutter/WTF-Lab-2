import '../models/event.dart';
import '../models/event_category.dart';

abstract class DataBaseRepository {
  Future<void> addCategory(EventCategory event);
  Future<void> removeCategory(String key);
  Future<void> renameCategory(String key, String newTitle, String oldTitle);
  Future<void> pinCategory(String key);
  Future<void> unpinCategory(String key);
  Future<void> addEvent(Event event);
  Future<void> removeEvent(String key);
  Future<void> renameEvent(String key, String newTitle);
  Future<void> bookmarkEvent(String key, bool isFavorite);
  Future<void> moveEvent(String key, String newCategory);
  Future<void> eventSelected(String key);
  Future<void> eventNotSelected(String key);
  Future<void> deleteDB();
  Future<void> setAuthKey(bool key);
  Future<bool?> getAuthKey();
  Future<String?> getImageUrl(String name);
  Future<List<EventCategory>> getCategorys();
  Future<List<Event>> getEvents();
  Future<List<Event>> updateEvents(List<Event> oldList);
}
