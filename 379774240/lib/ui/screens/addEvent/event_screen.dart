import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/event.dart';
import '../../constants/constants.dart';
import 'event_cubit.dart';

class EventScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final int? eventIndex;
  final String eventTitle;
  final String title;

  EventScreen({
    super.key,
    this.eventIndex,
    this.eventTitle = '',
    this.title = 'Create new event',
  }) {
    if (eventIndex != null) {
      _controller.text = eventTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context, title),
            body: _Body(controller: _controller),
            floatingActionButton: _buildFAB(context),
          );
        },
      ),
    );
  }

  FloatingActionButton _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSnackBar(context, 'Add event name'),
          );
        } else if (context.read<EventCubit>().state.selectedIcon == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSnackBar(context, 'Select the icon'),
          );
        } else {
          context.read<EventCubit>().createEvent(Event(
                title: _controller.text,
                iconData: context.read<EventCubit>().state.categoryIocns[
                    context.read<EventCubit>().state.selectedIcon!],
              ));
          Navigator.pop(context);
        }
      },
      child: const Icon(Icons.done),
    );
  }

  SnackBar _buildSnackBar(BuildContext context, String errorMessage) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Container(
        height: 42,
        child: Center(
          child: Column(
            children: [
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(title),
    );
  }
}

class _Body extends StatelessWidget {
  final TextEditingController controller;

  _Body({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.kDefaultPadding,
        horizontal: AppPadding.kDefaultPadding * 2,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.kDefaultPadding,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Event name',
                hintStyle: TextStyle(fontFamily: 'Quicksand'),
                labelStyle: TextStyle(fontFamily: 'Quicksand'),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: AppPadding.kDefaultPadding,
          ),
          Expanded(
            child: BlocBuilder<EventCubit, EventState>(
              builder: (context, state) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: AppPadding.kDefaultPadding,
                    crossAxisSpacing: AppPadding.kDefaultPadding,
                  ),
                  itemCount: state.categoryIocns.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<EventCubit>().selectIcon(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.selectedIcon == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Icon(
                            state.categoryIocns[index],
                            color: state.selectedIcon == index
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
