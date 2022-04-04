import '../models/event.dart';
import '../models/event_category.dart';

abstract class DataBaseRepository {
  Future<void> addCategory(EventCategory event) async {}
  Future<void> removeCategory(String key) async {}
  Future<void> renameCategory(String key, String newTitle) async {}
  Future<void> pinCategory(String key) async {}
  Future<void> unpinCategory(String key) async {}
  Future<void> addEvent(Event event) async {}
  Future<void> removeEvent(String key) async {}
  Future<void> renameEvent(String key, String newTitle) async {}
  Future<void> bookmarkEvent(String key, bool isFavorite) async {}
  Future<void> moveEvent(String key, String newCategory) async {}
  Future<void> eventSelected(String key) async {}
  Future<void> eventNotSelected(String key) async {}
  Future<void> deleteDB() async {}
  Future<void> setAuthKey(bool key) async {}
  Future<bool?> getAuthKey() async {
    return null;
  }

  Future<String?> getImageUrl(String name) async {
    return null;
  }
}
