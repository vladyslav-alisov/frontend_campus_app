import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampusTextInputField extends StatefulWidget {
  CampusTextInputField({
    @required this.controller,
    @required this.focus,
    @required this.hintText,
    this.validatorErrorMsg,
    this.leftIcon,
    this.rightIcon,
    this.textInputType,
    this.maxLines,
    this.onChangeString,
    this.isDisable = true,
    this.prefixText,
    this.labelText,
    this.suffixText,
  });

  final String validatorErrorMsg;
  final bool isDisable;
  final int maxLines;
  String onChangeString;
  final TextEditingController controller;
  final FocusNode focus;
  final String hintText;
  final Icon leftIcon;
  final IconButton rightIcon;
  final TextInputType textInputType;
  final String prefixText;
  final String labelText;
  final String suffixText;

  @override
  _CampusTextInputFieldState createState() => _CampusTextInputFieldState();
}

class _CampusTextInputFieldState extends State<CampusTextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          widget.onChangeString = value;
        });
      },
      textInputAction: TextInputAction.done,
      keyboardType: widget.textInputType,
      validator: (String str) {
        if (str == null || str.isEmpty) {
          return widget.validatorErrorMsg;
        }
        return null;
      },
      controller: widget.controller,
      focusNode: widget.focus,
      maxLines: widget.maxLines ?? 1,
      style: TextStyle(
        fontSize: 16
      ),
      decoration: InputDecoration(
        prefixStyle: TextStyle(color: Colors.black),
        enabled: widget.isDisable,
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixText: widget.prefixText,
        suffixIcon: widget.rightIcon,
        prefixIcon: widget.leftIcon,
        hintText: widget.hintText,
        suffixText: widget.suffixText,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        fillColor: Colors.black,
        focusColor: Colors.black,
        hoverColor: Colors.black,
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(
            color: Color(0xffE1E1E1),
          ),
        ),
      ),
    );
  }
}
