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
  // ignore: library_private_types_in_public_api
  _TextDialogInputState createState() => _TextDialogInputState();
}

class _TextDialogInputState extends State<TextDialogInput> {
  @override
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