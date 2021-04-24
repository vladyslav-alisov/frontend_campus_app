import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Provider.of<UserProvider>(context, listen: false).profile().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            label: AppLocalizations.of(context).translate(str_hideMessage),
            textColor: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          content: Text(e.toString()),
        ),
      );
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
    var auth = Provider.of<AuthProvider>(context,listen: false);
    final devSize = MediaQuery.of(context).size;
    var userData = Provider.of<UserProvider>(context, listen: false).user;
    var authData = Provider.of<AuthProvider>(context, listen: false).authData;
    return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                74,
              ),
              child: CapmusAppBar(
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

                              await Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false).then((value) => auth.exitApp());
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
                    child: Container(
                      height: devSize.height * 0.6,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                width: 88,
                                height: 88,
                                child: authData.login.imageUrl != str_noImage
                                    //todo make circular avatar
                                    ? Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            onError: (exception, stackTrace) {
                                              print(exception);
                                            },
                                            image: NetworkImage(authData.login.imageUrl),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 88,
                                        height: 88,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: CircleAvatar(
                                          child: ClipOval(
                                            child: Image.asset(ConstAssetsPath.img_defaultAvatar, fit: BoxFit.fill),
                                          ),
                                          radius: devSize == null ? 50 : devSize.width * 0.10,
                                        ),
                                      ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                userData != null ? "${userData.profile.name} ${userData.profile.surname}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 24),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                userData != null ? "${userData.profile.department}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                userData != null ? "${userData.profile.email}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                userData != null ? "${userData.profile.userID}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                userData != null ? "${userData.profile.address}" : "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 25,
                      left: 14,
                      right: 14,
                    ),
                    child: Container(
                      height: devSize.height * 0.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 63, right: 40),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 58.0,
                                ),
                                child: Image(
                                  height: 85,
                                  width: 85,
                                  image: AssetImage(
                                    ConstAssetsPath.img_studentCard,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 79, left: 18),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
