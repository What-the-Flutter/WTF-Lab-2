import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/models/event.dart';
import '../../../domain/models/message.dart';
import '../../constants/constants.dart';
import 'chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController searchBarController = TextEditingController();
  final int eventIndex;

  ChatScreen({
    super.key,
    required this.eventIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(const ChatState(
          event: Event(
              id: '', title: 'Loading...', iconData: Icons.local_dining))),
      child: Builder(
        builder: (context) {
          context.read<ChatCubit>().init();

          return Scaffold(
            appBar: _AppBar(
              searchBarController: searchBarController,
            ),
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchBarController;

  const _AppBar({super.key, required this.searchBarController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.isSearchBarOpen) {
          return AppBar(
            leading: IconButton(
              onPressed: () {
                context.read<ChatCubit>().editAppState();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.kDefaultPadding),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: TextField(
                    onSubmitted: (value) {
                      searchBarController.clear();
                      context.read<ChatCubit>().closeSearchBar();
                    },
                    onChanged: (value) {
                      context.read<ChatCubit>().searchMessages(value);
                    },
                    controller: searchBarController,
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
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ChatCubit>().closeSearchBar();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          );
        } else {
          return AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(context.read<ChatCubit>().state.event.title),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<ChatCubit>().likeEvent();
                },
                icon: Icon(
                  state.event.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ChatCubit>().openSearchBar();
                  searchBarController.clear();
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _Body extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: ((previous, current) {
        if (previous.isEventBarOpen != current.isEventBarOpen ||
            previous.selectedItemInEventBar != current.selectedItemInEventBar ||
            previous.isForward != current.isForward) {
          return true;
        } else {
          return false;
        }
      }),
      builder: (context, state) {
        if (state.isEventBarOpen || state.isForward) {
          return Column(
            children: [
              _MessageList(controller: controller),
              Padding(
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
                            context
                                .read<ChatCubit>()
                                .selectItemInEventBar(index);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: state.selectedItemInEventBar == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Icon(
                                    state.events[index].iconData,
                                    color: state.selectedItemInEventBar == index
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppPadding.kSmallPadding),
                              Text(
                                state.events[index].title,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
              ),
              _BottomBar(controller: controller),
            ],
          );
        } else {
          return Column(
            children: [
              _MessageList(controller: controller),
              _BottomBar(controller: controller),
            ],
          );
        }
      },
    );
  }
}

class _MessageList extends StatelessWidget {
  final TextEditingController controller;

  const _MessageList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return ListView.builder(
            reverse: true,
            itemCount: state.isSearchBarOpen
                ? state.searchingMessages.length
                : state.messages.length,
            itemBuilder: (context, index) {
              if (state.isSearchBarOpen) {
                return _buildMessage(
                    state, index, context, state.searchingMessages);
              }
              return _buildMessage(state, index, context, state.messages);
            },
          );
        },
      ),
    );
  }

  Padding _buildMessage(ChatState state, int index, BuildContext context,
      List<Message> messages) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPadding.kMediumPadding,
      ),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                controller.text = messages[index].text;
                context.read<ChatCubit>().setEditingState(index);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) {
                context.read<ChatCubit>().addToForward(index);
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Icons.subdirectory_arrow_left,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.17,
          motion: const DrawerMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              if (state.isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Complete editing message',
                    ),
                  ),
                );
              } else {
                context
                    .read<ChatCubit>()
                    .deleteMessage(index, state.messages[index].id!);
              }
            },
          ),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (state.isEditing) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Complete editing message',
                      ),
                    ),
                  );
                } else {
                  context
                      .read<ChatCubit>()
                      .deleteMessage(index, state.messages[index].id!);
                }
              },
              spacing: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (state.isForward) {
              context.read<ChatCubit>().addToForward(index);
            }
          },
          onLongPress: () {
            context.read<ChatCubit>().addToForward(index);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Builder(builder: (context) {
                if (state.forwardMessagesIndex.contains(index)) {
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.done,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 16,
                      ),
                    ),
                  );
                } else {
                  return Text(
                    '${messages[index].date.hour}:${messages[index].date.minute}',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  );
                }
              }),
              const SizedBox(width: 10),
              Container(
                margin:
                    const EdgeInsets.only(right: AppPadding.kDefaultPadding),
                constraints: const BoxConstraints(maxWidth: 300),
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.kSmallPadding,
                  horizontal: AppPadding.kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: state.forwardMessagesIndex.contains(index)
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SelectableText(
                  messages[index].text,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: state.forwardMessagesIndex.contains(index)
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final TextEditingController controller;

  const _BottomBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.kSmallPadding,
        vertical: AppPadding.kSmallPadding,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _attachImage,
              icon: Icon(
                Icons.attachment,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    _sendMessage(context);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Type message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (context.read<ChatCubit>().state.isForward) {
                  if (context.read<ChatCubit>().state.selectedItemInEventBar ==
                      -1) {
                    _showSnackBar(context, 'Choose the event');
                  } else {
                    context.read<ChatCubit>().forwardMessage();
                    _showSnackBar(context, 'Message forwarded');
                  }
                } else {
                  _sendMessage(context);
                }
              },
              onLongPress: () {
                context.read<ChatCubit>().openEventBar();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<ChatCubit, ChatState>(
                  buildWhen: ((previous, current) {
                    if (previous.isEventBarOpen != current.isEventBarOpen ||
                        previous.selectedItemInEventBar !=
                            current.selectedItemInEventBar ||
                        previous.isForward != current.isForward) {
                      return true;
                    } else {
                      return false;
                    }
                  }),
                  builder: (context, state) {
                    if (state.isForward) {
                      return Icon(
                        Icons.subdirectory_arrow_left,
                        color: Theme.of(context).colorScheme.onBackground,
                      );
                    } else if (state.isEventBarOpen) {
                      if (state.selectedItemInEventBar == -1) {
                        return Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onBackground,
                        );
                      } else {
                        return Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.onBackground,
                        );
                      }
                    } else {
                      return Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onBackground,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    if (context.read<ChatCubit>().state.isEventBarOpen) {
      if (context.read<ChatCubit>().state.selectedItemInEventBar == -1) {
        context.read<ChatCubit>().closeEventBar();
      } else {
        var message = Message(
          eventId: 'id',
          text: controller.text,
          date: DateTime.now(),
        );
        context.read<ChatCubit>().sendMessageToEvent(message);
        context.read<ChatCubit>().closeEventBar();
        _showSnackBar(context,
            'Message sended to ${context.read<ChatCubit>().state.events[context.read<ChatCubit>().state.selectedItemInEventBar].title}');
        context.read<ChatCubit>().selectItemInEventBar(-1);
        controller.clear();
      }
    } else {
      if (context.read<ChatCubit>().state.isEditing) {
        if (controller.text.isNotEmpty) {
          var index = context.read<ChatCubit>().state.editingMessageIndex;
          var message = context.read<ChatCubit>().state.messages[index];
          context.read<ChatCubit>().editMessage(
                message,
                controller.text,
              );
        }
      } else {
        if (controller.text.isNotEmpty) {
          var message = Message(
            eventId: context.read<ChatCubit>().state.event.id,
            text: controller.text,
            date: DateTime.now(),
          );
          context.read<ChatCubit>().addMessage(message);
        }
      }
      controller.clear();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        content: Container(
          height: 35,
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontFamily: 'QuickSnad',
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _attachImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 50,
    );
    if (pickedFile == null) return;
  }
}
