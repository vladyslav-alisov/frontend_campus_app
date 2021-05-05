import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusLoginTextInputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    emailController.text = "vlad@std.antalya.edu.tr";
    passwordController.text = "vladyslav";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  FocusNode emailFocus = new FocusNode();
  FocusNode passwordFocus = new FocusNode();
  FocusNode loginButtonFocus = new FocusNode();

  bool _obscure = true;
  bool _isLoading = false;

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
          children: [
            Container(
              height: devSize.height * 0.4,
              width: devSize.width,
              child: Image.asset(
                ConstAssetsPath.img_loginImage,
                fit: BoxFit.fill,
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
                        onFieldSubmitted: (String value){
                          FocusScope.of(context).requestFocus(passwordFocus);
                        } ,
                        textInputType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).translate(str_pleaseEnterYourEmail);
                          }
                          if (!value.toLowerCase().contains('@') || !value.toLowerCase().contains('antalya.edu.tr')) {
                            return AppLocalizations.of(context).translate(str_pleaseEnterValidEmail);
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
                        onFieldSubmitted: (String value)=> FocusScope.of(context).requestFocus(loginButtonFocus),
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
                                            .auth(emailController.text, passwordController.text)
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
