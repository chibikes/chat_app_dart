import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app_dart/message_bloc/message_bloc.dart';
import 'package:chat_app_dart/screens/screens.dart';
import 'package:chat_app_dart/screens/settings_screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_user;
import 'package:messages_repository/messages_repository.dart';
import 'tab_screens/tab_screens.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('ChatApp'),
              const SizedBox(width: 180.0,),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children:  [const Icon(Icons.search), const SizedBox(width: 8.0,), GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) {return SettingsScreen(user: context.read<AuthenticationBloc>().state.user!,);}));},child: const Icon(Icons.menu))],
                ),
              ),
            ],
          ),
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

      ),
    );
  }

  static Route<void> route() {
    return MaterialPageRoute(builder: (builder) {
      return const UsersPage();
    });
  }
}







