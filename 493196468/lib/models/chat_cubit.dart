import 'package:bloc/bloc.dart';
import '../repo/messages/messages_repository.dart';
import '../utils/message.dart';
import 'filter_cubit.dart';

class MessageCubit extends Cubit<List<Message>> {
  final MessagesRepository messagesRepository;
  final FilterCubit filterCubit;

  MessageCubit(
    this.messagesRepository,
    this.filterCubit,
  ) : super([]);

  void emitMessagesFromChat(int chatId) async => filterCubit.isFiltered()
      ? filterMessages(filterCubit.state.filter, chatId)
      : emit(await messagesRepository.getMessagesFromChat(chatId));

  void addMessage(Message message) {
    var inEdit = state.indexWhere((element) => element.onEdit);
    if (message.text.isNotEmpty) {
      inEdit == -1
          ? messagesRepository.addMessage(message)
          : editMessage(message.text);
    }
    emitMessagesFromChat(message.chatId!);
  }

  void editMessage(String text) {
    var editableMessage = state.firstWhere((element) => element.onEdit);
    messagesRepository.editMessage(
        editableMessage.copyWith(text: text, onEdit: false, isSelected: false));
    emitMessagesFromChat(editableMessage.chatId!);
  }

  void copyMessage() {
    var selectedMessage = state.firstWhere((element) => element.isSelected);
    messagesRepository
      ..copyMessage(selectedMessage)
      ..editMessage(selectedMessage.copyWith(isSelected: false));
    emitMessagesFromChat(selectedMessage.chatId!);
  }

  void deleteSelectedMessages() {
    var chatId = state.first.chatId!;
    var selectedMessages = state.where((element) => element.isSelected);
    for (var element in selectedMessages) {
      messagesRepository.deleteMessage(element);
    }
    emitMessagesFromChat(chatId);
  }

  void deleteMessage(Message message) {
    messagesRepository.deleteMessage(message);
    emitMessagesFromChat(message.chatId!);
  }

  void selectMessage(Message message) async {
    messagesRepository.selectMessage(message);
    emitMessagesFromChat(message.chatId!);
  }

  void unselectAllMessages() {
    var chatId = state.first.chatId!;
    messagesRepository.unselectAllMessages(state);
    emitMessagesFromChat(chatId);
  }

  void startEditMessage(Message message) {
    messagesRepository.startEditMessage(message);
    emitMessagesFromChat(message.chatId!);
  }

  void startEditSelectedMessage() async {
    var chatId = state.first.chatId!;
    var selectedMessage = state.firstWhere((element) => element.isSelected);
    messagesRepository.startEditMessage(selectedMessage);
    emitMessagesFromChat(chatId);
  }

  void filterMessages(String filter, int chatId) async {
    var filteredMessages =
        await messagesRepository.filterMessages(filter, chatId);
    emit(filteredMessages);
  }

  void migrateMessages(int selectedChatId, int chatId) {
    messagesRepository.migrateMessages(selectedChatId, state);
    emitMessagesFromChat(chatId);
  }
}
