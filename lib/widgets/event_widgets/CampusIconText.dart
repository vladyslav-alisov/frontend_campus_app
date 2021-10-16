import 'package:flutter/material.dart';

class CampusIconText extends StatelessWidget {
  const CampusIconText({
    this.icon,
    this.textData,
    this.title,
  });

  final IconData icon;
  final String title;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  icon,
                  size: 15,
                ),
              ),
              Text(""),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      textData,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}