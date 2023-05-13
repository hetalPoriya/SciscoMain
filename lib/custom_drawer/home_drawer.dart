import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class HomeDrawer extends StatefulWidget {

  const HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  SharedPreferences prefs;
  var profileImage;
  var driverName;
  var driverEmail;
  var driverMob;
  static String driverNameHome;

  @override
  void initState() {
    setDrawerListArray();
    super.initState();
    initWidgetsValues();

  }

  // void changeValues(String name){
  //   driverName = name;
  // }
  Future<void> initWidgetsValues() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      profileImage = prefs.getString(SharedPrefKey.PROFILEPIC);
      driverName = prefs.getString(SharedPrefKey.FIRSTNAME);
      driverEmail = prefs.getString(SharedPrefKey.EMAILID);
      driverMob = prefs.getString(SharedPrefKey.MOBILENO);
    });
  }


  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.MyProfile,
        labelName: 'My Profile',
        icon: Icon(Icons.supervised_user_circle),
      ),
      DrawerList(
        index: DrawerIndex.MyKyc,
        labelName: 'My KYC',
        icon: Icon(Icons.done),
      ),
      DrawerList(
        index: DrawerIndex.MyQuotes,
        labelName: 'Order History',
        icon: Icon(Icons.credit_card),
      ),
      DrawerList(
        index: DrawerIndex.BankDetails,
        labelName: 'My Quotes',
        icon: Icon(Icons.credit_card),
      ),
     /* DrawerList(
        index: DrawerIndex.VehicleDetails,
        labelName: 'Vehicle Details',
        icon: Icon(Icons.directions_car),
      ),*/
      // DrawerList(
      //   index: DrawerIndex.Earning,
      //   labelName: 'Earnings',
      //   icon: Icon(Icons.attach_money),
      // ),
      DrawerList(
        index: DrawerIndex.HELP,
        labelName: 'Support',
        icon: Icon(Icons.help_outline),
      ),
    ];

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key:UniqueKey(),
      drawerEdgeDragWidth:0.0,

      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        key:UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            key:UniqueKey(),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              key:UniqueKey(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                key:UniqueKey(),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                /*  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(parent: widget.iconAnimationController, curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            key:UniqueKey(),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                              child:  Container(
                                  width: size.width / 8,
                                  height: size.height / 8,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(profileImage!=null?profileImage:"https://library.kissclipart.com/20180901/krw/kissclipart-user-thumbnail-clipart-user-lorem-ipsum-is-simply-bfcb758bf53bea22.jpg")))),
                              // Image.asset('assets/images/userImage.png'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),*/
                  Padding(
                    key:UniqueKey(),
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      driverName!=null?driverName:"Welcome Guest",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4),
                    child: Text(
                      driverEmail!=null?driverEmail:"",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.darkerText,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4),
                    child: Text(
                      driverMob!=null?driverMob:"",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.darkerText,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),

          prefs!=null?prefs.getString(SharedPrefKey.USERID)!=null?
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () async {


                _logoutDialog();



                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ):Wrap():Wrap(),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon, color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Colors.blue : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  Future<void> _logoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure? you want to logout'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();

                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove(SharedPrefKey.USERID);
                prefs.remove(SharedPrefKey.MOBILENO);
                prefs.remove(SharedPrefKey.EMAILID);
                prefs.remove(SharedPrefKey.FIRSTNAME);
                prefs.remove(SharedPrefKey.LASTNAME);
                prefs.remove(SharedPrefKey.ISLOGEDIN);
                prefs.remove(SharedPrefKey.CATEGORIES);
                prefs.remove(SharedPrefKey.ISKYCDONE);
                prefs.remove(SharedPrefKey.WHATSAPP);
                prefs.remove(SharedPrefKey.SELECTEDPRODUCTS);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}

enum DrawerIndex {
  HOME,
  BankDetails,
  MyProfile,
  MyKyc,
  MyQuotes,
  Earning,
  HELP,
  VehicleDetails,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
