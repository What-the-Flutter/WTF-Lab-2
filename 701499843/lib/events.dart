import 'models/event.dart';

List<Event> getEvents() {
  return [
    Event(
      category: 'Travel',
      description: 'qqqq',
      isFavorite: false,
      isSelected: false,
    ),
    Event(
      category: 'Family',
      description: 'wwww',
      isFavorite: false,
      isSelected: false,
    ),
    Event(
      category: 'Sports',
      description: 'eeee',
      isFavorite: false,
      isSelected: false,
    ),
  ];
}
