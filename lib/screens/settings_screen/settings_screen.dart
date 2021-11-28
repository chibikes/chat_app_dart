import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:chat_app_dart/screens/settings_screen/profile_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  final User? user;

  const SettingsScreen({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {return ProfileSettingsScreen(user: context.read<AuthenticationBloc>().state.user!);}));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(height: 13.0,),
                  Text(user!.name!),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                 Icon(Icons.account_circle_sharp),
                SizedBox(height: 13.0,),
                Text('Account'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.message),
                SizedBox(height: 13.0,),
                Text('Chats'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.notifications),
                SizedBox(height: 13.0,),
                Text('Notifications'),
              ],
            ),
          ),
        ],
      ),
    );
  }

}