import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  const DefaultScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: DefaultAppBar(scaffoldKey: scaffoldKey),
      body: body,
      floatingActionButton:
          floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      endDrawer: const DrawerMain(),
    );
  }
}
