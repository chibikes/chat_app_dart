import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user;
import 'package:messages_repository/messages_repository.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ChatApp'),
          bottom: const TabBar(
            padding: EdgeInsets.all(0.0),
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RecentMessagesPage(),
            FriendsStatusPage(),
            VoiceCallsPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<MessageBloc>().add(GetFriends());
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const FriendsList();
            }));
          },
        ),
      ),
    );
  }

  static Route<void> route() {
    return MaterialPageRoute(builder: (builder) {
      return const UsersPage();
    });
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is FriendsLoaded) {
            return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<MessageBloc>().add(LoadChatFriendMessages(
                          context.read<AuthenticationBloc>().state.user!,
                          state.users[index]));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return MessageScreen(
                          user: state.users[index],
                        );
                      }));
                    },
                    child: Text(state.users[index].name!),
                  );
                });
          }
          return const Text('this is nothing');
        },
      ),
    );
  }
}

class MessageScreen extends StatelessWidget {
  final User? user;
  final String myId = firebase_user.FirebaseAuth.instance.currentUser!.uid;
  final _textEditingController = TextEditingController();

  MessageScreen({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is ChatFriendMessagesLoaded) {
            return Stack(
              children: [
                ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 8.0,
                            left: state.messages[index].receiver.id == myId
                                ? 0.0
                                : 8.0),
                        child: Container(
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: state.messages[index].receiver.id == myId ? Radius.zero : const Radius.circular(16.0),
                              topRight: state.messages[index].receiver.id == myId ? const Radius.circular(16.0) : Radius.zero,
                              bottomLeft: const Radius.circular(16.0),
                              bottomRight: const Radius.circular(16.0),
                            )
                          ),
                          child: Text(state.messages[index].text),
                        ),
                      );
                    }),
                // Align(),

                Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 270.0,
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.message),
                        onPressed: () {
                          List<String> ids = [myId, user!.id!];
                          ids.sort();

                          Message message = Message(
                              text: _textEditingController.text,
                              timeCreated: DateTime.now().toUtc().toString(),
                              sender: User(
                                id: myId,
                                name: 'Okoh',
                              ),
                              receiver: user!,
                              receiverId: user!.id!,
                              senderId: myId,
                              commonId: '${ids[0]}${ids[1]}');
                          context.read<MessageBloc>().add(SendMessage(message));
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class VoiceCallsPage extends StatelessWidget {
  const VoiceCallsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

class FriendsStatusPage extends StatelessWidget {
  const FriendsStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Text('implement build');
  }
}

class RecentMessagesPage extends StatelessWidget {
  const RecentMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return ListView.builder(
              itemCount: state.friendsMessages.length,
              itemBuilder: (context, index) {
                ImageProvider imageProvider;
                String imgUrl = state.friendsMessages[index].sender.photo!;
                imgUrl.isEmpty
                    ? imageProvider =
                        const AssetImage('assets/profile_avatar.jpg')
                    : imageProvider = NetworkImage(imgUrl);
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    Column(
                      children: [
                        Text(state.friendsMessages[index].receiver.name!),
                        Text(state.friendsMessages[index].text),
                      ],
                    ),
                  ],
                );
              });
        } else {
          return const Text('loading');
        }
      },
    );
  }
}
