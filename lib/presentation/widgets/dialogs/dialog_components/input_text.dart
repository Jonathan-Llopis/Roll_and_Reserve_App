import 'package:flutter/material.dart';


class TextDialogInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const TextDialogInput({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  State<TextDialogInput> createState() => _TextDialogInputState();
}

class _TextDialogInputState extends State<TextDialogInput> {
  @override
/// Builds a text input field with a label and an outlined border.
/// 
/// The text field uses the [widget.controller] to manage its input 
/// and displays the [widget.labelText] as the label. The border of 
/// the text field is styled with rounded corners.

  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}