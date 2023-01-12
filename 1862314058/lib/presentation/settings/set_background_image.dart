import 'package:flutter/material.dart';

class SetBackgroundImage extends StatelessWidget {
  const SetBackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingsAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Click the button below to set the Background Image',
          ),
          OutlinedButton(
            onPressed: () {
              //open gallery
            },
            child: const Text(
              'Pick an Image',
            ),
          ),
        ],
      ),
    );
  }

  AppBar settingsAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_outlined,
        ),
      ),
      title: const Text(
        'Background Image',
      ),
    );
  }
}
