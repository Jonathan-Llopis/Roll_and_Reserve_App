import 'package:rive/rive.dart' as rive;

class RiveAnimationController {
  late final rive.StateMachineController? controller;

  // Inputs de la animación
  late final rive.SMIInput<bool>? coverEyes;
  late final rive.SMIInput<double>? lookNumber;
  late final rive.SMIInput<bool>? unHide;
  late final rive.SMIInput<bool>? check;
  late final rive.SMIInput<bool>? trigger;

  RiveAnimationController(rive.Artboard artboard) {
    controller = rive.StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    );

    if (controller == null) return;

    artboard.addController(controller!);

    coverEyes = controller?.findInput<bool>("Cover Eyes");
    lookNumber = controller?.findInput<double>("Number 1");
    unHide = controller?.findInput<bool>("Unhide");
    check = controller?.findInput<bool>("Check");
    trigger = controller?.findInput<bool>("Trigger 1");
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
