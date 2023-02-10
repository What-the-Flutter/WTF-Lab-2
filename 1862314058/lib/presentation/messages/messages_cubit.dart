import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../../data/models/message.dart';
import '../../data/models/post.dart';
import '../../repository/firebase_repository.dart';
import '../../repository/shared_pref_app.dart';
import 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final _firebaseRepository = FirebaseRepository();

  MessagesCubit() : super(MessagesState(editMode: false));

  void init(Post post) async {
    initSharPref();
    _getAllMess(post.id.toString());
  }

  void initSharPref() {
    emit(
      state.copyWith(
        isBubbleAlignment: SharedPreferencesServices().loadBubbleAlignment(),
        backgroundImage: SharedPreferencesServices().loadBackgroundImage(),
      ),
    );
  }

  void _getAllMess(String postId) async {
    _firebaseRepository.listenMessages(postId).listen(
      (event) {
        var messages = <Message>[];
        var data = (event.snapshot.value ?? {}) as Map;
        data.forEach(((key, value) {
          messages.add(Message.fromJson({'id': key, ...value}));
        }));
        emit(
          state.copyWith(
            messageList: messages,
          ),
        );
      },
    );
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

  void editMessage(Message messageItem, int index) async {
    await _firebaseRepository.editMessage(messageItem);
    final listM = state.messageList;
    listM[index] = messageItem;
    emit(
      state.copyWith(
        messageList: listM,
      ),
    );
  }

  void deleteMessage(String postId, String messageId) async {
    for (int i = 0; i < state.messageList.length; i++) {
      if (state.messageList[i].isSelectedMessage) {
        await _firebaseRepository.deleteMessage(postId, state.messageList[i].id.toString());
        state.messageList.removeAt(i);
        i--;
      }
    }
    emit(
      state.copyWith(
        messageList: state.messageList,
      ),
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
    String selectMessage = '';
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
