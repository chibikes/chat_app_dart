import 'package:flutter/material.dart';

class VoiceCallsPage extends StatelessWidget {
  const VoiceCallsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {

      },
      child: const Icon(Icons.call_sharp),
      ),
      body: ListView(),
    );
  }
}