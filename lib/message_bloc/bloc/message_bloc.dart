import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app_dart/message_bloc/bloc/message_event.dart';
import 'package:chat_app_dart/message_bloc/bloc/message_state.dart';
import 'package:messages_repository/messages_repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc(MessageState initialState, this._messagesRepository) : super(initialState);

  final MessagesRepository _messagesRepository;
  StreamSubscription? _friendsMessagesSubscription;
  StreamSubscription? _chatFriendSubscription;



  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if(event is LoadFriendsMessages) {
      yield* _mapLoadFriendsMessagesToState();
    }
    else if(event is SendMessage) {
      yield* _mapSendMessageToState(event);
    }
    else if(event is RetrievedMessages) {
      yield* _mapMessagesRetrievedToState(event);
    }

    else if (event is GetFriends) {
      yield* _mapGetFriendsToState();
    }
    else if (event is RetrievedFriends) {
      yield* _mapRetrievedFriendsToState(event);
    }
    else if (event is LoadChatFriendMessages) {
      yield* _mapLoadChatFriendMessagesToState(event);
    }
    else if (event is ChatFriendsMessagesRetrieved) {
      yield* _mapChatFriendsMessagesRetrievedToState(event);
    }

  }

  Stream<MessageState>_mapLoadFriendsMessagesToState() async* {
    _friendsMessagesSubscription?.cancel();
    _friendsMessagesSubscription = _messagesRepository.getFriendsMessages().listen((messages) {
      add(RetrievedMessages(messages));
    });
  }

  Stream<MessageState>_mapSendMessageToState(SendMessage event) async* {
    //TODO: handle error cases
    await _messagesRepository.sendMessage(event.message);
    add(LoadChatFriendMessages(event.message.sender, event.message.receiver));
    // yield MessageSent();
  }

  Stream<MessageState>_mapMessagesRetrievedToState(RetrievedMessages event) async* {
    yield MessagesLoaded(event.messages);
  }

  @override
  Future<void> close() {
    _friendsMessagesSubscription!.cancel();
    _chatFriendSubscription!.cancel();
    return super.close();
  }

  Stream<MessageState>_mapGetFriendsToState() async* {
    List<User> users = await _messagesRepository.getAllUsers();
    add(RetrievedFriends(users));
  }

  Stream<MessageState>_mapRetrievedFriendsToState(RetrievedFriends event) async*{
    yield FriendsLoaded(event.users);
  }

  Stream<MessageState>_mapLoadChatFriendMessagesToState(LoadChatFriendMessages event) async*{
    _chatFriendSubscription?.cancel();
    _chatFriendSubscription = _messagesRepository.getMessages(event.sender, event.receiver).listen((messages) {
      add(ChatFriendsMessagesRetrieved(messages));
    });
  }

  Stream<MessageState>_mapChatFriendsMessagesRetrievedToState(ChatFriendsMessagesRetrieved event) async*{
    yield ChatFriendMessagesLoaded(event.messages);
  }

}

