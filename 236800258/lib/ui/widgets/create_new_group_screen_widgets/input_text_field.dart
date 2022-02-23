import 'package:flutter/material.dart';

import '../../../entities/group.dart';
import '../../../navigation/route_names.dart';

class InputTitleTextField extends StatefulWidget {
  final Group? editingGroup;

  InputTitleTextField({
    Key? key,
    this.editingGroup,
  }) : super(key: key);

  @override
  State<InputTitleTextField> createState() => _InputTitleTextFieldState();
}

class _InputTitleTextFieldState extends State<InputTitleTextField> {
  final _controller = TextEditingController();
  Icon? _selectedIcon;
  final List<Icon> _groupsIcons = const [
    Icon(Icons.account_balance_rounded),
    Icon(Icons.zoom_in_rounded),
    Icon(Icons.accessibility_sharp),
    Icon(Icons.home),
    Icon(Icons.airplanemode_active),
    Icon(Icons.drive_eta),
    Icon(Icons.store),
    Icon(Icons.airplane_ticket),
    Icon(Icons.videogame_asset_sharp),
    Icon(Icons.wc),
    Icon(Icons.account_box),
    Icon(Icons.monetization_on_outlined),
    Icon(Icons.add_shopping_cart),
    Icon(Icons.ac_unit),
    Icon(Icons.sports_football),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingGroup != null) {
      _controller.text = widget.editingGroup!.title;
      _selectedIcon = _groupsIcons
          .firstWhere((el) => el.icon == widget.editingGroup!.groupIcon.icon);
    }
  }

  void onAddButtonPresed() {
    if (_controller.text.isNotEmpty && _selectedIcon != null) {
      Navigator.of(context).popAndPushNamed(
        RouteNames.mainScreen,
        arguments: Group(
          groupIcon: _selectedIcon!,
          title: _controller.text,
          createdAt: DateTime.now(),
          editedAt: DateTime.now(),
        ),
      );
    }
  }

  void onEditButtonPresed() {
    if (_controller.text.isNotEmpty && _selectedIcon != null) {
      Navigator.of(context).popAndPushNamed(
        RouteNames.mainScreen,
        arguments: Group(
          groupIcon: _selectedIcon!,
          title: _controller.text,
          editingIndex: widget.editingGroup!.editingIndex,
          createdAt: widget.editingGroup!.createdAt,
          editedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: 'Enter new group title',
            ),
            controller: _controller,
            onChanged: (value) {
              _controller.text = value;
              setState(() {});
            },
          ),
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: BoxConstraints.loose(
              const Size(500, 60),
            ),
            child: AspectRatio(
              aspectRatio: 21 / 3,
              child: ElevatedButton(
                onPressed: widget.editingGroup != null
                    ? onEditButtonPresed
                    : onAddButtonPresed,
                child: const Text('Submit'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 90,
              children: List.generate(
                _groupsIcons.length,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: _selectedIcon == _groupsIcons[index]
                          ? Colors.green
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_selectedIcon == _groupsIcons[index]) {
                          return;
                        } else {
                          _selectedIcon = _groupsIcons[index];
                        }
                        setState(() {});
                      },
                      icon: _groupsIcons[index],
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
