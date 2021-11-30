import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messages_repository/messages_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user;
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final time =
                        DateTime.parse(state.messages[index].timeCreated)
                            .toLocal();
                        String timeMessage = DateFormat("h: mm a").format(time);
                        bool isMyMessage =
                            state.messages[index].senderId != chatFriend!.id;
                        return Align(
                          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // width: 50.0,
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
                                child: Column(
                                  children: [
                                    Text(
                                        '${state.messages[index].text}   $timeMessage'),
                                    state.messages[index].imgUrl.isNotEmpty ? Image.network(state.messages[index].imgUrl) : const Text('')


                                  ],
                                ),
                              ),
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
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        // color: Colors.white,
                        width: 300.0,
                        child: Row(
                          children: [
                            const Expanded(child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('\u263A'),
                            )),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: _textEditingController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Message',
                                ),
                              ),
                            ),
                             Expanded(
                               child: GestureDetector(
                                   onTap: () async{
                                     final ImagePicker _picker = ImagePicker();
                                     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                     String myImgUrl = await sendImageToCloud(image!.path, context.read<AuthenticationBloc>().state.user!);

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
                                         commonId: '${ids[0]}${ids[1]}',
                                         imgUrl: myImgUrl,
                                     );
                                     context.read<MessageBloc>().add(SendMessage(message),
                                     );
                                   },
                                   child: const Icon(Icons.attachment)),),
                            Expanded(child: GestureDetector(onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                              String myImgUrl = await sendImageToCloud(image!.path, context.read<AuthenticationBloc>().state.user!);

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
                                commonId: '${ids[0]}${ids[1]}',
                                imgUrl: myImgUrl,
                              );
                              context.read<MessageBloc>().add(SendMessage(message),
                              );

                            },child: Icon(Icons.camera)),),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      SizedBox(
                        width: 45.0,
                        height: 45.0,
                        child: FloatingActionButton(
                          child: const Icon(Icons.message,),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const Padding(padding: EdgeInsets.only(top: 15.0),child: Text('last seen today at 1.04 pm')),
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

  Future<String> sendImageToCloud(String path, User user) async{
    File file = File(path);
    print(file.absolute);
    String storageRef;

    try {
      storageRef = 'users/${user.id}.png';
      await FirebaseStorage.instance.ref(storageRef).putFile(file);
      return FirebaseStorage.instance.ref(storageRef).getDownloadURL().onError((error, stackTrace) => Future.value(user.photo));
    }catch (e) {
      print('Firebase Storage Exception **********  $e');
      storageRef = 'users/${user.id}.jpg';
      await FirebaseStorage.instance.ref('users/${user.id}.jpg').putFile(file);
      return FirebaseStorage.instance.ref(storageRef).getDownloadURL().onError((error, stackTrace) => Future.value(user.photo));
    }

  }
  sendMessage(Message message) {
    List<String> ids = [myId, chatFriend!.id!];
    ids.sort();

   //TODO: complete method implementation
  }
}