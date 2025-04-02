import 'package:flutter/material.dart';

class ScreenTransition extends StatelessWidget {
  @override
  /// Builds the screen transition widget.
  ///
  /// This is a basic Scaffold with an AppBar and a Center widget with
  /// a Text that says 'Welcome to Screen Transition!'.
  ///
  /// This widget is used to test the routing system in Roll and Reserve.
  /// It is not intended to be used in production.
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