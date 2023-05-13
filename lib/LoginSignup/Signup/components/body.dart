import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/LoginSignup/Signup/components/social_icon.dart';
import 'package:scisco/components/already_have_an_account_acheck.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/rounded_input_field.dart';
import 'package:scisco/components/rounded_password_field.dart';

import 'background.dart';
import 'or_divider.dart';

class Body extends StatelessWidget {

  StepperType stepperType = StepperType.horizontal;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return

      Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*  Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),*/
            SizedBox(height: size.height * 0.03),
            /* SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),*/

            Image.asset(
              "assets/images/logotwo.png",
              fit: BoxFit.contain,
              height: 200,
              width: 300,
              alignment: Alignment.center,
            ),
            RoundedInputField(
              boardType: TextInputType.text,
              hintText: "First Name",
              icon: Icons.account_circle,
              onChanged: (value) {},
            ),
            RoundedInputField(
              boardType: TextInputType.text,
              icon: Icons.account_circle,
              hintText: "Last Name",
              onChanged: (value) {},
            ),
            RoundedInputField(
              boardType: TextInputType.number,
        //      formater: WhitelistingTextInputFormatter.digitsOnly,
              icon: Icons.phone_iphone,
              hintText: "Mobile Number",
              onChanged: (value) {},
            ),
            RoundedInputField(
              boardType: TextInputType.emailAddress,

              icon: Icons.alternate_email,
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "Sign Up",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
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
/*
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )*/
          ],
        ),
      ),
    );
  }
}
