import 'dart:io';
import '/utils/message.dart';
import 'firebase_implementation.dart';

class MessagesRepository {
  final FirebaseRepository _firebaseRepository;

  MessagesRepository(this._firebaseRepository);

  void listenForUpdates({required Function onUpdate}) =>
      _firebaseRepository.listenForUpdates(onUpdate: onUpdate);

  Future<List<Message>> getAllMessages() async =>
      _firebaseRepository.getAllMessages();

  String? addMessage(Message message) =>
      _firebaseRepository.addMessage(message);

  void editMessage(Message message) => _firebaseRepository.editMessage(message);

  void deleteMessage(Message message) =>
      _firebaseRepository.deleteMessage(message);

  Future<String> uploadPicture(File file, String id) async =>
      _firebaseRepository.uploadPicture(file, id);

  void deletePicture(String id) => _firebaseRepository.deletePicture(id);

  Future<String> editPicture(File file, String id) async =>
      _firebaseRepository.editPicture(file, id);
}
