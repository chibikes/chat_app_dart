import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user;
import 'package:intl/intl.dart';

class MessageScreen extends StatelessWidget {
  final User? chatFriend;
  final String myId = firebase_user.FirebaseAuth.instance.currentUser!.uid;
  final _textEditingController = TextEditingController();

  MessageScreen({Key? key, this.chatFriend}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is ChatFriendMessagesLoaded) {
            return Stack(
              children: [
                Positioned(
                  width: 80.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final time =
                        DateTime.parse(state.messages[index].timeCreated)
                            .toLocal();
                        String timeMessage = DateFormat("h: mm a").format(time);
                        bool isMyMessage =
                            state.messages[index].senderId != chatFriend!.id;
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 8.0,
                              top: 8.0,
                              left: isMyMessage ? 0.0 : 8.0),
                          child: Container(
                            width: 50.0,
                            decoration: BoxDecoration(
                                color: isMyMessage
                                    ? Colors.white
                                    : Colors.lightBlueAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: !isMyMessage
                                      ? Radius.zero
                                      : const Radius.circular(16.0),
                                  topRight: !isMyMessage
                                      ? const Radius.circular(16.0)
                                      : Radius.zero,
                                  bottomLeft: const Radius.circular(16.0),
                                  bottomRight: const Radius.circular(16.0),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${state.messages[index].text}   $timeMessage'),
                            ),
                          ),
                        );
                      }),
                ),
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
                          List<String> ids = [myId, chatFriend!.id!];
                          ids.sort();

                          Message message = Message(
                              text: _textEditingController.text,
                              timeCreated: DateTime.now().toUtc().toString(),
                              sender: chatFriend!,
                              receiver: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!,
                              receiverId: myId,
                              senderId: chatFriend!.id!,
                              commonId: '${ids[0]}${ids[1]}');
                          context.read<MessageBloc>().add(SendMessage(message));
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  width: MediaQuery.of(context).size.width,
                  height: 85.0,
                  child: Container(
                    alignment: Alignment.center,
                    // height: 50.0,
                    color: Colors.teal,
                    // width: double.infinity,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(chatFriend!.photo!),
                        ),
                        Column(
                          children: [
                            Text(
                              chatFriend!.name!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text('last seen today at 1.04 pm'),
                          ],
                        ),
                        const Icon(
                          Icons.video_call,
                          color: Colors.white,
                        ),
                        const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
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