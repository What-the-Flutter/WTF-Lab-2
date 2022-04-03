import '../../models/event_icon.dart';
import '../firebase_provider.dart';

class IconsRepository {
  final FirebaseProvider _db = FirebaseProvider();
  IconsRepository();

  Future<List<EventIcon>> getIcons() async {
    return await _db.getIcons();
  }
}
