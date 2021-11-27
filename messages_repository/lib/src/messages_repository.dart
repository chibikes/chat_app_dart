import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authentication_repository/authentication_repository.dart'
    as AuthUser;

import 'models/models.dart';

class MessagesRepository {
  final messageCollection = FirebaseFirestore.instance.collection('messages');
  final users = FirebaseFirestore.instance
      .collection('users'); //TODO: this should clearly be in user's repository

  Stream<List<Message>> getMessages(AuthUser.User sender, AuthUser.User receiver) {
    List<String> ids = [sender.id!, receiver.id!];

    ids.sort();
    return messageCollection
        .where('commonId', isEqualTo: '${ids[0]}${ids[1]}')
        .orderBy('timeCreated', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((e) => Message.fromEntity(MessageEntity.fromJson(e.data(),),),)
          .toList();
    });
  }

  Future<void> sendMessage(Message message) async{
    await messageCollection.add(message.toEntity().toDocument());
  }

  Stream<List<Message>> getFriendsMessages() {
    try {
      return messageCollection
          .where(
          'receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('timeCreated', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((e) => Message.fromEntity(MessageEntity.fromJson(e.data(),),),)
            .toList();
      });
    } catch (e) {
      print('This is the error: *************** $e');
      return Stream.value(List.filled(1, Message.empty));
    }
  }

  Future<List<AuthUser.User>> getAllUsers() async {
    List<AuthUser.User> friends = [];
    await users.get().then((value) {
      value.docs.forEach((element) {
        friends.add(AuthUser.User.fromMap(element.data()));
      });
    });
    return friends;
  }
}
