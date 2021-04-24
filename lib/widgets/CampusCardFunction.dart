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
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        color: color,
                        fontSize: 18,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
