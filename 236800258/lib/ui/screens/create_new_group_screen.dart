import 'package:flutter/material.dart';

import '../widgets/create_new_group_screen_widgets/input_text_field.dart';
import '../widgets/create_new_group_screen_widgets/new_group_app_bar.dart';

class CreateNewGroupScreen extends StatelessWidget {
  const CreateNewGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewGroupAppBar(),
      body: InputTitleTextField(),
    );
  }
}

