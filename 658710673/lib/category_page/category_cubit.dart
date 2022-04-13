import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../data/db_provider.dart';
import '../home_page/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryState(events: [], searchedEvents: []));

  final defaultSection = Section(title: '', iconData: Icons.bubble_chart);

  void init(Category category) async {
    emit(state.copyWith(category: category, selectedSection: defaultSection));
    final events = await DBProvider.db.getAllCategoryEvents(category);
    emit(state.copyWith(events: events));
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
    final event = Event('', category.id, attachment: image.path);
    final newEvent = await DBProvider.db.addEvent(event);
    state.events.add(newEvent);
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
      await DBProvider.db.updateEvent(state.events[selectedEventIndex]);
      cancelSelectedEvents();
    } else {
      final event = Event(
        text,
        category.id,
        sectionTitle: defaultSection.title,
        sectionIcon: defaultSection.iconData.codePoint,
      );
      final newEvent = await DBProvider.db.addEvent(event);
      state.events.add(newEvent);
    }
    changeWritingMode(text);

    emit(state.copyWith(category: state.category, isMessageEdit: state.isMessageEdit));
  }

  void deleteEvent() async {
    for (var i = 0; i < state.events.length; i++) {
      if (state.events[i].isSelected) {
        await DBProvider.db.deleteEvent(state.events[i]);
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

  void changeEventBookmark() async {
    for (var event in state.events) {
      if (event.isSelected) {
        event.isSelected = false;
        event.isBookmarked = !event.isBookmarked;
        await DBProvider.db.updateEvent(event);
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
    await DBProvider.db.updateEvent(events[index]);
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
        event.categoryId = category!.id;
        await DBProvider.db.updateEvent(event);
      }
    }
    deleteEvent();
  }
}