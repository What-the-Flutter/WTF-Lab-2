import 'package:flutter/material.dart';

import '../../entities/group.dart';
import '../../navigation/route_names.dart';
import '../widgets/home_screen_widgets/bot_chat_button.dart';
import '../widgets/home_screen_widgets/groups_list.dart';

class HomeScreen extends StatelessWidget {
  final Group? newGroup;
  final Group? editedGroup;

  const HomeScreen({
    Key? key,
   required this.newGroup,
    required this.editedGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const BotChatButton(),
            Container(
              height: 10,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : null,
            ),
            GroupsList(
              newGroup: newGroup,
              editedGroup: editedGroup,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .popAndPushNamed(RouteNames.createNewGroupScreen);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
