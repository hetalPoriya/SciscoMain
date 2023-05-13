import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco/components/already_have_an_account_acheck.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/rounded_input_field.dart';
import 'package:scisco/components/rounded_password_field.dart';
import 'package:scisco/components/text_field_container.dart';

import '../../../app_theme.dart';
import '../../../navigation_home_screen.dart';
import 'background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _emailAddressCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: size.height * 0.03),
            /*SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),*/

            Image.asset(
              "assets/images/glasmic.png",
              fit: BoxFit.contain,
              height: 100,
              width: 200,
              alignment: Alignment.center,
            ),
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
              child: TextField(
                controller: _emailAddressCtrl,
                keyboardType: TextInputType.emailAddress,
                cursorColor: AppTheme.nearlyBlack,
                decoration: InputDecoration(
                  hintText: "Your Email Id",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              child: TextField(
                controller: _passwordCtrl,
                obscureText: true,
                cursorColor: AppTheme.nearlyBlack,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: AppTheme.nearlyBlack,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              color: AppTheme.appColor,
              press: () {
                if (_emailAddressCtrl.text.toString().isEmpty) {
                  _showMyDialog(context, "Please Enter Email Id");
                } else if (_passwordCtrl.text.toString().isEmpty) {
                  _showMyDialog(context, "Please Enter Password");
                }

                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return NavigationHomeScreen();
                    },
                  ),
                );*/
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMyDialog(
    BuildContext context,
    String msg,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Error"),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(msg),
            ),
            actions: <Widget>[
              /*CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),*/
              CupertinoDialogAction(
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.remove('isLogin');
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (BuildContext ctx) => Login()));
                  },
                  child: Text(
                    "Okay",
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        color: AppTheme.buttoncolor),
                  )),
            ],
          );
        });
  }
}
