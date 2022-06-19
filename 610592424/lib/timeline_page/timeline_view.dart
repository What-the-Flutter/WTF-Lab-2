import 'package:diploma/home_page/settings_screen/settings_cubit.dart';
import 'package:diploma/timeline_page/timeline_filter_view.dart';
import 'package:diploma/timeline_page/timeline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import 'timeline_cubit.dart';

enum States { normal, multiSelected, searching }

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final TimelineCubit _cubit;
  States _currentState = States.normal;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<TimelineCubit>(context);
    _cubit.loadAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: _eventsList(),
      ),
      floatingActionButtonLocation:
          BlocProvider.of<SettingsCubit>(context).state.bubbleAlignment
              ? FloatingActionButtonLocation.startFloat
              : FloatingActionButtonLocation.endFloat,
      floatingActionButton: _floatingActionButton(),
    );
  }

  void _setNormalState() {
    setState(() {
      _currentState = States.normal;
      _cubit.deselectAllEvents();
    });
    _cubit.applyFilter();
  }

  void _setSearchingState() {
    setState(() {
      _currentState = States.searching;
      _cubit.applySearch('');
    });
  }

  void _copyAllSelected() {
    _cubit.copyAllSelected();
    _setNormalState();
  }

  void _deleteAllSelected() {
    _cubit.deleteAllSelected();
    _setNormalState();
  }

  void _onEventTapOrPress(int eventId) {
    _cubit.changeEventSelection(eventId);

    var itemsSelected = _cubit.eventsSelected;

    setState(() {
      if (itemsSelected == 0) {
        _setNormalState();
      } else {
        setState(() {
          _currentState = States.multiSelected;
        });
      }
    });
  }

  AppBar _appBar(BuildContext context) {
    switch (_currentState) {
      case States.normal:
        return AppBar(
          leading: const IconButton(
            onPressed: null,
            icon: Icon(Icons.menu),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Center(
            child: Text('Timeline'),
          ),
          actions: [
            IconButton(
              onPressed: () => _setSearchingState(),
              icon: const Icon(Icons.search_outlined),
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.bookmark_border_outlined),
            ),
          ],
        );
      case States.multiSelected:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => _copyAllSelected(),
              icon: const Icon(Icons.content_copy_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAllSelected(),
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      case States.searching:
        return AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () => _setNormalState(),
            icon: const Icon(Icons.close),
          ),
          title: TextFormField(
            cursorColor: Colors.red,
            autofocus: false,
            onChanged: (text) => _cubit.applySearch(text),
          ),
          bottom: _getAppbarBottom(),
        );
      default:
        throw Exception("wrong state");
    }
  }

  PreferredSizeWidget? _getAppbarBottom() {
    return _cubit.state.anyHashtags
        ? PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 60.0),
              child: FutureBuilder(
                future: _cubit.getAllHashTags(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () =>
                              _cubit.applySearch(snapshot.data![index]),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blueGrey,
                            ),
                            child: Text(snapshot.data![index]),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          )
        : null;
  }

  BlocBuilder _eventsList() {
    var _eventAlignment =
        BlocProvider.of<SettingsCubit>(context).state.bubbleAlignment
            ? Alignment.bottomRight
            : Alignment.bottomLeft;
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            var _showDate = index != 0 &&
                state.events[index].timeOfCreation!
                        .difference(state.events[index - 1].timeOfCreation!)
                        .inDays >=
                    1;
            if (index == 0 || _showDate) {
              return Column(
                children: [
                  Align(
                    alignment:
                        BlocProvider.of<SettingsCubit>(context).state.centerDate
                            ? Alignment.bottomCenter
                            : _eventAlignment,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                        border: Border.all(width: 2, color: Colors.black45),
                      ),
                      child: Text(
                        DateFormat("MM.dd")
                            .format(state.events[index].timeOfCreation!),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                  _showEvent(state, index, _eventAlignment),
                ],
              );
            }
            return _showEvent(state, index, _eventAlignment);
          },
        );
      },
    );
  }

  Align _showEvent(TimelineState state, int index, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _onEventTapOrPress(state.events[index].eventId),
        onLongPress: () => _onEventTapOrPress(state.events[index].eventId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: state.events[index].isSelected
                ? Colors.amber.shade700
                : Colors.amber,
          ),
          child: state.events[index].imagePath == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _cubit.getEventHolderName(
                          state.events[index].eventholderId),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: Text(
                              snapshot.data!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    (state.events[index].icon != null)
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: state.events[index].icon!,
                          )
                        : const SizedBox.shrink(),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 130),
                      child: HashTagText(
                        text: state.events[index].text,
                        basicStyle: Theme.of(context).textTheme.bodyText1!,
                        decoratedStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1!.fontSize,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('Hm')
                          .format(state.events[index].timeOfCreation!),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                )
              : FutureBuilder(
                  future: _cubit.fetchImage(state.events[index].eventId),
                  builder: (context, AsyncSnapshot<Image> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: 5.0,
                              minWidth: 5.0,
                              maxHeight: 300.0,
                              maxWidth: 300.0,
                            ),
                            child: snapshot.data!,
                          ),
                          Text(
                            '${state.events[index].timeOfCreation!.hour}:${state.events[index].timeOfCreation!.minute}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Text('error occurred');
                    } else {
                      return const SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Text('loading...'),
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TimelineFilterView(_cubit);
            },
          ),
        ).then((value) => _cubit.applyFilter());
      },
      child: const Icon(Icons.settings, color: Colors.black),
    );
  }
}
