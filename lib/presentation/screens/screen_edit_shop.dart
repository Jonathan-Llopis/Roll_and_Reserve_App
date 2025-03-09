import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_edit_shop.dart';

class ScreenEditShop extends StatelessWidget {
  final int? idShop;

  final PreferredSizeWidget appBar;
  const ScreenEditShop({super.key, this.idShop, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        appBar: appBar, body: BodyEditShop(idShop: idShop, widget: this));
  }
}
