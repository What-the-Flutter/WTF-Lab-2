import '../../models/event.dart';
import '../../models/event_category.dart';

class CategoryListState {
  final List<Event> allEvents;
  final bool searchMode;
  final String searchResult;
  final bool authKey;
  final List<EventCategory> categoryList;

  CategoryListState( {
    this.authKey = false,
    this.searchResult = '',
    this.searchMode = false,
    required this.categoryList,
    required this.allEvents,
  });
}
