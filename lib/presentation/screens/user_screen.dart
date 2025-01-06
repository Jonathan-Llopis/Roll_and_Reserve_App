import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/menu_lateral.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarDefault(
        scaffoldKey: scaffoldKey,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
              ),
              child: const Text(
                "Tiendas en tu zona",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      endDrawer: const MenuLateral(),
    );
  }
}
