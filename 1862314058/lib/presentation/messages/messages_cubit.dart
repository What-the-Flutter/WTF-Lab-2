import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../data/models/message.dart';
import '../../data/models/post.dart';
import '../../repository/firebase_repository.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  User? user;
  late final _firebaseRepository = FirebaseRepository(user: user);

  MessagesCubit({required this.user}) : super(MessagesState(editMode: false));

  void init(Post post) async {
    emit(
      state.copyWith(
        messageList: await _firebaseRepository.getAllMessages(post),
      ),
    );
  }

  void addMessage(Message message) async {
    await _firebaseRepository.addMessage(message);
    final listM = state.messageList;
    listM.add(message);
    emit(
      state.copyWith(messageList: listM),
    );
  }

  void editMessage(Message messageItem, int index) async {
    await _firebaseRepository.editMessage(messageItem);
    final listM = state.messageList;
    listM[index] = messageItem;
    emit(
      state.copyWith(messageList: listM),
    );
  }

  void deleteMessage() async {
    for (int i = 0; i < state.messageList.length; i++) {
      if (state.messageList[i].isSelectedMessage) {
        await _firebaseRepository.deleteMessage(
          state.messageList[i],
        );
        state.messageList.removeAt(i);
        i--;
      }
    }
    emit(
      state.copyWith(messageList: state.messageList),
    );
  }

  void changeEditMode() {
    emit(
      state.copyWith(
        editMode: !state.editMode,
      ),
    );
  }

  void isSelectMessage(int index) {
    final listM = state.messageList;
    listM[index].isSelectedMessage = true;
    emit(
      state.copyWith(messageList: listM),
    );
  }

  void cancelSelectMessage() {
    for (final mess in state.messageList) {
      if (mess.isSelectedMessage) {
        mess.isSelectedMessage = false;
      }
    }
    emit(
      state.copyWith(editMode: false),
    );
  }

  void copyClipboardMessage() {
    var selectMessage = '';
    for (final mess in state.messageList) {
      if (mess.isSelectedMessage) {
        selectMessage += '${mess.textMessage}';
      }
    }
    Clipboard.setData(
      ClipboardData(text: selectMessage),
    );
    cancelSelectMessage();
  }
}
