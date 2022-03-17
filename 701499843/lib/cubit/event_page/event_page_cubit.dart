import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../chats.dart';
import '../../models/event.dart';
import '../../pages/home.dart';
import 'event_page_state.dart';

class EventPageCubit extends Cubit<EventPageState> {
  EventPageCubit(String title, List<Event> events)
      : super(
          EventPageState(
            events: events
                .where((element) => element.category.contains(title))
                .toList(),
            editMode: false,
            favoriteMode: false,
            image: null,
            selectedIndex: -1,
            writingMode: false,
            searchMode: false,
            chats: chats(),
            searchedEvents: [],
            migrateCategory: '',
            isScrollbarVisible: false,
            selectedCategory: title,
            title: title,
          ),
        );

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

    emitState();
  }

  void emitState() {
    emit(
      EventPageState(
        events:
            events.where((element) => element.category == state.title).toList(),
        writingMode: state.writingMode,
        editMode: state.editMode,
        favoriteMode: state.favoriteMode,
        selectedIndex: state.selectedIndex,
        searchMode: state.searchMode,
        chats: state.chats,
        searchedEvents: state.searchedEvents,
        migrateCategory: state.migrateCategory,
        isScrollbarVisible: state.isScrollbarVisible,
        selectedCategory: state.selectedCategory,
        title: state.title,
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
    emitState();
  }

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    state.image = image.path;
    emitState();
  }

  void changeWritingMode(String text) {
    state.writingMode = text.isNotEmpty;
    emitState();
  }

  void addNewEvent(TextEditingController controller, String category) {
    if (controller.text.replaceAll('\n', '').isEmpty) {
      return;
    }
    if (state.editMode) {
      var event = state.events[state.selectedIndex];
      state.editMode = false;
      state.events.where((element) => element.isSelected == true).forEach(
        (element) {
          element = element.copyWith(
            isSelected: false,
          );
        },
      );
      state.events[state.selectedIndex] = event.copyWith(
        description: controller.text,
      );
    } else {
      var event = Event();
      state.image == null
          ? event = Event(
              description: controller.text,
              image: null,
              category: state.selectedCategory,
            )
          : Event(
              description: controller.text,
              image: state.image,
              category: state.selectedCategory,
            );
      events.add(event);
      state.image = null;
    }
    controller.text = '';
    state.writingMode = false;

    emitState();
  }

  void changeFavoriteMode() {
    state.favoriteMode = !state.favoriteMode;

    emitState();
  }

  void copyEventText(TextEditingController controller) {
    controller.text = (state.events[state.selectedIndex].description);
    state.editMode = true;
    for (var element in state.events) {
      element = element.copyWith(
        isSelected: false,
      );
    }
    emitState();
  }

  void setSelectedIndex(int index, TextEditingController controller) {
    tapOnEvent(index, controller);
    state.selectedIndex = index;

    emitState();
  }

  void selectEvent(int index) {
    state.editMode = true;
    events[events.indexOf(state.events[index])] = state.events[index].copyWith(
      isSelected: true,
    );
    state.selectedIndex = index;
    emitState();
  }

  void removeEvents(BuildContext context) {
    state.events.removeWhere((element) => element.isSelected == true);
    Navigator.pop(context);

    emitState();
  }

  void changeSearchMode() {
    state.searchMode = !state.searchMode;

    emitState();
  }

  void changeEditMode() {
    state.editMode = !state.editMode;

    emitState();
  }

  void setSearchMode(bool isSearched) {
    state.searchMode = isSearched;

    emitState();
  }

  void search(String text) {
    state.searchedEvents = state.events
        .where((element) => element.description.contains(text))
        .toList();

    emitState();
  }

  void setMigrateCategory(Object? index) {
    state.migrateCategory = index as String;

    emitState();
  }

  void migrate() {
    for (var element in state.events) {
      if (element.isSelected) {
        events[events.indexOf(element)] = element.copyWith(
          isSelected: false,
          category: state.migrateCategory,
        );
      }
    }

    emitState();
  }

  void selectCategory(int index) {
    state.selectedCategory = state.chats.keys.elementAt(index);

    emitState();
  }

  void changeVisibility() {
    state.isScrollbarVisible = !state.isScrollbarVisible;

    emitState();
  }

  void canselSelection() {
    for (var element in state.events) {
      if (element.isSelected) {
        events[events.indexOf(element)] = element.copyWith(isSelected: false);
      }
    }

    emitState();
  }

  void removeEvent(int index) {
    events.remove(state.events[index]);

    emitState();
  }
}
