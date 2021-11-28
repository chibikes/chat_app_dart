import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:chat_app_dart/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final User user;

  const ProfileSettingsScreen({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(context.read<AuthenticationBloc>().state.user!.photo!),
                  ),
                  Container(
                      // TODO: replace with positioned widget and check what'll happen
                      width: 40,
                      height: 40,
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          onPressed: () async{
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            String myImgUrl = await sendImageToCloud(image!.path);
                            context.read<AuthenticationBloc>().add(UpdateUser(user.copyWith(photo: myImgUrl)));
                          }, child: const Icon(Icons.camera))),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.person),
              Column(
                children: [const Text('Name'), Text(user.name!)],
              ),
              const Icon(Icons.edit),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> sendImageToCloud(String path) async{
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
}
