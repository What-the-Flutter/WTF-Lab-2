import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import 'package:diploma/event_icons_set.dart';
import 'package:diploma/widgets/events_app_bar.dart';
import '../../settings_page/settings_cubit.dart';
import 'eventlist_cubit.dart';
import 'eventlist_state.dart';

class EventListView extends StatefulWidget {
  final String title;

  const EventListView(this.title, {Key? key}) : super(key: key);

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  late final EventListCubit _cubit;
  var _keyForTextField = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<EventListCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventListCubit, EventListState>(
        builder: (context, state) {
      return Scaffold(
        appBar: EventsAppBar(
          state.appbarState,
          widget.title,
          applySearch: (text) => _cubit.applySearch(text),
          anyHashtags: state.anyHashtags,
          hashTags: _cubit.fetchAllHashTags(),
          onBackArrowButtonTap: () => Navigator.pop(context),
          onCancelButtonTap: _cubit.setNormalAppbarState,
          onCopyButtonTap: _cubit.copyAllSelected,
          onDeleteButtonTap: _cubit.deleteAllSelected,
          onSearchButtonTap: _cubit.setSearchingAppbarState,
          onEditingButtonTap: _cubit.setEditingAppbarState,
          onForwardButtonTap: () => _forwardAllSelected(context),
        ),
        body: Column(
          children: [
            Expanded(child: _eventsList()),
            Align(
              alignment: Alignment.bottomLeft,
              child: _bottomTextField(),
            ),
          ],
        ),
      );
    });
  }

  void _editEvent() async {
    assert(_keyForTextField.currentState!.validate());
    _cubit.editEvent(_keyForTextField.currentState!.value!);
    _keyForTextField = GlobalKey<FormFieldState<String>>();
  }

  void _addEvent() {
    assert(_keyForTextField.currentState!.validate());
    _cubit.addEvent(_keyForTextField.currentState!.value!);
  }

  BlocBuilder _eventsList() {
    final _eventAlignment =
        BlocProvider.of<SettingsCubit>(context).state.bubbleAlignment
            ? Alignment.bottomRight
            : Alignment.bottomLeft;
    return BlocBuilder<EventListCubit, EventListState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            var _showDate = index != 0 &&
                state.events[index].timeOfCreation!
                        .difference(state.events[index - 1].timeOfCreation!)
                        .inDays >= 1;
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
                        DateFormat("dd.MM")
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

  Align _showEvent(EventListState state, int index, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _cubit.onEventTapOrPress(state.events[index].eventId),
        onLongPress: () =>
            _cubit.onEventTapOrPress(state.events[index].eventId),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: state.events[index].isSelected
                  ? Colors.amber.shade700
                  : Colors.amber,
            ),
            child: state.events[index].imagePath == null
                ? _textEvent(state, index)
                : _photoEvent(state, index)),
      ),
    );
  }

  Widget _textEvent(EventListState state, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            ),
          ),
        ),
        Text(
          DateFormat('Hm').format(state.events[index].timeOfCreation!),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget _photoEvent(EventListState state, int index) {
    return FutureBuilder(
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
    );
  }

  Column _bottomTextField() {
    switch (_cubit.state.appbarState) {
      case AppbarStates.normal:
        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _cubit.state.showIconsList
                  ? SizedBox(
                      height: 120,
                      child: _imageList(),
                    )
                  : Container(),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _cubit.changeIconListVisibility(),
                    icon: (_cubit.state.chosenIconIndex == 0)
                        ? const Icon(Icons.grain)
                        : setOfEventIcons[_cubit.state.chosenIconIndex],
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _keyForTextField,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "The value cannot be empty"
                            : null;
                      },
                      onChanged: (text) => _cubit.setAllowImagePick(text),
                    ),
                  ),
                  _cubit.state.allowPhotoPick
                      ? IconButton(
                          onPressed: () async {
                            await _cubit.attachImage();
                            _cubit.loadEvents();
                          },
                          icon: const Icon(Icons.image),
                        )
                      : IconButton(
                          onPressed: () {
                            _addEvent();
                            _keyForTextField.currentState!.reset();
                          },
                          icon: const Icon(Icons.send),
                        ),
                ],
              ),
            ),
          ],
        );
      case AppbarStates.editing:
        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _cubit.state.showIconsList
                  ? SizedBox(
                      height: 120,
                      child: _imageList(),
                    )
                  : Container(),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _cubit.changeIconListVisibility(),
                    icon: (_cubit.state.chosenIconIndex == 0)
                        ? const Icon(Icons.grain)
                        : setOfEventIcons[_cubit.state.chosenIconIndex],
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _keyForTextField,
                      initialValue:
                          _cubit.fetchEvent(_cubit.state.tempEventId!).text,
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "The value cannot be empty"
                            : null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      _editEvent();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        );
      case AppbarStates.searching:
        return Column();
      default:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "Choose events",
                    ),
                  ),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  ListView _imageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: setOfEventIcons.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (index == 0) ? Colors.white : Colors.black54,
              ),
              child: IconButton(
                icon: setOfEventIcons[index],
                color: Colors.white,
                iconSize: 40,
                onPressed: () => _cubit.setChosenIcon(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _forwardAllSelected(BuildContext myContext) async {
    final eventholders = await _cubit.getEventForwardingHoldersList;
    return await showDialog(
      context: myContext,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose page'),
          children: [
            for (var eventHolder in eventholders)
              SimpleDialogOption(
                onPressed: () {
                  _cubit.forwardAllSelected(eventHolder.eventholderId);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(eventHolder.picture.icon),
                    Text(eventHolder.title),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
