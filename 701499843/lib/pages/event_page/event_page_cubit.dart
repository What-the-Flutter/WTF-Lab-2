import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/database_provider.dart';
import '../../models/event.dart';
import 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  List<Event> eventsFromDb = [];

  EventPageCubit()
      : super(
          EventPageState(
            events: [],
            editMode: false,
            favoriteMode: false,
            image: null,
            selectedIndex: -1,
            writingMode: false,
            searchMode: false,
            chats: [],
            searchedEvents: [],
            migrateCategory: '',
            isScrollbarVisible: false,
            selectedCategory: '',
            title: '',
          ),
        );

  void initValues(String title) async {
    eventsFromDb = await DatabaseProvider.db.getEvents();
    emit(state.copyWith(
      title: title,
      selectedCategory: title,
      events: eventsFromDb
          .where((element) => element.category.contains(title))
          .toList(),
      chats: await DatabaseProvider.db.getChats(),
    ));
  }

  void copy() {
    state.events
        .where((element) => element.isSelected == true)
        .forEach((element) {
      element.copyWith(
        isFavorite: true,
      );
    });
    for (var element in state.events) {
      element = element.copyWith(
        isSelected: false,
      );
    }
    emit(
      state.copyWith(
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  void tapOnEvent(int index, TextEditingController controller) {
    List<Event> events;
    if (state.searchMode) {
      events = state.events
          .where((element) => element.description.contains(controller.text))
          .toList();
    } else {
      events = state.events;
    }

    if (events.where((element) => element.isSelected == true).isNotEmpty) {
      if (events[index].isSelected) {
        events[index] = events[index].copyWith(
          isSelected: false,
        );
      } else {
        events[index] = events[index].copyWith(
          isSelected: true,
        );
      }
    } else {
      if (events[index].isFavorite) {
        events[index] = events[index].copyWith(
          isFavorite: false,
        );
      } else {
        events[index] = events[index].copyWith(
          isFavorite: true,
        );
      }
    }
    emit(
      state.copyWith(
        events: events
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  Future attachImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;
    emit(
      state.copyWith(image: image.path),
    );
  }

  void changeWritingMode(String text) => emit(
        state.copyWith(writingMode: text.isNotEmpty),
      );

  Future<void> addNewEvent(String text, String category) async {
    if (text.replaceAll('\n', '').isEmpty) {
      return;
    }
    if (state.editMode) {
      var event = state.events[state.selectedIndex];
      state.events.where((element) => element.isSelected == true).forEach(
        (element) {
          element = element.copyWith(
            isSelected: false,
          );
        },
      );
      state.events[state.selectedIndex] = event.copyWith(
        description: text,
      );
    } else {
      var event = Event();
      state.image == null
          ? event = Event(
              description: text,
              image: null,
              category: state.selectedCategory,
            )
          : Event(
              description: text,
              image: state.image,
              category: state.selectedCategory,
            );
      DatabaseProvider.db.insertEvent(event);
      eventsFromDb = await DatabaseProvider.db.getEvents();
    }
    emit(
      state.copyWith(
        editMode: false,
        image: null,
        writingMode: false,
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  void changeFavoriteMode() => emit(
        state.copyWith(
          favoriteMode: !state.favoriteMode,
        ),
      );

  void copyEventText(TextEditingController controller) {
    controller.text = (state.events[state.selectedIndex].description);
    for (var element in state.events) {
      element = element.copyWith(
        isSelected: false,
      );
    }
    emit(
      state.copyWith(
        editMode: true,
        events: state.events,
      ),
    );
  }

  void setSelectedIndex(int index, TextEditingController controller) {
    tapOnEvent(index, controller);
    emit(
      state.copyWith(selectedIndex: index),
    );
  }

  void selectEvent(int index) async {
    /*DatabaseProvider.db.updateEvent(
      state.events[index],
      state.events[index].copyWith(
        isSelected: true,
      ),
    );*/
    print('object');
    eventsFromDb = await DatabaseProvider.db.getEvents();
    emit(
      state.copyWith(
        editMode: true,
        selectedIndex: index,
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  void removeEvents() {
    DatabaseProvider.db.removeEvents(
      eventsFromDb.where((element) => element.isSelected == true).toList(),
    );

    emit(
      state.copyWith(
        events: eventsFromDb
            .where(
              (element) => element.category.contains(
                state.title,
              ),
            )
            .toList(),
      ),
    );
  }

  void changeSearchMode() {
    emit(
      state.copyWith(
        searchMode: !state.searchMode,
      ),
    );
  }

  void changeEditMode() {
    emit(
      state.copyWith(
        editMode: !state.editMode,
      ),
    );
  }

  void setSearchMode(bool isSearched) {
    emit(
      state.copyWith(searchMode: isSearched),
    );
  }

  void search(String text) => emit(
        state.copyWith(
            searchedEvents: state.events
                .where((element) => element.description.contains(text))
                .toList()),
      );

  void setMigrateCategory(Object? index) => emit(
        state.copyWith(migrateCategory: index as String),
      );

  void migrate() {
    for (var element in state.events) {
      if (element.isSelected) {
        DatabaseProvider.db.updateEvent(
          eventsFromDb[eventsFromDb.indexOf(element)],
          element.copyWith(
            isSelected: false,
            category: state.migrateCategory,
          ),
        );
      }
    }

    emit(
      state.copyWith(
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  void selectCategory(int index) => emit(
        state.copyWith(
          selectedCategory: state.chats[index].category,
        ),
      );

  void changeVisibility() => emit(
        state.copyWith(isScrollbarVisible: !state.isScrollbarVisible),
      );

  void cancelSelection() {
    for (var element in state.events) {
      if (element.isSelected) {
        DatabaseProvider.db.updateEvent(
          element,
          element.copyWith(
            isSelected: false,
          ),
        );
      }
    }

    emit(
      state.copyWith(
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }

  void removeEvent(int index) {
    DatabaseProvider.db.removeEvent(
      state.events[index],
    );

    emit(
      state.copyWith(
        events: eventsFromDb
            .where((element) => element.category.contains(state.title))
            .toList(),
      ),
    );
  }
}
