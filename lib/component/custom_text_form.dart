import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController myController;
  final String? Function(String?)? validator;
  final border;
  final style;
  final  styleText;
  const CustomTextForm(
      {super.key,
      required this.hintText,
      required this.myController,
      this.validator,
      this.border,
      this.style, this.styleText,});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlignVertical: TextAlignVertical.top,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        style: styleText,
        validator: validator,
        controller: myController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: style,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          border: border,
        ));
  }
}
