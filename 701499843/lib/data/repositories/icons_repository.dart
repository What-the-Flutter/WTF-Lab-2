import '../../models/event_icon.dart';
import '../firebase_provider.dart';

class IconsRepository {
  final FirebaseProvider _db;
  IconsRepository(this._db);

  Future<List<EventIcon>> getIcons() async {
    return await _db.getIcons();
  }

  void insertIcons(List<EventIcon> list) {
    for (final element in list) {
      _db.insertIcon(element);
    }
  }
}
