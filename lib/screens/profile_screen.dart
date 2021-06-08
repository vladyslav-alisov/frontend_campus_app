import 'dart:io';

import 'package:campus_app/models/User.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

enum UserType { Cook, Lecturer, Student }

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isImageLoading = false;
  var picker = ImagePicker();
  File avatarImage;

  void setIsLoading() {
    setState(() {
      _isImageLoading = !_isImageLoading;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<ProfileProvider>(context, listen: false).profile(), context).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> _refreshProfileData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ProfileProvider>(context, listen: false).profile().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<ProfileProvider>(context, listen: false).user;
    var authData = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          74,
        ),
        child: CampusAppBar(
          actionWidget: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate(str_logout),
                  ),
                  content: Text(
                    AppLocalizations.of(context).translate(str_warningBeforeLogOut),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context).translate(str_cancel),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false)
                            .then((value) => authData.exitApp());
                      },
                      child: Text(
                        AppLocalizations.of(context).translate(str_logout),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          title: AppLocalizations.of(context).translate(str_profile),
        ),
      ),
      body: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProfileData(context),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14,
                      bottom: 14,
                      left: 14,
                      right: 14,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Column(
                        children: [
                          Hero(
                            tag: "profileAvatar",
                            child: _isImageLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: 88,
                                    height: 88,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (authData.authData.login.imageUrl == str_defaultImageUrl) {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Wrap(
                                                children: [
                                                  ListTile(
                                                    leading: new Icon(Icons.photo_library),
                                                    title: new Text(
                                                        AppLocalizations.of(context).translate(str_photoLibrary)),
                                                    onTap: () async {
                                                      await getAndUpdateImage(false);
                                                      Navigator.pop(context);
                                                      if (avatarImage != null) {
                                                        setIsLoading();
                                                        await authData.uploadAvatar(avatarImage);
                                                        setIsLoading();
                                                      }
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: new Icon(Icons.photo_camera),
                                                    title: new Text(AppLocalizations.of(context).translate(str_camera)),
                                                    onTap: () async {
                                                      await getAndUpdateImage(true);
                                                      Navigator.pop(context);
                                                      if (avatarImage != null) {
                                                        setIsLoading();
                                                        await authData.uploadAvatar(avatarImage);
                                                        setIsLoading();
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CampusGallerySinglePhoto(),
                                            ),
                                          );
                                      },
                                      child: authData.authData.login.imageUrl != str_noImage &&
                                              authData.authData.login.imageUrl != null
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                child: ClipOval(
                                                  child: Image.network(
                                                    authData.authData.login.imageUrl,
                                                    height: 88,
                                                    width: 88,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) =>
                                                        Image.asset(ConstAssetsPath.img_defaultAvatar),
                                                  ),
                                                ),
                                              ),
                                              radius: 25,
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        ConstAssetsPath.img_defaultAvatar,
                                                      ))),
                                            ),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Text(
                            "Name",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.name} ${userData.profile.surname}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 24),
                            ),
                          ),
                          Text(
                            "Department",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.department}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Text(
                            "Email",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.email}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Text(
                            "Student ID",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.userID}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Text(
                            "Address",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.address}" : "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Text(
                            "Mobile number",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 13,color: Colors.grey.shade300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 15),
                            child: Text(
                              userData != null ? "${userData.profile.phone}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  authData.authData.login.typeOfUser != describeEnum(UserType.Student)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Center(
                                        child: Image(
                                          height: 85,
                                          width: 85,
                                          image: AssetImage(
                                            ConstAssetsPath.img_studentCard,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                AppLocalizations.of(context).translate(str_studentCardBalance) ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                userData != null ? "TL: ${userData.profile.balance}" : "",
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Future getAndUpdateImage(bool choice) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    } else if (!choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    }
    if (pickedFile != null) {
      avatarImage = File(pickedFile.path);
    }
  }
}

class CampusGallerySinglePhoto extends StatefulWidget {
  @override
  _CampusGallerySinglePhotoState createState() => _CampusGallerySinglePhotoState();
}

class _CampusGallerySinglePhotoState extends State<CampusGallerySinglePhoto> {
  var picker = ImagePicker();
  File avatarImage;
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<AuthProvider>(context);
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        body: isLoading
            ? Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
            : Stack(
                fit: StackFit.expand,
                children: [
                  PhotoView.customChild(
                    heroAttributes: PhotoViewHeroAttributes(tag: "profileAvatar"),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage(ConstAssetsPath.img_defaultAvatar),
                      image: NetworkImage(userProvider.authData.login.imageUrl),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                userProvider.authData.login.imageUrl == str_defaultImageUrl
                                    ? Container()
                                    : ListTile(
                                        leading: new Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        title: new Text(
                                          AppLocalizations.of(context).translate(str_delete),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                                content: new Text("Are you sure you want to delete avatar?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_confirm)),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      setIsLoading();
                                                      await userProvider.deleteAvatar();
                                                      setIsLoading();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text(AppLocalizations.of(context).translate(str_photoLibrary)),
                                  onTap: () async {
                                    await getAndUpdateImage(false);
                                    Navigator.pop(context);
                                    if (avatarImage != null) {
                                      setIsLoading();
                                      await userProvider.uploadAvatar(avatarImage);
                                      setIsLoading();
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text(AppLocalizations.of(context).translate(str_camera)),
                                  onTap: () async {
                                    await getAndUpdateImage(true);
                                    Navigator.pop(context);
                                    if (avatarImage != null) {
                                      setIsLoading();
                                      await userProvider.uploadAvatar(avatarImage);
                                      setIsLoading();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListTile(
                                  leading: new Icon(Icons.cancel),
                                  title: new Text(AppLocalizations.of(context).translate(str_cancel)),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  )
                ],
              ),
      ),
    );
  }

  Future getAndUpdateImage(bool choice) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    } else if (!choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    }
    if (pickedFile != null) {
      avatarImage = File(pickedFile.path);
    }
  }
}
