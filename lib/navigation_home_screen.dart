import 'package:flutter/material.dart';
import 'package:scisco/HomePage/MyQuoteOrders.dart';
import 'package:scisco/HomePage/TotalEarning.dart';
import 'package:scisco/HomePage/my_orders.dart';
import 'package:scisco/HomePage/mooferProfile.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/kyc/ConsumerKYC.dart';
import 'package:scisco/kyc/DealerKYC.dart';
import 'package:scisco/kyc/HospitalKYC.dart';
import 'package:scisco/kyc/PathologyKYC.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage/Support.dart';
import 'HomePage/edit_profile.dart';
import 'HomePage/home_screen.dart';
import 'HomePage/vehicle_details.dart';
import 'app_theme.dart';
import 'category/cat_page.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  SharedPreferences prefs;
  @override
  void initState()  {
    drawerIndex = DrawerIndex.HOME;
    screenView = CategoryPage();
    initprefs();
    super.initState();
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawerEdgeDragWidth:0.0,
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = CategoryPage();
        });
      } else if (drawerIndex == DrawerIndex.MyProfile) {
        setState(() {
          if (prefs.getString(SharedPrefKey.USERID)!=null) {
            screenView = EditProfile();
          } else {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
        });
      } else if (drawerIndex == DrawerIndex.MyKyc) {
        setState(() {
          if (prefs.getString(SharedPrefKey.USERID)!=null && prefs.getBool(SharedPrefKey.ISLOGEDIN) != null) {
            String category = prefs.getString(SharedPrefKey.CATEGORIES);
            if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Dealer") {
              print("category");
                screenView = DealerKYC();
            } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Hospital") {
                screenView = HospitalKYC();

            } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Pathology") {
                screenView = PathologyKYC();
            } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Consumer") {
                screenView = ConsumerKYC();

            } else {
              screenView = NavigationHomeScreen();
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => new NavigationHomeScreen()));
            }
          } else {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
        });
      }
      else if (drawerIndex == DrawerIndex.MyQuotes) {
        setState(() {
          if(prefs.getString(SharedPrefKey.USERID)!=null) {
            screenView = MyQuoteOrders();
          } else {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
        });
      }
      else if (drawerIndex == DrawerIndex.BankDetails) {
        setState(() {
          if(prefs.getString(SharedPrefKey.USERID)!=null) {
            screenView = MyOrders();
          } else {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
        });
      }
      /*else if (drawerIndex == DrawerIndex.VehicleDetails) {
        setState(() {
          screenView = VehicleDetailsUpdate();
        });
      }else if (drawerIndex == DrawerIndex.Earning) {
        setState(() {
          screenView = TotalEarning();
        });
      }*/else if (drawerIndex == DrawerIndex.HELP) {
        setState(() {
          if(prefs.getString(SharedPrefKey.USERID)!=null) {
            screenView = Support();
          } else {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ),
            );
          }
          // screenView = Support();
        });
      } else {
        //do in your way......
      }
    }
  }
}
