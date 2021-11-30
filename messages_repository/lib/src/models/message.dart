import 'package:authentication_repository/authentication_repository.dart';
import 'package:messages_repository/src/models/message_entity.dart';

class Message {
  final String text;
  final String timeCreated;
  final String senderId;
  final String receiverId;
  final User sender;
  final User receiver;
  final String commonId; /// all messages b/w user and sender has this identification
  final String imgUrl;

  const Message({
    required this.commonId,
    required this.text,
    required this.timeCreated,
    required this.senderId,
    required this.receiverId,
    required this.sender,
    required this.receiver,
    this.imgUrl = '',
  });


  static const empty = Message(text: 'welcome to ChatApp', timeCreated: '00:00:00', senderId: 'null', receiverId: 'null', sender: User.empty, receiver: User.empty, commonId: 'null');

  Message copyWith(
      {String? text,
      String? timeCreated,
      String? senderId,
      String? receiverId,
      User? sender,
      User? receiver,
        String? commonId,
        String? imgUrl,
      }) {
    return Message(
      text: text ?? this.text,
      timeCreated: timeCreated ?? this.timeCreated,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      commonId: commonId ?? this.commonId,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(text, timeCreated, senderId, receiverId, sender, receiver, commonId, imgUrl);
  }

  @override
  int get hashCode {
    return text.hashCode ^
        timeCreated.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        sender.hashCode ^
        receiver.hashCode ^
        commonId.hashCode ^
        imgUrl.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Message &&
            runtimeType == other.runtimeType &&
            text == other.text &&
            timeCreated == other.text &&
            senderId == other.senderId &&
            receiverId == other.receiverId &&
            sender == other.sender &&
            receiver == other.receiver &&
            commonId == other.commonId &&
            imgUrl == other.imgUrl;
  }

  static Message fromEntity(MessageEntity messageEntity) {
    return Message(
        text: messageEntity.text,
        timeCreated: messageEntity.timeCreated,
        senderId: messageEntity.senderId,
        receiverId: messageEntity.receiverId,
        sender: messageEntity.sender,
        receiver: messageEntity.receiver,
        commonId: messageEntity.commonId,
        imgUrl: messageEntity.imgUrl,
        );
  }

}
