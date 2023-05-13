import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/components/rounded_button.dart';

import 'background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Image.asset(
              "assets/images/glasmic.png",
              fit: BoxFit.contain,
              height: 100,
              width: 250,
              alignment: Alignment.center,
            )),
            SizedBox(height: size.height * 0.05),
            /*SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),*/
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              color: AppTheme.appColor,
              text: "Login",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "Sign Up",
              color: AppTheme.chipBackground,
              textColor: Colors.black,
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
}
