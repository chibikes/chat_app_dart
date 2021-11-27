import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String text;
  final String timeCreated;
  final String senderId;
  final String receiverId;
  final User sender;
  final User receiver;
  final String commonId;

  const MessageEntity(
      this.text, this.timeCreated, this.senderId, this.receiverId, this.sender, this.receiver, this.commonId);

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timeCreated': timeCreated,
      'senderId': senderId,
      'receiverId': receiverId,
      'sender' : sender.toMap(),
      'receiver': receiver.toMap(),
    };
  }

  static MessageEntity fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      json['text'] as String,
      json['timeCreated'] as String,
      json['senderId'] as String,
      json['receiverId'] as String,
      User.fromMap(json['sender']),
      User.fromMap(json['receiver']),
      json['commonId'] as String,

    );
  }

  static MessageEntity fromSnapshot(dynamic snapshot) {
    return MessageEntity(
        snapshot.data()['text'],
        snapshot.data()['timeCreated'],
        snapshot.data()['senderId'],
        snapshot.data()['receiverId'],
        User.fromMap(snapshot.data()['sender']),
        User.fromMap(snapshot.data()['receiver'],),
        snapshot.data()['commonId'],

    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'text': text,
      'timeCreated': timeCreated,
      'senderId': senderId,
      'receiverId' : receiverId,
      'sender' : sender.toMap(),
      'receiver' : receiver.toMap(),
      'commonId' : commonId,
    };
  }

  @override
  List<Object?> get props => [text, timeCreated, senderId, receiverId, sender, receiver, commonId];
}
