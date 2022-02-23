import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants/colors.dart';

class BotChatButton extends StatelessWidget {
  const BotChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : null,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? CustomColors.botChatButtonColor
              : CustomColors.darkBotChatButtonColor,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.robot),
            const SizedBox(width: 20),
            const Text(
              'Questionnaire Bot',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
