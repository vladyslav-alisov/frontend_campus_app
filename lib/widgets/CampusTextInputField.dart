import 'package:flutter/material.dart';

class CampusTextInputField extends StatelessWidget {
  const CampusTextInputField({
    @required this.controller,
    @required this.focus,
    @required this.validator,
    @required this.hintText,
    this.leftIcon,
    this.rightIcon,
    this.textInputType,
    this.maxLines,
  }) ;

  final int maxLines;
  final TextEditingController controller;
  final FocusNode focus;
  final Function validator;
  final String hintText;
  final Icon leftIcon;
  final IconButton rightIcon;
  final TextInputType textInputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      keyboardType: textInputType,
      validator: validator,
      controller: controller,
      focusNode: focus,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        suffixIcon: rightIcon,
        prefixIcon: leftIcon,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Color(0xffE1E1E1),
          ),
        ),
      ),
    );
  }
}