import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserType { Cook, Lecturer, Student }

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<UserProvider>(context, listen: false).profile(), context).then((_) {
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
    await Provider.of<UserProvider>(context, listen: false).profile().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    final devSize = MediaQuery.of(context).size;
    var userData = Provider.of<UserProvider>(context, listen: false).user;
    var authData = Provider.of<AuthProvider>(context, listen: false).authData;

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
                            .then((value) => auth.exitApp());
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
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: 88,
                            height: 88,
                            child: authData.login.imageUrl != str_noImage && authData?.login?.imageUrl != null
                                ? CircleAvatar(
                                    child: Container(
                                      child: ClipOval(
                                        child: Image.network(
                                          authData.login.imageUrl,
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
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData != null ? "${userData.profile.name} ${userData.profile.surname}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 24),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData != null ? "${userData.profile.department}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData != null ? "${userData.profile.email}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData != null ? "${userData.profile.userID}" : "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                            child: Text(
                              userData != null ? "${userData.profile.address}" : "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                  authData.login.typeOfUser != describeEnum(UserType.Student)
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
}
