import 'package:flutter/material.dart';

class TitleIconRow extends StatelessWidget {
  TitleIconRow({this.titleIcon, this.title, this.trailingIcon, this.callback});

  final IconData titleIcon;
  final IconData trailingIcon;
  final String title;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              titleIcon,
              size: 15,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),
            ),
          ],
        ),
        trailingIcon==null? Container() :IconButton(
          icon: Icon(trailingIcon,size: 20,color: Colors.grey,),
          onPressed: callback,
        ),
      ],
    );
  }
}