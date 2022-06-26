import 'package:diploma/settings_page/settings_cubit.dart';
import 'package:diploma/timeline_page/timeline_filter_view.dart';
import 'package:diploma/timeline_page/timeline_state.dart';
import 'package:diploma/widgets/events_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:intl/intl.dart';

import 'timeline_cubit.dart';

class TimelineView extends StatefulWidget {
  const TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final TimelineCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<TimelineCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: EventsAppBar(
            state.appbarState,
            'Timeline',
            applySearch: (text) => _cubit.applySearch(text),
            anyHashtags: state.anyHashtags,
            hashTags: _cubit.fetchAllHashTags(),
            onBackArrowButtonTap: () => Navigator.pop(context),
            onCancelButtonTap: _cubit.setNormalAppbarState,
            onCopyButtonTap: _cubit.copyAllSelected,
            onDeleteButtonTap: _cubit.deleteAllSelected,
            onSearchButtonTap: _cubit.setSearchingAppbarState,
          ),
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
      },
    );
  }

  BlocBuilder _eventsList() {
    final _eventAlignment =
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

  Align _showEvent(TimelineState state, int index, Alignment alignment) {
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

  Widget _textEvent(TimelineState state, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _eventHolderTitle(state, index),
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

  Widget _photoEvent(TimelineState state, int index) {
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: _eventHolderTitle(state, index),
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

  Widget _eventHolderTitle(TimelineState state, int index) {
    return FutureBuilder(
      future: _cubit.fetchEventHolderName(state.events[index].eventholderId),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Text(
              snapshot.data!,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimelineFilterView(_cubit),
          ),
        ).then((value) => _cubit.applyFilter());
      },
      child: const Icon(Icons.settings, color: Colors.black),
    );
  }
}
