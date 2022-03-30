import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../cubit/category_list_cubit.dart';
import '../../cubit/category_list_state.dart';
import '../../data/database_provider.dart';
import '../../models/event.dart';
import '../../models/icons_pack.dart';
import '../screens/bookmarks.dart';
import 'edit_chat_item_dialog.dart';
import 'event_tile.dart';
import 'move_event_tile.dart';

class ChatScreenBody extends StatefulWidget {
  final int eventId;

  const ChatScreenBody({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final _controller = TextEditingController();
  final _renameController = TextEditingController();
  final picker = ImagePicker();
  final List hasSelected = [];
  bool _iconAdd = false;
  File? _image;
  int _selectedIcon = -1;

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.length <= 1) {
        setState(() {});
      }
    });
    final _cubit = BlocProvider.of<CategoryListCubit>(context);
    _cubit.fetchEventsInCategory(widget.eventId);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _renameController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
        ),
      );
    });
  }

  Future getImage() async {
    final _pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final File? _newImage = await File(_pickedFile!.path);

    setState(() {
      if (_newImage != null) {
        print(_newImage.path);
        _image = _newImage;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      bloc: context.read<CategoryListCubit>(),
      builder: (context, state) {
        final eventList = state.categoryList[widget.eventId].list;

        return Container(
          padding: kListViewPadding,
          child: Column(
            children: [
              _listBody(eventList),
              _iconAdd ? _iconsGrid() : const SizedBox(),
              _chatScreenNavBar(widget.eventId),
            ],
          ),
        );
      },
    );
  }

  Widget _listBody(List<Event> eventList) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => chatTileEditDialog(
                      title: eventList[index].title,
                      context: context,
                      catIndex: widget.eventId,
                      index: index),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) =>
                      context.read<CategoryListCubit>().removeEventInCategory(
                            title: eventList[index].title,
                            categoryIndex: widget.eventId,
                            eventIndex: index,
                          ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  autoClose: true,
                  onPressed: (context) {
                    moveTile(
                        categoryIndex: widget.eventId,
                        context: context,
                        eventIndex: index);
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  icon: Icons.move_down,
                ),
              ],
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onDoubleTap: () => _copyToClipboard(eventList[index].title),
                  onLongPress: () {
                    setState(() {
                      if (eventList[index].isSelected == false) {
                        hasSelected.add(eventList[index].title);
                      } else {
                        hasSelected.remove(eventList[index].title);
                      }

                      eventList[index].isSelected =
                          !eventList[index].isSelected;
                      HapticFeedback.heavyImpact();
                    });
                  },
                  child: EventTile(
                    iconCode: eventList[index].iconCode,
                    isSelected: eventList[index].isSelected,
                    title: eventList[index].title,
                    date: eventList[index].date,
                    favorite: eventList[index].favorite,
                    image: eventList[index].image,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconsGrid() => Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: kMyIcons.length,
                itemBuilder: ((context, index) => GestureDetector(
                      onTap: (() => setState(() {
                            _selectedIcon = index;
                            _iconAdd = !_iconAdd;
                          })),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 20,
                          child: kMyIcons[index],
                        ),
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = -1;
                  _iconAdd = !_iconAdd;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 20,
                  child: const Icon(Icons.cancel_outlined),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _chatScreenNavBar(int eventid) {
    final state = context.read<CategoryListCubit>();

    return SafeArea(
      child: BlocBuilder<CategoryListCubit, CategoryListState>(
        bloc: state,
        builder: (context, state) => Row(
          children: [
            IconButton(
              onPressed: () {
                if (hasSelected.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookmarkEvents(
                        id: eventid,
                      ),
                    ),
                  );
                } else {
                  for (final element in hasSelected) {
                    setState(() {
                      state.categoryList[eventid].list
                          .removeWhere((e) => e.title == element);
                      DataBase.db.removeEvent(element);
                    });
                  }
                  hasSelected.clear();
                }
              },
              icon: Icon(
                hasSelected.isNotEmpty ? Icons.delete : Icons.bookmark,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _iconAdd = !_iconAdd;
                });
              },
              icon: Icon(
                (_selectedIcon == -1)
                    ? Icons.bubble_chart
                    : kMyIcons[_selectedIcon].icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: ' Enter event',
                  border: InputBorder.none,
                ),
                controller: _controller,
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (_controller.value.text.isNotEmpty) {
                    if (_selectedIcon == -1) {
                      DataBase.db.addEvent(
                        Event(
                          iconCode: 0,
                          title: _controller.text,
                          date: DateTime.now(),
                          favorite: false,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                      state.categoryList[eventid].list.add(
                        Event(
                          iconCode: 0,
                          title: _controller.text,
                          date: DateTime.now(),
                          favorite: false,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                    } else {
                      DataBase.db.addEvent(
                        Event(
                          iconCode: kMyIcons[_selectedIcon].icon!.codePoint,
                          title: _controller.text,
                          date: DateTime.now(),
                          favorite: false,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                      state.categoryList[eventid].list.add(
                        Event(
                          title: _controller.text,
                          date: DateTime.now(),
                          favorite: false,
                          iconCode: kMyIcons[_selectedIcon].icon!.codePoint,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                    }
                    _selectedIcon = -1;

                    _controller.clear();
                  } else if (_controller.value.text.isEmpty) {
                    await getImage();
                    if (_image != null) {
                      DataBase.db.addEvent(
                        Event(
                          iconCode: 0,
                          title: 'Image from gallery',
                          date: DateTime.now(),
                          favorite: false,
                          image: _image,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                      state.categoryList[eventid].list.add(
                        Event(
                          iconCode: 0,
                          title: 'Image from gallery',
                          date: DateTime.now(),
                          favorite: false,
                          image: _image,
                          categoryIndex: eventid,
                          categoryTitle: state.categoryList[eventid].title,
                        ),
                      );
                    }
                  }
                },
                icon: Icon(
                  _controller.value.text.isEmpty
                      ? Icons.photo_camera
                      : Icons.send,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
