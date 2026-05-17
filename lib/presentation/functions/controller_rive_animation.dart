import 'package:rive/rive.dart';

class DragonRiveController {
  late final StateMachineController? controller;

  // Inputs de la animación
  late final SMIBool? coverEyes;
  late final SMINumber? lookNumber;
  late final SMIBool? unHide;
  late final SMIBool? check;
  late final SMIBool? trigger;

  DragonRiveController(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );

    if (controller == null) return;

    artboard.addController(controller!);

    coverEyes = controller?.findInput<bool>('Cover Eyes') as SMIBool?;
    lookNumber = controller?.findInput<double>('Number 1') as SMINumber?;
    unHide = controller?.findInput<bool>('Unhide') as SMIBool?;
    check = controller?.findInput<bool>('Check') as SMIBool?;
    trigger = controller?.findInput<bool>('Trigger 1') as SMIBool?;
  }

  void emailFocus(bool hasFocus) {
    trigger?.change(true);
    check?.change(hasFocus);
  }

  void nameFocus(bool hasFocus) {
    if (hasFocus) {
      check?.change(true);
    } else {
      check?.change(false);
    }
  }

  void passwordFocus(bool hasFocus, bool isPasswordVisible) {
    if (hasFocus && isPasswordVisible) {
      coverEyes?.change(true);
      unHide?.change(true);
      trigger?.change(true);
    } else if (hasFocus && !isPasswordVisible) {
      coverEyes?.change(true);
      unHide?.change(false);
      trigger?.change(true);
    } else {
      trigger?.change(true);
      coverEyes?.change(false);
      unHide?.change(false);
    }
  }

  void confirmationPasswordFocused(bool hasFocus, bool isPasswordVisible) {
    if (hasFocus && !isPasswordVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (hasFocus && isPasswordVisible) {
      trigger?.change(true);
      check?.change(true);
      coverEyes?.change(true);
    } else if (!hasFocus) {
      coverEyes?.change(false);
      trigger?.change(true);
      check?.change(false);
    }
  }

  void updateLookNumber(int length) {
    lookNumber?.change(length.toDouble());
  }

  void toggleUnHide(bool isPasswordVisible) {
    unHide?.change(isPasswordVisible);
  }
}
