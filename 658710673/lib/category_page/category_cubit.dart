import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/firebase_provider.dart';
import '../home_page/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/filter_parameters.dart';
import '../models/section.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required User? user})
      : _user = user,
        super(CategoryState(events: [], searchedEvents: [], filteredEvents: []));

  final User? _user;
  late final FirebaseProvider _db = FirebaseProvider(user: _user);

  final defaultSection = Section(title: '', iconData: Icons.bubble_chart);

  void init(Category category) async {
    emit(state.copyWith(category: category, selectedSection: defaultSection));
    final events = await _db.getAllCategoryEvents(category);
    emit(state.copyWith(events: events));
  }

  void initTimeline() async {
    emit(state.copyWith(selectedSection: defaultSection));
    final events = await _db.getAllEvents();
    emit(state.copyWith(events: events, filteredEvents: events));
  }

  void changeFavoriteMode() {
    emit(state.copyWith(isFavoriteMode: !state.isFavoriteMode));
  }

  void changeMessageEditMode() {
    emit(state.copyWith(isMessageEdit: !state.isMessageEdit));
  }

  void changeWritingMode(String text) {
    emit(state.copyWith(isWritingMode: text.isNotEmpty));
  }

  void changeEditingMode() {
    emit(state.copyWith(isEditingMode: !state.isEditingMode));
  }

  void changeSearchMode() {
    state.searchedEvents.clear();
    emit(state.copyWith(isSearchMode: !state.isSearchMode, category: state.category));
  }

  void setSection(Section section) {
    emit(state.copyWith(selectedSection: section));
  }

  Future attachImage(Category category) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    emit(state.copyWith(isAttachment: true));
    final event = Event(description: '', category: category.id, attachment: image.path);
    await _db.addEvent(event);
    state.events.add(event);
    emit(state.copyWith(events: state.events));
  }

  void addNewEvent(String text, Category category) async {
    if (text.replaceAll('\n', '').isEmpty) {
      return;
    }
    if (state.isEditingMode) {
      changeEditingMode();
      changeMessageEditMode();
      final selectedEventIndex = state.events.indexWhere((element) => element.isSelected == true);
      state.events[selectedEventIndex].description = text;
      await _db.updateEvent(state.events[selectedEventIndex]);
      cancelSelectedEvents();
    } else {
      final event = Event(
        description: text,
        category: category.id,
        sectionTitle: defaultSection.title,
        sectionIcon: defaultSection.iconData.codePoint,
      );
      await _db.addEvent(event);
      state.events.add(event);
    }
    changeWritingMode(text);

    emit(state.copyWith(category: state.category, isMessageEdit: state.isMessageEdit));
  }

  void deleteEvent() async {
    for (var i = 0; i < state.events.length; i++) {
      if (state.events[i].isSelected) {
        await _db.deleteEvent(state.events[i]);
        state.events.removeAt(i);
        i--;
      }
    }
    emit(state.copyWith(category: state.category));
  }

  void cancelSelectedEvents() {
    for (var event in state.events) {
      if (event.isSelected) {
        event.isSelected = false;
      }
    }
    emit(state.copyWith(events: state.events));
  }

  void selectEvent(int index) {
    state.events[index].isSelected = true;
    emit(state.copyWith(events: state.events));
  }

  String editEvent() {
    final selectedEventIndex = state.events.indexWhere((element) => element.isSelected == true);
    changeMessageEditMode();
    changeEditingMode();
    emit(state.copyWith(isMessageEdit: state.isMessageEdit, isEditingMode: state.isEditingMode));
    return state.events[selectedEventIndex].description;
  }

  void copyToClipboard() {
    var selectedText = '';
    final selectedEventIndex = state.events.indexWhere((element) => element.isSelected == true);
    if (state.events[selectedEventIndex].attachment != null) {
      selectedText = state.events[selectedEventIndex].attachment!;
    } else {
      for (var event in state.events) {
        if (event.isSelected) {
          selectedText += '${event.description}\n';
        }
      }
    }
    Clipboard.setData(ClipboardData(text: selectedText));
    cancelSelectedEvents();
  }

  void changeEventBookmark() {
    for (var event in state.events) {
      if (event.isSelected) {
        event.isSelected = false;
        event.isBookmarked = !event.isBookmarked;
        _db.updateEvent(event);
      }
    }
    emit(state.copyWith(events: state.events));
  }

  void tapOnEvent(int index, TextEditingController controller) async {
    var events = state.events;

    if (events.where((element) => element.isSelected == true).isNotEmpty) {
      if (events[index].isSelected) {
        events[index].isSelected = false;
      } else {
        events[index].isSelected = true;
      }
    } else {
      if (events[index].isBookmarked) {
        events[index].isBookmarked = false;
      } else {
        events[index].isBookmarked = true;
      }
    }
    emit(state.copyWith(events: events));
    _db.updateEvent(events[index]);
  }

  void search(String query) {
    state.searchedEvents.clear();
    emit(state.copyWith(category: state.category));
    for (var i = 0; i < state.events.length; i++) {
      if (state.events.elementAt(i).description.toLowerCase().contains(query.toLowerCase())) {
        state.searchedEvents.add(state.events.elementAt(i));
      }
    }
    emit(state.copyWith(searchedEvents: state.searchedEvents));
  }

  void applyFilters(FilterParameters parameters) {
    var filteredEvents = <Event>[];
    var tempList = <Event>[];
    for (var categoryId in parameters.selectedPagesId) {
      for (var i = 0; i < state.events.length; i++) {
        if (state.events.elementAt(i).category == categoryId) {
          tempList.add(state.events.elementAt(i));
        }
      }
    }
    if (parameters.searchText != '') {
      for (var i = 0; i < tempList.length; i++) {
        if (state.events
            .elementAt(i)
            .description
            .toLowerCase()
            .contains(parameters.searchText.toLowerCase())) {
          filteredEvents.add(state.events.elementAt(i));
        }
      }
    } else {
      filteredEvents.addAll(tempList);
    }
    emit(state.copyWith(filteredEvents: filteredEvents));
  }

  void setReplyCategory(BuildContext context, int index) {
    final category = context.read<HomeCubit>().state.categories[index];
    emit(state.copyWith(
      replyCategory: category,
      replyCategoryIndex: index,
    ));
  }

  void replyEvents(BuildContext context) async {
    final category = state.replyCategory;
    var eventsToReply = <Event>[];
    for (var event in state.events) {
      if (event.isSelected) {
        eventsToReply.add(event);
        event.category = category!.id;
        await _db.updateEvent(event);
      }
    }
    deleteEvent();
  }
}
