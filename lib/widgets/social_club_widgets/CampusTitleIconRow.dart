import 'package:flutter/material.dart';

class CampusTitleIconRow extends StatelessWidget {
  CampusTitleIconRow(
      {this.titleIcon, this.title, this.trailingIcon, this.secondTrailingIcon, this.callback, this.secondCallback});

  final IconData titleIcon;
  final IconData trailingIcon;
  final IconData secondTrailingIcon;
  final String title;
  final Function callback;
  final Function secondCallback;

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
              title ?? "",
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13),
            ),
          ],
        ),
        Row(
          children: [
            secondTrailingIcon == null
                ? Container()
                : IconButton(
                    icon: Icon(
                      secondTrailingIcon,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: secondCallback,
                  ),
            trailingIcon == null
                ? Container()
                : IconButton(
              icon: Icon(
                trailingIcon,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: callback,
            ),
          ],
        ),
      ],
    );
  }
}
