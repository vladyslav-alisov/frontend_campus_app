import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CampusPersonListTile extends StatelessWidget {
  CampusPersonListTile({this.imageUrl, this.name, this.surname,this.trailingIcon,this.callback});

  final String imageUrl;
  final String name;
  final String surname;
  final Icon trailingIcon;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: imageUrl != str_noImage && imageUrl != null
          ? Container(
              width: 50,
              height: 50,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        "${name[0].toUpperCase()}${surname[0].toUpperCase()}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  "${name[0].toUpperCase()}${surname[0].toUpperCase()}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
      title: Text("$name $surname"),
      trailing: trailingIcon == null ? null : IconButton(
        icon: trailingIcon,
        onPressed: () => callback(),
      ),
    );
  }
}
