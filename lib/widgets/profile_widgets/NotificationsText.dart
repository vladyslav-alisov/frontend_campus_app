import 'package:flutter/material.dart';

class NotationsText extends StatelessWidget {
  NotationsText({
    @required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13, color: Colors.grey.shade300),
    );
  }
}