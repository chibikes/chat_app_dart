import 'package:authentication_repository/src/models/chat_app_user.dart';
import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';
abstract class MessageEvent extends Equatable {

}

class SendMessage extends MessageEvent {
  final Message message;

  SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadRecentMessages extends MessageEvent {
  @override
  List<Object?> get props => [];

}

class RetrievedMessages extends MessageEvent{
  final List<Message> messages;

  RetrievedMessages(this.messages);
  @override
  List<Object?> get props => [messages];
}
class GetFriends extends MessageEvent{

  @override
  List<Object?> get props => [];

}
class RetrievedFriends extends MessageEvent {
  final List<User> users;
  RetrievedFriends(this.users);

  @override
  List<Object?> get props => [];

}
class LoadChatFriendMessages extends MessageEvent {
  final User sender;
  final User receiver;

  LoadChatFriendMessages(this.sender, this.receiver);

  @override
  List<Object?> get props => [sender, receiver];
}
class ChatFriendsMessagesRetrieved extends MessageEvent {
  final List<Message> messages;

  ChatFriendsMessagesRetrieved(this.messages);

  @override
  List<Object?> get props => [messages];

}