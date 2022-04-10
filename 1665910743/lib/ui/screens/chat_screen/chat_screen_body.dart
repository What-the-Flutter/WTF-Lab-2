import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../constants.dart';
import '../../../models/event.dart';
import '../../../models/icons_pack.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/event_tile_actions.dart';
import '../chat_screen/bookmarks.dart';
import '../chat_screen/cubit/event_cubit.dart';
import '../settings/cubit/settings_cubit.dart';

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
  void didChangeDependencies() {
    context.read<EventCubit>().getEvents();
    super.didChangeDependencies();
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
    final _backgroundImage =
        context.read<SettingsCubit>().state.backgroundImagePath;
    return Container(
      decoration: (_backgroundImage.length > 2)
          ? BoxDecoration(
              image: DecorationImage(
                  image: Image.file(File(_backgroundImage)).image,
                  fit: BoxFit.cover),
            )
          : null,
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
    var _eventCubit = context.read<EventCubit>();
    return Expanded(
      child: BlocBuilder<EventCubit, EventState>(
        bloc: _eventCubit,
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.eventList.length,
            itemBuilder: ((context, index) {
              if (widget.categoryTitle ==
                  state.eventList[index].categoryTitle) {
                if (state.eventList[index].image.length > 2) {
                  context
                      .read<EventCubit>()
                      .getImage(state.eventList[index].title);
                }

                return Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      EditAction(
                        event: state.eventList[index],
                        eventKey: state.eventList[index].id!,
                      ),
                      RemoveAction(eventKey: state.eventList[index].id!),
                      MoveAction(eventKey: state.eventList[index].id!),
                    ],
                  ),
                  child: Align(
                    alignment: BlocProvider.of<SettingsCubit>(context)
                        .state
                        .chatTileAlignment,
                    child: GestureDetector(
                      onDoubleTap: () =>
                          _copyToClipboard(state.eventList[index].title),
                      onLongPress: () {
                        setState(
                          () {
                            if (state.eventList[index].isSelected == false) {
                              hasSelected.add(state.eventList[index].id);
                              _eventCubit
                                  .eventSelect(state.eventList[index].id!);
                            } else {
                              hasSelected.remove(state.eventList[index].id);
                              _eventCubit
                                  .eventNotSelect(state.eventList[index].id!);
                            }
                            HapticFeedback.heavyImpact();
                          },
                        );
                      },
                      child: EventTile(
                          iconCode: state.eventList[index].iconCode,
                          isSelected: state.eventList[index].isSelected,
                          title: state.eventList[index].title,
                          date: state.eventList[index].date,
                          favorite: state.eventList[index].favorite,
                          image: (state.eventList[index].imageUrl != null)
                              ? Image.network(
                                  state.eventList[index].imageUrl!,
                                  width: 70,
                                  height: 70,
                                )
                              : null),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
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
                      onTap: (() => setState(
                            () {
                              _selectedIcon = index;
                              _iconAdd = !_iconAdd;
                            },
                          )),
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
                  context.read<EventCubit>().removeEventInCategory(key: el);
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
              style: TextStyle(color: Theme.of(context).primaryColor),
              decoration: InputDecoration(
                hintText: ' Enter event',
                hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                border: InputBorder.none,
              ),
              controller: _controller,
            ),
          ),
          IconButton(
              onPressed: () async {
                if (_controller.value.text.isNotEmpty) {
                  if (_selectedIcon == -1) {
                    context.read<EventCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                            image: '',
                            iconCode: 0,
                            title: _controller.text,
                            date: DateTime.now(),
                            favorite: false,
                            categoryTitle: widget.categoryTitle,
                          ),
                        );
                  } else {
                    context.read<EventCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                              image: '',
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
                    final basename =
                        path.basenameWithoutExtension(_image!.path);

                    context.read<EventCubit>().addEvent(
                          categoryTitle: widget.categoryTitle,
                          event: Event(
                              iconCode: 0,
                              title: basename,
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
