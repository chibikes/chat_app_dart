import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';

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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: [
                          Text(state.friendsMessages[index].receiver.name!),
                          Text(state.friendsMessages[index].text),
                        ],
                      ),
                    ],
                  ),
                );
              });
        } else {
          return const Text('loading');
        }
      },
    );
  }
}