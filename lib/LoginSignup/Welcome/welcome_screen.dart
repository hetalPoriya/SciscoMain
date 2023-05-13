import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/kyc/ConsumerKYC.dart';
import 'package:scisco/kyc/DealerKYC.dart';
import 'package:scisco/kyc/HospitalKYC.dart';
import 'package:scisco/kyc/PathologyKYC.dart';
import 'package:scisco/navigation_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/body.dart';
import 'package:in_app_update/in_app_update.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  AppUpdateInfo _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => showSnack(e.toString()));
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
// Here you can write your code

          doSomeAsyncStuff();
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 3000), () {
        doSomeAsyncStuff();
      });
    }
  }

  Future<void> doSomeAsyncStuff() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    /*if(prefs.getBool(SharedPrefKey.ISLOGEDIN)!=null){
      if(prefs.getBool(SharedPrefKey.ISLOGEDIN)){
        setState(() {

          Timer.run(() {
            redirectTo();
          });

        });
      }else{

      }

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NavigationHomeScreen();
          },
        ),
      );
    }*/

    redirectTo();
  }

  void redirectTo() {
    /*    if(prefs.getBool(SharedPrefKey.ISLOGEDIN) != null) {
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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new NavigationHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            // color: Colors.red,

            child: Image.asset(
              "assets/images/glasmic.png",
              height: 220.0,
              width: 220.0,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
