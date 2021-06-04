import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampusLoginTextInputField extends StatelessWidget {
  const CampusLoginTextInputField({
    @required this.controller,
    @required this.focus,
    @required this.validator,
    @required this.hintText,
    @required this.leftIcon,
    this.autofocus=false,
    this.obscure = false,
    this.rightIcon,
    this.textInputType,
    this.onFieldSubmitted, this.rightText,
  });

  final bool autofocus;
  final TextEditingController controller;
  final FocusNode focus;
  final Function validator;
  final String hintText;
  final Icon leftIcon;
  final bool obscure;
  final IconButton rightIcon;
  final TextInputType textInputType;
  final Function onFieldSubmitted;
  final String rightText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      autofocus: autofocus,
    textInputAction: TextInputAction.done,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscure,
      controller: controller,
      focusNode: focus,
      style: TextStyle(
        fontSize: 13
      ),
      decoration: InputDecoration(
        suffixIcon: rightIcon,
        suffixText: rightText,
        prefixIcon: leftIcon,
        hintText: hintText,
        suffixStyle: TextStyle(
          fontSize: 13
        ),
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