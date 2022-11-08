import 'package:bloc/bloc.dart';
import '../../repo/chats/chat_list_api.dart';
import '../home_entity/chat_card.dart';

class HomeCubit extends Cubit<List<ChatCard>> {
  HomeCubit(super.initialState);

  void addChat({required ChatCard newChatCard}) => emit(ChatListApi.addChat(newChatCard));

  void editChat(String title) => emit(ChatListApi.editChat(title));

  void deleteSelectedChats() => emit(ChatListApi.deleteSelectedChats());

  void selectChat(index) => emit(ChatListApi.selectChat(index));

  void unselectAllChats() => emit(ChatListApi.unselectAllChats());
}
