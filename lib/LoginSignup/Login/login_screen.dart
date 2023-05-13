import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/home_screen.dart';
import 'package:scisco/HomePage/my_orders_detail.dart';
import 'package:scisco/LoginSignup/Login/forgetpass_screen.dart';
import 'package:scisco/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/components/already_have_an_account_acheck.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/kyc/ConsumerKYC.dart';
import 'package:scisco/kyc/DealerKYC.dart';
import 'package:scisco/kyc/HospitalKYC.dart';
import 'package:scisco/kyc/PathologyKYC.dart';
import 'package:scisco/models/LoginRespoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../../navigation_home_screen.dart';
import 'components/background.dart';
import 'components/body.dart';

class LoginScreen extends StatefulWidget {
  List<String> selectedProducts = new List();

  LoginScreen({
    Key key,
    this.selectedProducts,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(selectedProducts);
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> selectedProducts = new List();

  final _emailAddressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _passwordVisible = false;
  _LoginScreenState(this.selectedProducts);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                  inputFormatters: [
                    // new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,;={}()<>]')),
                  ],
                  controller: _passwordCtrl,
                  obscureText: !_passwordVisible,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                      child: Text(
                        'Forgot password',
                        style: TextStyle(fontFamily: AppTheme.fontName),
                        textAlign: TextAlign.right,
                      ),
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ForgetPassword();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "LOGIN",
                color: AppTheme.appColor,
                press: () {
                  if (_emailAddressCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Email Id");
                  } else if (!validateEmail(
                      _emailAddressCtrl.text.toString())) {
                    _showMyDialog(context, "Please Enter Valid email Id");
                  } else if (_passwordCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Password");
                  } else {
                    loginreq();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        print(selectedProducts);
                        return SignUpScreen(
                          selectedProducts: selectedProducts,
                        );
                      },
                    ),
                  );
                },
              ),
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

  Future<Response> loginreq() async {
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
        if (selectedProducts == null) {
          selectedProducts = new List();
        }
        var body = json.encode({
          "email": _emailAddressCtrl.text.toString(),
          "password": _passwordCtrl.text.toString(),
          "product_id": selectedProducts,
        });
        print(body.toString());
        Response response = await baseApi.dio.post(loginSubUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var loginrespo = LoginRespoModel.fromJson(parsed);

          if (loginrespo.error == "1") {
            progressDialog.dismiss();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(SharedPrefKey.ISLOGEDIN, true);
            prefs.setBool(SharedPrefKey.ISKYCDONE, loginrespo.kyc == "1");
            prefs.setString(SharedPrefKey.USERID, loginrespo.user_id);
            prefs.setString(SharedPrefKey.FIRSTNAME, loginrespo.name);
            prefs.setString(SharedPrefKey.LASTNAME, loginrespo.name);
            prefs.setString(SharedPrefKey.CATEGORIES, loginrespo.category);
            prefs.setString(SharedPrefKey.WHATSAPP, loginrespo.whatsapp);
            prefs.setString(SharedPrefKey.EMAILID, loginrespo.email);
            prefs.setString(SharedPrefKey.MOBILENO, loginrespo.mobile);
            setState(() {
/*              if(prefs.getBool(SharedPrefKey.ISLOGEDIN) != null) {
                String category = prefs.getString(SharedPrefKey.CATEGORIES);
                if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Dealer") {
                  print("category");
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new DealerKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Hospital") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new HospitalKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Pathology") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new PathologyKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Consumer") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new ConsumerKYC()));
                  });
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => new NavigationHomeScreen()));
                }
              } else {*/
              if (loginrespo.order_id.isNotEmpty) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => new MyOrdersDetail(
                              orderId: loginrespo.order_id,
                            )),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new NavigationHomeScreen()),
                    (route) => false);
              }
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
