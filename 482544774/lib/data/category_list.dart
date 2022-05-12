import 'package:flutter/material.dart';

import '../models/category.dart';

List<Category> categoryList = <Category>[
  Category(
    id: 'ct1',
    name: 'Hobby',
    icon: Icons.accessibility_outlined,
    events: ['Read book'],
    pinned: false,
  ),
  Category(
    id: 'ct2',
    name: 'Family',
    icon: Icons.chair,
    events: ['Eat dinner'],
    pinned: false,
  ),
  Category(
    id: 'ct3',
    name: 'Sport',
    icon: Icons.fitness_center, 
    events: ['Play footbal'],
    pinned: false,
  ),
];
