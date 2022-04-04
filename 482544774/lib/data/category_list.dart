import 'package:flutter/material.dart';

import '../models/category.dart';

List<Category> categoryList = <Category>[
  Category(
    id: 'ct1',
    name: 'Hobby',
    status: 'No events.',
    icon: const Icon(
      Icons.accessibility_outlined,
      color: Colors.white,
    ),
  ),
  Category(
    id: 'ct2',
    name: 'Family',
    status: 'No events.',
    icon: const Icon(
      Icons.chair,
      color: Colors.white,
    ),
  ),
  Category(
    id: 'ct3',
    name: 'Sport',
    status: 'No events.',
    icon: const Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
  ),
];
