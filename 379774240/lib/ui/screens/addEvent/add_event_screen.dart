import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import 'add_event_cubit.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEventCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppBar(
            context,
            title: 'Title',
          ),
          body: const _Body(),
          floatingActionButton: _buildFAB(context),
        );
      }),
    );
  }

  FloatingActionButton _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<AddEventCubit>().addEvent();
        Navigator.pop(context);
      },
      child: Icon(
        Icons.done,
        size: 24,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context, {
    required String title,
  }) {
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
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 30,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InputField(),
        _buildSubtitle(context),
        const _GridIcons(),
      ],
    );
  }

  Row _buildSubtitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.kBigPadding,
            vertical: AppPadding.kMediumPadding,
          ),
          child: Text(
            'Icons',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 24,
            ),
          ),
        )
      ],
    );
  }
}

class _GridIcons extends StatelessWidget {
  const _GridIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.kBigPadding,
        ),
        child: BlocBuilder<AddEventCubit, AddEventState>(
          builder: (context, state) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: AppPadding.kBigPadding,
                crossAxisSpacing: AppPadding.kBigPadding,
              ),
              itemCount: state.icons.length,
              itemBuilder: (context, index) {
                return _buildGridItem(
                  context,
                  index,
                  state.icons[index],
                  state.selectedIcon == index ? true : false,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    int index,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<AddEventCubit>().selectIcon(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              offset: const Offset(2, 2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 36,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController _textFieldController = TextEditingController();
  late final ScaffoldMessengerState _scaffoldMessenger;
  late final AddEventCubit _cubit;

  _InputField({super.key});

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<AddEventCubit>();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
    return Container(
      height: 50,
      child: Center(
        child: Container(
          width: 344,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _textFieldController,
            onChanged: _validInputData,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Event name',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void _validInputData(String value) async {
    if (value.length <= 20) {
      var result = await _cubit.setEventName(value);
      if (!result) {
        _scaffoldMessenger.showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Event with this name has already created'),
        ));
      }
    } else {
      _scaffoldMessenger.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('To long event name'),
      ));
    }
  }
}
