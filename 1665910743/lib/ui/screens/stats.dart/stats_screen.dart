// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:my_journal/ui/screens/Category_Screen/cubit/category_cubit.dart';

import '../../../constants.dart';
import '../../widgets/pie_widget.dart';
import '../chat_screen/cubit/event_cubit.dart';

class StatsScreen extends StatefulWidget {
  final EventCubit eventCubit;
  final CategoryCubit categoryCubit;

  StatsScreen({
    Key? key,
    required this.eventCubit,
    required this.categoryCubit,
  }) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late final Map<String, double> categoryMap;
  late final Map<String, double> bookmarkedMap;
  late final Map<String, double> tagsMap;

  @override
  void initState() {
    super.initState();
    categoryMap = getDataMap(widget.eventCubit, widget.categoryCubit);
    bookmarkedMap = getBookmarkedMap(widget.eventCubit);
    tagsMap = getTagsStat(widget.eventCubit);
  }

  Map<String, double> getDataMap(
      EventCubit eventCubit, CategoryCubit categoryCubit) {
    var map = <String, double>{};
    for (final categorys in categoryCubit.state.categoryList) {
      final eventsFromCat = [];
      eventsFromCat.addAll(eventCubit.state.eventList
          .where((element) => element.categoryTitle == categorys.title));
      map['${categorys.title}'] = eventsFromCat.length.toDouble();
    }
    return map;
  }

  Map<String, double> getBookmarkedMap(EventCubit eventCubit) {
    var map = <String, double>{};
    final eventLength = eventCubit.state.eventList.length.toDouble();
    final bookmarked = eventCubit.state.eventList
        .where((element) => element.favorite == true)
        .length
        .toDouble();
    map['all'] = eventLength;
    map['bookmarked'] = bookmarked;
    return map;
  }

  Map<String, double> getTagsStat(EventCubit eventCubit) {
    var map = <String, double>{};
    for (final tag in tagsList) {
      final eventsFromCat = [];
      eventsFromCat.addAll(eventCubit.state.eventList.where(
          (element) => element.tag != -1 && tagsList[element.tag] == tag));
      map[tag] = eventsFromCat.length.toDouble();
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: (categoryMap.isEmpty)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Stats not avalible yet. Add more events and come back later!',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PieWidget(
                  dataMap: categoryMap,
                  title: 'Popular Categorys :',
                  chatRadius: MediaQuery.of(context).size.width / 3.2,
                ),
                PieWidget(
                    dataMap: bookmarkedMap,
                    title: 'Bookmarked :',
                    chatRadius: MediaQuery.of(context).size.width / 3.2),
                PieWidget(
                  dataMap: tagsMap,
                  title: 'Tags :',
                  chatRadius: MediaQuery.of(context).size.width / 3.2,
                  totalValue:
                      widget.eventCubit.state.eventList.length.toDouble(),
                ),
              ],
            ),
    );
  }
}
