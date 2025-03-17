import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget appBar;
  const DefaultScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton:
          floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      endDrawer:  DrawerMain(appBar: appBar),
    );
  }
}
