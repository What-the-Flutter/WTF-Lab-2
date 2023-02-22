import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../../data/models/message.dart';
import '../../repository/firebase_repository.dart';
import '../../repository/shared_pref_app.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final _firebaseRepository = FirebaseRepository();

  MessagesCubit() : super(MessagesState());

  void init(String postId) async {
    initSharPref();
    setPostId(postId);
    _getAllMessages();
  }

  void initSharPref() {
    emit(
      state.copyWith(
        isBubbleAlignment: SharedPreferencesServices().loadBubbleAlignment(),
        backgroundImage: SharedPreferencesServices().loadBackgroundImage(),
      ),
    );
  }

  void _getAllMessages() async {
    final mList = await _firebaseRepository.getAllMessages();
    final messageListByPostId =
        mList.where((e) => e.postId == state.postId).toList();
    emit(
      state.copyWith(
        messageList: messageListByPostId,
      ),
    );
  }

  void setPostId(String postId) {
    emit(state.copyWith(postId: postId));
  }

  void addMessage(Message message) async {
    await _firebaseRepository.addMessage(message);
    final listM = state.messageList;
    listM.add(message);
    emit(
      state.copyWith(
        messageList: listM,
      ),
    );
  }

  void editMessage(String messageText) {
    var editedMess = state.messageList[state.selectedMessage].copyWith(
      textMessage: messageText,
    );
    _firebaseRepository.editMessage(editedMess);
    emit(
      state.copyWith(
        isEditing: false,
        isSelected: false,
        selectedMessage: -1,
      ),
    );
    _getAllMessages();
  }

  void deleteMessage(Message message) async {
    _firebaseRepository.deleteMessage(message);
    _getAllMessages();
  }

  void delete() async {
    final selectedList = await _firebaseRepository.getAllMessages();
    final selectedListByPostId =
        selectedList.where((e) => e.isSelected == true).toList();
    for (final mess in selectedListByPostId) {
      _firebaseRepository.deleteMessage(mess);
    }
    _getAllMessages();
    emit(
      state.copyWith(
        messageList: state.messageList,
      ),
    );
  }

  void cancelSelectMessage() async {
    for (var i = 0; i < state.messageList.length; i++) {
      if (state.messageList[i].isSelected) {
        final unSelected = state.messageList[i].copyWith(
          isSelected: false,
        );
        _firebaseRepository.editMessage(unSelected);
      }
    }
    _getAllMessages();
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void isSelectMessage(int messageIndex) {
    final selectedMess = state.messageList[messageIndex].copyWith(
      isSelected: !state.messageList[messageIndex].isSelected,
    );
    _firebaseRepository.editMessage(selectedMess);
    _getAllMessages();
    emit(
      state.copyWith(
        isSelected: true,
        selectedMessage: messageIndex,
      ),
    );
  }

  void copyClipboardMessage() {
    String selectMessage = '';
    for (final mess in state.messageList) {
      if (mess.isSelected) {
        selectMessage += '${mess.textMessage}';
      }
    }
    Clipboard.setData(
      ClipboardData(text: selectMessage),
    );
    cancelSelectMessage();
  }
}
