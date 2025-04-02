import 'package:flutter/material.dart';
import 'package:roll_and_reserve/presentation/functions/controller_rive_animation.dart';


class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final Function validator;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FocusNode focusNode;
  final RiveAnimationController? riveController;
  final IconButton? sufixIconButton;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.validator,
    this.obscureText = false,
    required this.onChanged,
    required this.focusNode,
    required this.riveController,
     this.sufixIconButton,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final bool _passwordVisible = true;

  @override
/// Builds a customizable text form field widget.
///
/// The form field uses the provided [focusNode], [controller], [icon], 
/// [labelText], and optional [sufixIconButton] for its input decoration. 
/// It supports password visibility toggle based on the [obscureText] flag 
/// and [onChanged] callback for input changes. The [validator] function 
/// is used for input validation.

  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      obscureText: widget.obscureText ? _passwordVisible : false,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: widget.sufixIconButton
      ),
      onChanged: widget.onChanged,
      validator: (value) => widget.validator(value),
    );
  }
}
