import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/event.dart';
import '../../../models/icons_pack.dart';
import '../chat_screen/bookmarks.dart';
import '../chat_screen/cubit/event_cubit.dart';

class ChatScreenNavBar extends StatefulWidget {
  final TextEditingController controller;
  final String categoryTitle;

  const ChatScreenNavBar({
    Key? key,
    required this.controller,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<ChatScreenNavBar> createState() => _ChatScreenNavBarState();
}

class _ChatScreenNavBarState extends State<ChatScreenNavBar>
    with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  String? image;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -2.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
    ),
  );
  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1,
    end: 3,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
    ),
  );

  Future getImage() async {
    final _pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      final File? _newImage = await File(_pickedFile.path);

      setState(() {
        image = _newImage!.path;
        print(image);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected'),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = context.read<EventCubit>().state.animate;
    if (animate) {
      _controller.forward().then((_) => _controller.reverse());
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _eventCubit = context.watch<EventCubit>();

    return SafeArea(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_eventCubit.state.hasSelected.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarkEvents(),
                  ),
                );
              } else {
                for (final el in _eventCubit.state.hasSelected) {
                  context.read<EventCubit>().removeEventInCategory(key: el);
                  context.read<EventCubit>().clearHasSelected();
                }
              }
            },
            icon: SlideTransition(
              position: _offsetAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  _eventCubit.state.hasSelected.isNotEmpty
                      ? Icons.delete
                      : Icons.bookmark,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _eventCubit.iconAdd(true);
              });
            },
            icon: Icon(
              (_eventCubit.state.selectedIcon == -1)
                  ? Icons.bubble_chart
                  : kMyIcons[_eventCubit.state.selectedIcon].icon,
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
              controller: widget.controller,
            ),
          ),
          IconButton(
              onPressed: () async {
                if (widget.controller.value.text.isNotEmpty) {
                  if (_eventCubit.state.selectedIcon == -1) {
                    context.read<EventCubit>().addEvent(
                          event: Event(
                            image: image != null ? image! : '',
                            iconCode: 0,
                            title: widget.controller.text,
                            date: DateTime.now(),
                            favorite: false,
                            categoryTitle: widget.categoryTitle,
                            tag: _eventCubit.state.selectedTag,
                          ),
                        );
                  } else {
                    context.read<EventCubit>().addEvent(
                          event: Event(
                            image: '',
                            title: widget.controller.text,
                            date: DateTime.now(),
                            favorite: false,
                            iconCode: kMyIcons[_eventCubit.state.selectedIcon]
                                .icon!
                                .codePoint,
                            categoryTitle: widget.categoryTitle,
                            tag: _eventCubit.state.selectedTag,
                          ),
                        );
                  }
                  context.read<EventCubit>().iconSelect(-1);
                  widget.controller.clear();
                } else if (widget.controller.value.text.isEmpty) {
                  await getImage();
                }
              },
              icon: Icon(
                widget.controller.value.text.isEmpty
                    ? Icons.photo_camera
                    : Icons.send,
                color: Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
