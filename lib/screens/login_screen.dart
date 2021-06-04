import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusLoginTextInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserType { Student, Staff }

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    emailController.text = "";
    passwordController.text = "";
    rightTextController.text = "@std.antalya.edu.tr";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController rightTextController = new TextEditingController();
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  FocusNode loginButtonFocus = new FocusNode();

  bool _obscure = true;
  bool _isLoading = false;
  int _selected = 0;

  void seePassword() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userSilent = Provider.of<AuthProvider>(context, listen: false);
    var devSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: devSize.height * 0.4,
              width: devSize.width,
              child: Image.asset(
                ConstAssetsPath.img_loginImage,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    disabledColor: Colors.grey,
                    selectedColor: Theme.of(context).primaryColor,
                    label: Text(
                      describeEnum(UserType.Student),
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _selected == UserType.Student.index,
                    onSelected: (value) {
                      setState(
                        () {
                          _selected = UserType.Student.index;
                          rightTextController.text = "@std.antalya.edu.tr";
                        },
                      );
                    },
                  ),
                  ChoiceChip(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    disabledColor: Colors.grey,
                    selectedColor: Theme.of(context).primaryColor,
                    label: Text(
                      describeEnum(UserType.Staff),
                      style: TextStyle(color:Colors.white),
                    ),
                    selected: _selected == UserType.Staff.index,
                    onSelected: (value) {
                      setState(
                        () {
                          _selected = UserType.Staff.index;
                          rightTextController.text = "@antalya.edu.tr";
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            Center(
              child: Container(
                width: devSize.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CampusLoginTextInputField(
                        controller: emailController,
                        autofocus: true,
                        focus: emailFocus,
                        rightText: rightTextController.text,
                        onFieldSubmitted: (String value) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        textInputType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(str_pleaseEnterYourEmail);
                          }
                          return null;
                        },
                        hintText: AppLocalizations.of(context).translate(str_email),
                        leftIcon: Icon(
                          Icons.person,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CampusLoginTextInputField(
                        obscure: _obscure,
                        rightIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _obscure ? Colors.grey : Theme.of(context).primaryColor,
                          ),
                          onPressed: seePassword,
                        ),
                        leftIcon: Icon(
                          Icons.lock,
                        ),
                        controller: passwordController,
                        focus: passwordFocus,
                        onFieldSubmitted: (String value) => FocusScope.of(context).requestFocus(loginButtonFocus),
                        hintText: AppLocalizations.of(context).translate(str_password),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(str_pleaseEnterYourPassword);
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(context).translate(str_yourPasswordWarningCharacters);
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              width: devSize.width * 0.4,
                              height: devSize.height * 0.06,
                              child: FractionallySizedBox(
                                widthFactor: 10 / 12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextButton(
                                    focusNode: loginButtonFocus,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setIsLoading(true);
                                        await userSilent
                                            .auth(emailController.text+rightTextController.text, passwordController.text)
                                            .then((value) {
                                          setIsLoading(false);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);
                                        }).catchError(
                                          (e) {
                                            setIsLoading(false);
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
                                          },
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context).translate(str_signIn),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }
}
