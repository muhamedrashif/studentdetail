import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final validator;
  final  suffixIcon;
final maxLength;
  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      this.validator,
      this.suffixIcon,
      this.maxLength
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,suffixIcon: suffixIcon,
          border: inputBorder,
          focusedBorder: inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(10)),
      keyboardType: textInputType,
      obscureText: isPass,
      validator: validator,
      maxLength: maxLength,
      
    );
  }
}
