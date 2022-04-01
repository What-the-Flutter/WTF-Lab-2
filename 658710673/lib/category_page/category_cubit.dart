import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../home_page/home_cubit.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/section.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryState());

  final defaultSection = Section(title: '', iconData: Icons.bubble_chart);

  void init(Category category) {
    emit(state.copyWith(category: category, selectedSection: defaultSection));
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
    state.category!.searchedEvents.clear();
    emit(state.copyWith(isSearchMode: !state.isSearchMode, category: state.category));
  }

  void setSection(Section section) {
    emit(state.copyWith(selectedSection: section));
  }

  Future attachImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    emit(state.copyWith(isAttachment: true));
    state.category!.events.add(Event('', attachment: File(image.path)));
    emit(state.copyWith(category: state.category));
  }

  void addNewEvent(TextEditingController controller, String category) {
    if (controller.text.replaceAll('\n', '').isEmpty) {
      return;
    }
    if (state.isEditingMode) {
      state.isEditingMode = false;
      state.isMessageEdit = false;
      var selectedEventIndex =
          state.category!.events.indexWhere((element) => element.isSelected == true);
      state.category!.events[selectedEventIndex].description = controller.text;
      cancelSelectedEvents();
    } else {
      state.category!.events.add(Event(
        controller.text,
        section: state.selectedSection,
      ));
    }
    controller.text = '';
    state.isWritingMode = false;

    emit(state.copyWith(category: state.category, isMessageEdit: state.isMessageEdit));
  }

  void deleteEvent() {
    for (var i = 0; i < state.category!.events.length; i++) {
      if (state.category!.events[i].isSelected) {
        state.category!.events.removeAt(i);
        i--;
      }
    }
    emit(state.copyWith(category: state.category));
  }

  void cancelSelectedEvents() {
    for (var event in state.category!.events) {
      if (event.isSelected) {
        event.isSelected = false;
      }
    }
    emit(state.copyWith(category: state.category));
  }

  void selectEvent(int index) {
    state.category!.events[index].isSelected = true;
    emit(state.copyWith(category: state.category));
  }

  void editEvent(TextEditingController controller) {
    var selectedEventIndex =
        state.category!.events.indexWhere((element) => element.isSelected == true);
    controller.text = (state.category!.events[selectedEventIndex].description);
    state.isMessageEdit = true;
    state.isEditingMode = true;
    emit(state.copyWith(isMessageEdit: state.isMessageEdit, isEditingMode: state.isEditingMode));
  }

  void copyToClipboard() {
    var selectedText = '';
    var selectedEventIndex =
        state.category!.events.indexWhere((element) => element.isSelected == true);
    if (state.category!.events[selectedEventIndex].attachment != null) {
      selectedText = state.category!.events[selectedEventIndex].attachment!.path;
    } else {
      for (var event in state.category!.events) {
        if (event.isSelected) {
          selectedText += '${event.description}\n';
        }
      }
    }
    Clipboard.setData(ClipboardData(text: selectedText));
    cancelSelectedEvents();
  }

  void changeEventBookmark() {
    for (var event in state.category!.events) {
      if (event.isSelected) {
        event.isSelected = false;
        event.isBookmarked = !event.isBookmarked;
      }
    }
    emit(state.copyWith(category: state.category));
  }

  void tapOnEvent(int index, TextEditingController controller) {
    var events = state.category!.events;

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
    emit(state.copyWith(category: state.category));
  }

  void search(String query) {
    state.category!.searchedEvents.clear();
    emit(state.copyWith(category: state.category));
    for (var i = 0; i < state.category!.events.length; i++) {
      if (state.category!.events
          .elementAt(i)
          .description
          .toLowerCase()
          .contains(query.toLowerCase())) {
        state.category!.searchedEvents.add(state.category!.events.elementAt(i));
      }
    }
    emit(state.copyWith(category: state.category));
  }

  void setReplyCategory(BuildContext context, int index) {
    final category = context.read<HomeCubit>().state.categories[index];
    emit(state.copyWith(
      replyCategory: category,
      replyCategoryIndex: index,
    ));
  }

  void replyEvents(BuildContext context) {
    final category = state.replyCategory;
    var eventsToReply = <Event>[];
    for (var event in state.category!.events) {
      if (event.isSelected) {
        eventsToReply.add(event);
      }
    }
    deleteEvent();
    context.read<HomeCubit>().addEvents(eventsToReply, category!);
  }
}
