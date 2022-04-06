import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../models/event.dart';
import '../../models/icons_pack.dart';
import '../screens/bookmarks.dart';
import 'event_tile.dart';
import 'event_tile_actions.dart';

class ChatScreenBody extends StatefulWidget {
  final String categoryTitle;

  const ChatScreenBody({
    Key? key,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final _user = FirebaseAuth.instance.currentUser;

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
        _image = _newImage;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kListViewPadding,
      child: Column(
        children: [
          _listBody(widget.categoryTitle),
          _iconAdd ? _iconsGrid() : const SizedBox(),
          _chatScreenNavBar(),
        ],
      ),
    );
  }

  Widget _listBody(String categoryTitle) {
    return Expanded(
      child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .ref()
              .child(_user?.uid ?? '')
              .child('events')
              .orderByChild('categoryTitle')
              .startAt(widget.categoryTitle),
          itemBuilder: (context, snapshot, animation, x) {
            final event = Event.fromMap(
              Map.from(snapshot.value as Map),
            );

            if (event.image!.length > 1) {
              context.read<CategoryListCubit>().getImage(event.title);
            }
            final imageUrl = context.read<CategoryListCubit>().state.imageUrl;

            if (event.categoryTitle == widget.categoryTitle) {
              return Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    EditAction(
                      event: event,
                      eventKey: snapshot.key!,
                    ),
                    RemoveAction(eventKey: snapshot.key!),
                    MoveAction(eventKey: snapshot.key!),
                  ],
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onDoubleTap: () => _copyToClipboard(event.title),
                      onLongPress: () {
                        setState(
                          () {
                            if (event.isSelected == 0) {
                              hasSelected.add(snapshot.key);
                              context
                                  .read<CategoryListCubit>()
                                  .eventSelect(snapshot.key!);
                            } else {
                              hasSelected.remove(snapshot.key);
                              context
                                  .read<CategoryListCubit>()
                                  .eventNotSelect(snapshot.key!);
                            }
                            HapticFeedback.heavyImpact();
                          },
                        );
                      },
                      child: EventTile(
                          iconCode: event.iconCode,
                          isSelected: event.isSelected,
                          title: event.title,
                          date: event.date,
                          favorite: event.favorite,
                          image: (imageUrl != null && event.image!.length > 1)
                              ? Image.network(
                                  imageUrl,
                                  width: 70,
                                  height: 70,
                                )
                              : null),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
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

  Widget _chatScreenNavBar() {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (hasSelected.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkEvents(),
                  ),
                );
              } else {
                for (final el in hasSelected) {
                  context
                      .read<CategoryListCubit>()
                      .removeEventInCategory(key: el);
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
                    context.read<CategoryListCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                            iconCode: 0,
                            title: _controller.text,
                            date: DateTime.now(),
                            favorite: false,
                            categoryTitle: widget.categoryTitle,
                          ),
                        );
                  } else {
                    context.read<CategoryListCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                              title: _controller.text,
                              date: DateTime.now(),
                              favorite: false,
                              iconCode: kMyIcons[_selectedIcon].icon!.codePoint,
                              categoryTitle: widget.categoryTitle),
                        );
                  }
                  _selectedIcon = -1;

                  _controller.clear();
                } else if (_controller.value.text.isEmpty) {
                  await getImage();
                  if (_image != null) {
                    context.read<CategoryListCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                              iconCode: 0,
                              title: 'Image',
                              date: DateTime.now(),
                              favorite: false,
                              image: _image!.path,
                              categoryTitle: widget.categoryTitle),
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
    );
  }
}
