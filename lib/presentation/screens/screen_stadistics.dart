import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_stadistics.dart';

class ScreenStadistics extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final int idShop;
  const ScreenStadistics({super.key, required this.appBar, required this.idShop});

  @override
  /// Builds the stadistics screen widget.
  ///
  /// This widget is a [DefaultScaffold] with the given [appBar] and a
  /// [BodyStadistics] as the body. The [BodyStadistics] is given the
  /// id of the shop.
  ///
  /// Returns a [Widget] that is a DefaultScaffold with the given
  /// appBar and body.
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBar: appBar,
      body: BodyStadistics(idShop: idShop),
    );
  }
}
