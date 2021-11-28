import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';
import 'package:chat_app_dart/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend List'),
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is FriendsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          context.read<MessageBloc>().add(
                              LoadChatFriendMessages(
                                  context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user!,
                                  state.users[index]));
                          Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                                return MessageScreen(
                                  chatFriend: state.users[index],
                                );
                              }));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                              NetworkImage(state.users[index].photo!),
                              foregroundImage: null,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              state.users[index].name!,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
          return const Text('this is nothing');
        },
      ),
    );
  }
}