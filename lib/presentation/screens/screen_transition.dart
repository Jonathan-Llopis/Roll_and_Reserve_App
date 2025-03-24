import 'package:flutter/material.dart';

class ScreenTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Transition'),
      ),
      body: Center(
        child: Text('Welcome to Screen Transition!'),
      ),
    );
  }
}