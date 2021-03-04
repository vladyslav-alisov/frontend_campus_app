import 'package:flutter/material.dart';

cardFunction({
  @required BuildContext context,
  @required String imagePath,
  @required String label,
  @required Color color,
  @required String path,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, path);
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Colors.black,
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: Image(
              image: AssetImage(imagePath),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text(
              label,
              softWrap: true,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: color,
                    fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}
