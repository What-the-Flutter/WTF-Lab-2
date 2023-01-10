import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '/utils/chat_card.dart';


class NewChatCubit extends Cubit<ChatCard> {
  NewChatCubit() : super(_initialChatCard);

  void setText(String title) => emit(state.copyWith(title: title));

  void setIcon(Icon icon) => emit(state.copyWith(icon: icon));

  void setChatCard(ChatCard chatCard) => emit(chatCard);
}

const _initialChatCard = ChatCard(
  icon: Icon(
    IconData(0xe481, fontFamily: 'MaterialIcons'),
  ),
  title: '',
);
