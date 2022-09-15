import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/note.dart';
import '../../constants/constants.dart';
import '../settings/settings_cubit.dart';
import 'chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: Builder(
        builder: (context) {
          context.read<ChatCubit>().init();
          return Scaffold(
            appBar: _buildAppBar(context),
            body: const _Body(),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    var _cubit = context.read<ChatCubit>();
    return AppBar(
      toolbarHeight: 84.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onBackground,
          size: 36,
        ),
      ),
      title: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (p, c) {
          return p.event != c.event || p.status != c.status;
        },
        builder: (context, state) {
          switch (state.status) {
            case ChatStatus.searchingNotes:
              return _SearchBar();
            default:
              return Text(
                state.event?.title ?? 'Loading..',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 30,
                ),
              );
          }
        },
      ),
      actions: [
        BlocBuilder<ChatCubit, ChatState>(
          buildWhen: (p, c) =>
              c.status == ChatStatus.searchingNotes ||
              c.status == ChatStatus.primary,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                if (_cubit.state.status == ChatStatus.searchingNotes) {
                  _cubit.cancelSearching();
                } else {
                  _cubit.setSearchingStatus();
                }
              },
              icon: Icon(
                _cubit.state.status == ChatStatus.searchingNotes
                    ? Icons.close
                    : Icons.search_outlined,
                color: Theme.of(context).colorScheme.onBackground,
                size: 36,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              switch (state.status) {
                case ChatStatus.searchingNotes:
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.searchingNotes.length,
                    itemBuilder: (context, index) {
                      return _MessageHandler(
                        previousNote: index == state.searchingNotes.length - 1
                            ? null
                            : state.searchingNotes[index + 1],
                        currentNote: state.searchingNotes[index],
                        isSelected: false,
                        index: index,
                      );
                    },
                  );
                default:
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      var isSelected =
                          state.forwardNotes.contains(state.notes[index].id)
                              ? true
                              : false;
                      return _MessageHandler(
                        previousNote: index == state.notes.length - 1
                            ? null
                            : state.notes[index + 1],
                        currentNote: state.notes[index],
                        isSelected: isSelected,
                        index: index,
                      );
                    },
                  );
              }
            },
          ),
        ),
        _BottomBarTextField(),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final _searchBarController = TextEditingController();

  _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.1),
            offset: const Offset(3, 3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppPadding.kDefaultPadding),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: TextField(
            onChanged: (value) {
              context.read<ChatCubit>().searchNote(value);
            },
            controller: _searchBarController,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageHandler extends StatelessWidget {
  final Note? previousNote;
  final Note currentNote;
  final int index;
  final bool isSelected;

  const _MessageHandler({
    super.key,
    this.previousNote,
    required this.currentNote,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (previousNote == null) {
      return _MessageWithDivider(
        dividerText:
            '${currentNote.date.day < 10 ? '0${currentNote.date.day}' : currentNote.date.day}.${currentNote.date.month < 10 ? '0${currentNote.date.month}' : currentNote.date.month}',
        isSelected: isSelected,
        note: currentNote,
        index: index,
      );
    } else {
      if (previousNote!.date.day == currentNote.date.day) {
        return _Message(
          note: currentNote,
          isSelected: isSelected,
          index: index,
        );
      } else {
        return _MessageWithDivider(
          dividerText:
              '${currentNote.date.day < 10 ? '0${currentNote.date.day}' : currentNote.date.day}.${currentNote.date.month < 10 ? '0${currentNote.date.month}' : currentNote.date.month}',
          isSelected: isSelected,
          note: currentNote,
          index: index,
        );
      }
    }
  }
}

class _MessageWithDivider extends StatelessWidget {
  final String dividerText;
  final bool isSelected;
  final Note note;
  final int index;

  const _MessageWithDivider({
    super.key,
    required this.dividerText,
    required this.isSelected,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var _cubit = context.read<SettingsCubit>();
    return Column(
      children: [
        _cubit.state.isDateBubbleHiden
            ? const SizedBox()
            : _DividerWithDate(dividerText: dividerText),
        _Message(
          isSelected: isSelected,
          note: note,
          index: index,
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final int index;

  _Message({
    super.key,
    required this.note,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var _cubit = context.read<SettingsCubit>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppPadding.kBigPadding,
        AppPadding.kSmallPadding,
        AppPadding.kBigPadding,
        0,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                context.read<ChatCubit>().deleteNote(note);
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.delete,
            ),
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                context.read<ChatCubit>().selectNote(note.id!);
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.subdirectory_arrow_left,
            ),
            SlidableAction(
              autoClose: true,
              onPressed: (context) {
                context.read<ChatCubit>().setEditingStatus(note);
              },
              backgroundColor: Theme.of(context).colorScheme.background,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.edit,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: _cubit.state.isMessageLeftAlign
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showSelect(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.read<ChatCubit>().state.status ==
                        ChatStatus.forwarding) {
                      context.read<ChatCubit>().selectNote(note.id!);
                    }
                  },
                  onLongPress: () {
                    context.read<ChatCubit>().selectNote(note.id!);
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        AppPadding.kMediumPadding,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        AppPadding.kMediumPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          note.text.isNotEmpty
                              ? HashTagText(
                                  onTap: (text) {
                                    var chatCubit = context.read<ChatCubit>();
                                    chatCubit.setSearchingStatus();
                                    chatCubit.searchNote(text);
                                  },
                                  text: note.text,
                                  basicStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                  ),
                                  decoratedStyle: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                  ),
                                )
                              : const SizedBox(),
                          note.imageName.isNotEmpty
                              ? const SizedBox(
                                  height: AppPadding.kMediumPadding)
                              : const SizedBox(),
                          note.imageName.isNotEmpty
                              ? FutureBuilder(
                                  future: context
                                      .read<ChatCubit>()
                                      .imageURL(note.imageName),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return Image.network(
                                        snapshot.data as String,
                                        fit: BoxFit.contain,
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Container();
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.kSmallPadding / 2),
                Text(
                  _formateTime(note.date),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSelect(BuildContext context) {
    if (isSelected) {
      return Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.done,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 14,
            ),
          ),
          const SizedBox(width: AppPadding.kMediumPadding),
        ],
      );
    } else {
      return Container();
    }
  }

  String _formateTime(DateTime messageDate) {
    return '${messageDate.hour < 10 ? '0${messageDate.hour}' : messageDate.hour}:${messageDate.minute < 10 ? '0${messageDate.minute}' : messageDate.minute}';
  }
}

class _DividerWithDate extends StatelessWidget {
  final String dividerText;
  const _DividerWithDate({
    required this.dividerText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(
            AppPadding.kMediumPadding,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.kSmallPadding,
            vertical: AppPadding.kSmallPadding / 2,
          ),
          child: Text(
            dividerText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  late final ChatCubit _cubit;

  _BottomBarTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<ChatCubit>();
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.editingMessage) {
          _controller.text = state.editingNote!.text;
        }
        return SafeArea(
          child: Column(
            children: [
              state.status == ChatStatus.sendTo ||
                      state.status == ChatStatus.forwarding
                  ? _buildEventBar(state)
                  : const SizedBox(),
              Container(
                color: Theme.of(context).colorScheme.background,
                height: 75,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.kSmallPadding,
                      ),
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: Icon(
                          state.status == ChatStatus.noteWithImage
                              ? Icons.done
                              : Icons.attachment,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.1),
                              offset: const Offset(3, 3),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.kMediumPadding,
                            vertical: AppPadding.kSmallPadding,
                          ),
                          child: HashTagTextField(
                            decoratedStyle: const TextStyle(
                              color: Colors.cyan,
                            ),
                            basicStyle: const TextStyle(
                              color: Color(0xFF374A48),
                            ),
                            controller: _controller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.kDefaultPadding - 2,
                      ),
                      child: GestureDetector(
                        onTap: _sendbuttonHandler,
                        onLongPress: _cubit.setSendToStatus,
                        child: Icon(
                          _handleIcon(state),
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Padding _buildEventBar(ChatState state) {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.kDefaultPadding),
      child: Container(
        height: 96,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                AppPadding.kDefaultPadding,
                AppPadding.kDefaultPadding,
                0,
                0,
              ),
              child: GestureDetector(
                onTap: () {
                  _cubit.selectItemInEventBar(state.events[index]);
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: (state.selectedEvent?.id ?? '') ==
                                state.events[index].id
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Icon(
                          state.events[index].iconData,
                          color: (state.selectedEvent?.id ?? '') ==
                                  state.events[index].id
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppPadding.kSmallPadding),
                    Text(
                      state.events[index].title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _handleIcon(ChatState state) {
    switch (state.status) {
      case ChatStatus.sendTo:
        if (state.selectedEvent == null || _controller.text.isEmpty) {
          return Icons.close;
        } else {
          return Icons.east;
        }
      default:
        return Icons.east;
    }
  }

  Future _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;
    _cubit.setImage(image);
  }

  void _sendMessage() {
    var msg = _validateMessage(_controller.text);
    if (msg == null) return;
    _cubit.addNote(msg);

    _controller.clear();
  }

  void _editMessage() {
    var msg = _validateMessage(_controller.text);
    if (msg == null) return;

    _cubit.editNote(
      msg,
    );

    _controller.clear();
  }

  void _sendToMessage() {
    if (_cubit.state.selectedEvent == null || _controller.text.isEmpty) {
      _cubit.cancelSendTo();
    } else {
      var msg = _validateMessage(_controller.text);
      if (msg == null) return;
      _cubit.addNoteToSelectedEvent(msg);
    }

    _controller.clear();
  }

  void _sendbuttonHandler() {
    var chatStatus = _cubit.state.status;
    switch (chatStatus) {
      case ChatStatus.primary:
        _sendMessage();
        break;
      case ChatStatus.editingMessage:
        _editMessage();
        break;
      case ChatStatus.sendTo:
        _sendToMessage();
        break;
      case ChatStatus.searchingNotes:
        break;
      case ChatStatus.forwarding:
        _forwardNotes();
        break;
      case ChatStatus.noteWithImage:
        _sendMessage();
        break;
    }
  }

  String? _validateMessage(String message) {
    if (message.isEmpty && _cubit.state.status != ChatStatus.noteWithImage) {
      return null;
    }
    return message.trim();
  }

  void _forwardNotes() {
    if (_cubit.state.selectedEvent == null) return;
    _cubit.forwardNotes();
  }
}
