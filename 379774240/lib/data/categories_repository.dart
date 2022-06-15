import 'dart:math';

import 'package:flutter/material.dart';

import 'models/category.dart';
import 'models/event.dart';

abstract class CategoriesRepository {
  Future<List<Category>> fetchCategories();
  void removeCategory(int index);
  void likeCategory(int index);
  void addCategory(Category category);
  void editCategory(int index, Category category);
}

class EmulatorCategoriesRepository implements CategoriesRepository {
  List<Category> categories = [
    Category(
      title: 'Sport',
      subtitle: 'It gonna be greatfull)))',
      iconData: Icons.sports_football,
      isFavorive: true,
      events: <Event>[
        Event(
          message: 'Hey! I have an event at night...',
          date: '19:43',
        ),
        Event(
          message: 'I have to meet Jenny and go somewhere',
          date: '19:43',
        ),
        Event(
          message: 'I thing she would like to have a dinner with me',
          date: '19:44',
        ),
        Event(
          message: 'So I need to reserve a table in BlueRise',
          date: '19:44',
        ),
        Event(
          message: 'It gonna be greatfull)))',
          date: '19:45',
        ),
      ],
    ),
    Category(title: 'Family', iconData: Icons.chair),
    Category(
      title: 'Travel',
      subtitle: 'I gonna fly to Paris!!!!',
      iconData: Icons.flight_takeoff,
      events: <Event>[
        Event(
          message: 'I gonna fly to Paris!!!!',
          date: '16:43',
        ),
      ],
    ),
    Category(title: 'Pet', iconData: Icons.pets),
  ];

  @override
  Future<List<Category>> fetchCategories() {
    final random = Random();
    return Future.delayed(Duration(milliseconds: random.nextInt(900) + 100),
        () {
      if (random.nextInt(10) <= 1) {
        throw Exception('Network Exception');
      }
      return categories;
    });
  }

  @override
  void removeCategory(int index) {
    categories.removeAt(index);
  }

  @override
  void addCategory(Category category) {
    categories.add(category);
  }

  @override
  void likeCategory(int index) {
    var category = categories[index];
    category.isFavorive
        ? category = category.copyWith(isFavorive: false)
        : category = category.copyWith(isFavorive: true);
    categories[index] = category;
  }

  @override
  void editCategory(int index, Category category) {
    categories[index] = category;
  }
}
