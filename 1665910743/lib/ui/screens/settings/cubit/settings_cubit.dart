import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final bool alignRight;
  final String image;

  SettingsCubit({
    required this.alignRight,
    required this.image,
  }) : super(
          SettingsState(
            chatTileAlignment:
                alignRight ? Alignment.centerRight : Alignment.centerLeft,
            backgroundImagePath: image,
          ),
        );

  Future<void> alignmentLeft() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('align', false);

    emit(state.copyWith(chatTileAlignment: Alignment.centerLeft));
  }

  Future<void> alignmentRight() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('align', true);

    emit(state.copyWith(chatTileAlignment: Alignment.centerRight));
  }

  Future<void> removeBackrgoundImage() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('image', '');

    emit(
      SettingsState(
        chatTileAlignment: state.chatTileAlignment,
        backgroundImagePath: '',
      ),
    );
  }

  void getBackgroundImage() async {
    final _prefs = await SharedPreferences.getInstance();
    final picker = ImagePicker();
    final _pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      _prefs.setString('image', _pickedFile.path);
      emit(
        SettingsState(
          chatTileAlignment: state.chatTileAlignment,
          backgroundImagePath: _pickedFile.path,
        ),
      );
    }
  }
}
