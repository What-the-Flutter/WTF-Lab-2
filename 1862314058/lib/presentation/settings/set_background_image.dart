import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'settings_state.dart';

class SetBackgroundImage extends StatefulWidget {
  @override
  State<SetBackgroundImage> createState() => _SetBackgroundImageState();
}

class _SetBackgroundImageState extends State<SetBackgroundImage> {
  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _settingsAppBar(context),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Container(
            child: state.backgroundImage == null
                ? _pickNewImage()
                : _updateImage(state),
          );
        },
      ),
    );
  }

  Column _pickNewImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Click the button below to set the Background Image',
        ),
        OutlinedButton(
          onPressed: () async {
            _pickBackgroundImage();
          },
          child: const Text(
            'Pick an Image',
          ),
        ),
      ],
    );
  }

  Padding _updateImage(SettingsState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        children: <Widget>[
          state.backgroundImage != null
              ? Image.file(
                  File(
                    state.backgroundImage,
                  ),
                  height: 320,
                  width: 250,
                )
              : const Text(
                  'Fail to load image file',
                ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.delete,
                ),
                title: const Text(
                  'Unset image',
                ),
                onTap: () {
                  BlocProvider.of<SettingsCubit>(context)
                      .deleteBackgroundImage();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.image,
                ),
                title: const Text(
                  'Pick a new image',
                ),
                onTap: () async {
                  _pickBackgroundImage();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future _pickBackgroundImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        BlocProvider.of<SettingsCubit>(context).saveBackgroundImage(
          pickedFile.path.toString(),
        );
      } else {
        print('Null error');
      }
    } catch (e) {
      print('Error pick image');
    }
  }

  AppBar _settingsAppBar(BuildContext context) {
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
