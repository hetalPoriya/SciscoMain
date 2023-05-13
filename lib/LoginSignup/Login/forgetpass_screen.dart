import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/home_screen.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/components/already_have_an_account_acheck.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/LoginRespoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../../navigation_home_screen.dart';
import 'components/background.dart';
import 'components/body.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailAddressCtrl = TextEditingController();
  final _verifyCtrl = TextEditingController();
  final _password = TextEditingController();
  var showemail = true;
  var showVerify = false;
  var isVerified = false;
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Forgot password'),
        backgroundColor: AppTheme.appColor,
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /* Text(
                "Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: size.height * 0.03),*/
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
              Visibility(
                visible: showemail,
                child: Column(
                  children: [
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
                    RoundedButton(
                      text: "SUBMIT",
                      color: AppTheme.appColor,
                      press: () {
                        if (_emailAddressCtrl.text.toString().isEmpty) {
                          _showMyDialog(context, "Please Enter Email Id");
                        } else if (!validateEmail(
                            _emailAddressCtrl.text.toString())) {
                          _showMyDialog(context, "Please Enter Valid email Id");
                        } else {
                          forgot_driver_password();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isVerified,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        'Generate New Password',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppTheme.fontName),
                      ),
                    ),
                    TextFieldContainer(
                      child: TextField(
                        controller: _password,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppTheme.nearlyBlack,
                        decoration: InputDecoration(
                          hintText: "Enter new password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    RoundedButton(
                      text: "GENERATE",
                      color: AppTheme.appColor,
                      press: () {
                        if (_emailAddressCtrl.text.toString().isEmpty) {
                          _showMyDialog(context, "Please enter password");
                        } else {
                          changePassword();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),
              /*  AlreadyHaveAnAccountCheck(
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
              ),*/
            ],
          ),
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

  @override
  void initState() {
    _passwordVisible = false;
  }

  Future<Response> forgot_driver_password() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "email": _emailAddressCtrl.text.toString(),
          // "password": _passwordCtrl.text.toString(),
        });
        Response response =
            await baseApi.dio.post(forgotpasswordURL, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var loginrespo = CommonRespoModel.fromJson(parsed);

          if (loginrespo.error == "1") {
            progressDialog.dismiss();

            setState(() {
              // showemail =false;
              // showVerify = true;
              // isVerified = false;
              _showMyDialog(context, loginrespo.error_msg);
            });
          } else {
            progressDialog.dismiss();

            String error_msg = loginrespo.error_msg;
            _showMyDialog(context, error_msg);
          }
        }

        // return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        // displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> driver_forgot_emailotp_check() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "email_id": _emailAddressCtrl.text.toString(),
          "reg_otp": _verifyCtrl.text.toString(),
        });
        Response response =
            await baseApi.dio.post(checkforgotpassUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var loginrespo = CommonRespoModel.fromJson(parsed);

          if (loginrespo.error == "1") {
            progressDialog.dismiss();

            setState(() {
              showemail = false;
              showVerify = false;
              isVerified = true;

              // _showMyDialog(context, loginrespo.error_msg);
            });
          } else {
            progressDialog.dismiss();

            String error_msg = loginrespo.error_msg;
            _showMyDialog(context, error_msg);
          }
        }

        // return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        // displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> changePassword() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "email_id": _emailAddressCtrl.text.toString(),
          "new_password": _password.text.toString(),
        });
        Response response = await baseApi.dio.post(changePassUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var loginrespo = CommonRespoModel.fromJson(parsed);

          if (loginrespo.error == "1") {
            progressDialog.dismiss();

            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new LoginScreen()),
                  ModalRoute.withName('/'));
              // _showMyDialog(context, loginrespo.error_msg);
            });
          } else {
            progressDialog.dismiss();

            String error_msg = loginrespo.error_msg;
            _showMyDialog(context, error_msg);
          }
        }

        // return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        // displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }
}
