import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:messages_repository/messages_repository.dart';

abstract class MessageState extends Equatable {

}
class MessagesLoading extends MessageState {
  @override
  List<Object?> get props => [];

}

class MessagesLoaded extends MessageState {
  final List<Message> friendsMessages;
  // final List<User> friends;

  MessagesLoaded(this.friendsMessages,);
  @override
  List<Object?> get props => [friendsMessages];

}

class FriendsLoaded extends MessageState {
  final List<User> users;

  FriendsLoaded(this.users);

  @override
  List<Object?> get props => [users];
}
class ChatFriendMessagesLoaded extends MessageState {
  final List<Message> messages;

  ChatFriendMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}
class MessageSent extends MessageState {
  @override
  List<Object?> get props => [];

}