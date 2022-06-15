import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../cubit/chat/chat_cubit.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../data/categories_repository.dart';
import '../../../data/models/event.dart';
import '../../constants/constants.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final int categoryIndex;
  final List<Event> eventList;

  const ChatScreen({
    super.key,
    required this.title,
    required this.categoryIndex,
    required this.eventList,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSearchBarOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(widget.eventList),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _Body(
          categoryIndex: widget.categoryIndex,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      title: isSearchBarOpen
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.kDefaultPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            )
          : Text(widget.title),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearchBarOpen
                  ? isSearchBarOpen = false
                  : isSearchBarOpen = true;
            });
          },
          icon: Icon(
            isSearchBarOpen ? Icons.close : Icons.search_outlined,
          ),
        ),
        isSearchBarOpen
            ? const SizedBox(width: 1)
            : IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                ),
              ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final _controller = TextEditingController();
  final int categoryIndex;

  _Body({
    Key? key,
    required this.categoryIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListView(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.kSmallPadding,
            vertical: AppPadding.kSmallPadding,
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
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
                      controller: _controller,
                      onSubmitted: (value) {
                        if (_controller.text.isNotEmpty) {
                          var time = DateTime.now();
                          context.read<ChatCubit>().addEvent(Event(
                              message: _controller.text,
                              date: '${time.hour}:${time.minute}'));
                          _controller.clear();
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Type message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      var time = DateTime.now();
                      context.read<ChatCubit>().addEvent(Event(
                          message: _controller.text,
                          date: '${time.hour}:${time.minute}'));
                      _controller.clear();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: BlocBuilder<ChatCubit, List<Event>>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              return Padding(
                key: UniqueKey(),
                padding: const EdgeInsets.fromLTRB(
                    0, AppPadding.kMediumPadding, AppPadding.kMediumPadding, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Slidable(
                          key: UniqueKey(),
                          startActionPane: ActionPane(
                            extentRatio: 0.2,
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {},
                                backgroundColor: Colors.transparent,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                icon: Icons.edit,
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            extentRatio: 0.2,
                            motion: const DrawerMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () {
                                state.removeAt(index);
                              },
                            ),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  state.removeAt(index);
                                },
                                backgroundColor: Colors.transparent,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.kMediumPadding,
                              vertical: AppPadding.kSmallPadding,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SelectableText(
                              state[index].message,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          state[index].date,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
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
              onPressed: () {},
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
                  onSubmitted: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Type message',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
