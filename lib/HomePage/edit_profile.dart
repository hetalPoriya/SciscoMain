import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';
import 'package:scisco/models/VechicleTypeDatum.dart';
import 'package:scisco/models/MyProfileModel.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';
import 'package:scisco/models/Place.dart';

import '../navigation_home_screen.dart';
import 'AddressSearch.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<EditProfile> {

  var _imageFile;

  AnimationController animationController;

  ScrollController _controller;
  List<Item> indexList = new List();
  var selectedDate = new DateTime.now();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _mobileNumCtrl = TextEditingController();
  final _emailidCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _subUrbCtrl = TextEditingController();
  final _postCodeCtrl = TextEditingController();
  final _dateOfBirthCtrl = TextEditingController();

  int index = 0;


  String _firstName = "";
  String _lastName = "";
  String _emailAddress = "";
  String _mobileNumber = "";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    getprofileData();

  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return

      Scaffold(
      appBar:
      AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.white,

      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,

        child:Container(
          alignment: Alignment.center,
          child:
          Column(
            children: <Widget>[


              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 25,top: 10),
                child:               Text('Enter Name',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 14,fontWeight: FontWeight.w500),),

              ),
              TextFieldContainer(
                child: TextField(
                  controller: _nameCtrl,
                  keyboardType: TextInputType.text,
                //  inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),],

                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 25,top: 10),
                child:               Text('Enter Mobile Number',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 14,fontWeight: FontWeight.w500),),

              ),
              TextFieldContainer(
                child: TextField(
                  controller: _mobileNumCtrl,
                  keyboardType: TextInputType.number,
               //   inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 25,top: 10),
                child:               Text('Enter Email Id',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 14,fontWeight: FontWeight.w500),),

              ),
              TextFieldContainer(
                child: TextField(
                  controller: _emailidCtrl,
                  enabled: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Your Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 25,top: 10),
                child:               Text('Enter Address',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 14,fontWeight: FontWeight.w500),),

              ),
              TextFieldContainer(
                child: TextField(
                  controller: _addressCtrl,
                  cursorColor: AppTheme.nearlyBlack,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,

                 // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z 0-9]")),],

                  decoration: InputDecoration(
                    hintText: "Address",

                    border: InputBorder.none,
                  ),
                ),
              ),







            ],
          )
        ),

      ),
        bottomNavigationBar:
        Visibility(
        visible: true,
        child: Container(
          alignment: Alignment.center,
          height: size.height * 0.12,
          color: AppTheme.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundedButton(
                color: AppTheme.buttoncolor,
                text: "Update Profile",
                press: () {

                  update_personal_profile();
                },
              ),
            ],
          ),
        )),
    );
  }

  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
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
                textStyle:
                    TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
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
        );});
  }






  Future<Response> getprofileData() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "usre_id": prefs.getString(SharedPrefKey.USERID),

        });
        Response response = await baseApi.dio.post(my_profileURl,data:body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("PROFILERESPOONSE:" + parsed.toString());

          var driverProfile = MyProfileModel.fromJson(parsed);
          progressDialog.dismiss();
          if (driverProfile.error == "1") {


            setState(() {

              _firstName = driverProfile.name;
              _emailAddress = driverProfile.email;
              _mobileNumber = driverProfile.mobile;


              _nameCtrl.text = _firstName;
              _emailidCtrl.text = _emailAddress;
              _mobileNumCtrl.text = _mobileNumber;
              _addressCtrl.text = driverProfile.address;



            });
          } else {

            String error_msg = driverProfile.error_msg;
            displayToast(error_msg.toString(), context);

          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> update_personal_profile() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {

        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "usre_id": prefs.getString(SharedPrefKey.USERID),
          "mobile": _mobileNumCtrl.text.toString(),
          "name":  _nameCtrl.text.toString(),
          "address":  _addressCtrl.text.toString(),

        });
        Response response = await baseApi.dio.post(edit_profileUrl,data:body);
        progressDialog.dismiss();
        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSEPRP:" + parsed.toString());

          var commonRespo = CommonRespoModel.fromJson(parsed);

          if (commonRespo.error == "1") {

            prefs.setString(SharedPrefKey.FIRSTNAME, _nameCtrl.text.toString());
            prefs.setString(SharedPrefKey.EMAILID, _emailidCtrl.text.toString());
            prefs.setString(SharedPrefKey.MOBILENO, _mobileNumCtrl.text.toString());
            prefs.setString(SharedPrefKey.ADDRESS, _addressCtrl.text.toString());

            // var driverName = _firstNameCtrl.text.toString()+ " "+ _lastNameCtrl.text.toString();
            _showSuccessMyDialog(context, commonRespo.error_msg);
          } else {
            String error_msg = commonRespo.error_msg;
            displayToast(error_msg.toString(), context);
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }



  @override
  bool get wantKeepAlive => throw UnimplementedError();
}
typedef void MyCallback(int foo);
void _showSuccessMyDialog(
  BuildContext context,
  String msg,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

    return CupertinoAlertDialog(
        title: Text("Profile Update"),
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
              textStyle:
                  TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
              isDefaultAction: true,
              onPressed: () async {
                Navigator.pop(context);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => NavigationHomeScreen()));

                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // prefs.remove('isLogin');

              },
              child: Text(
                "Okay",
                style: TextStyle(
                    fontFamily: AppTheme.fontName, color: AppTheme.buttoncolor),
              )),
        ],
      );});
}

class HomeItemListView extends StatefulWidget {
  const HomeItemListView({
    Key key,
    this.moveitemDatum,
    this.callBack,
    this.animationController,
    this.animation,
    this.cardselected,
  }) : super(key: key);

  final VechicleEquipmentDatum moveitemDatum;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool cardselected;

  @override
  _HomeItemListViewState createState() => _HomeItemListViewState(
      moveitemDatum: moveitemDatum,
      callBack: callBack,
      animationController: animationController,
      animation: animation,
      cardselected: cardselected);
}

class _HomeItemListViewState extends State<HomeItemListView> {
  _HomeItemListViewState(
      {this.moveitemDatum,
      this.callBack,
      this.animationController,
      this.animation,
      this.cardselected});

  VechicleEquipmentDatum moveitemDatum;
  VoidCallback callBack;
  AnimationController animationController;
  Animation<dynamic> animation;
  bool cardselected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 40 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 4.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Card(
                        shape: widget.cardselected
                            ? new RoundedRectangleBorder(
                                side: new BorderSide(
                                    color: AppTheme.appColor, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0))
                            : new RoundedRectangleBorder(
                                side: new BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0)),

/*
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
*/
                        color: widget.cardselected
                            ? AppTheme.white
                            : AppTheme.white,
                        elevation: 2.0,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.grey.withOpacity(0.2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0)),
                                onTap: () {
                                  widget.callBack();
                                },
                              ),
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                height: size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 5),
                                        child: Row(
                                          children: [
                                            Text(moveitemDatum.name,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: widget.cardselected
                                                        ? AppTheme.darkerText
                                                        : AppTheme.darkerText,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily:
                                                        AppTheme.fontName)),
                                          ],
                                        )),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
// =============================================================================

///
/// Filter entity
///
class Filter {
  ///
  /// Displayed label
  ///
  final String label;

  ///
  /// The displayed icon when selected
  ///
  final IconData icon;

  const Filter({this.label, this.icon});
}

// =============================================================================

///
/// The filter widget
///
class ChipsFilter extends StatefulWidget {
  ///
  /// The list of the filters
  ///
  final List<Filter> filters;

  ///
  /// The default selected index starting with 0
  ///
  final int selected;
  final  VoidCallback  callback;

  ChipsFilter({Key key, this.filters, this.selected, this.callback}) : super(key: key);

  @override
  _ChipsFilterState createState() => _ChipsFilterState();
}

class _ChipsFilterState extends State<ChipsFilter> {
  ///
  /// Currently selected index
  ///
  ///
  _ChipsFilterState(
      {this.selectedIndex,
        this.callback
        });
  int selectedIndex;
  final  VoidCallback callback;

  @override
  void initState() {
    // When [widget.selected] is defined, check the value and set it as
    // [selectedIndex]
    if (widget.selected != null &&
        widget.selected >= 0 &&
        widget.selected < widget.filters.length) {
      this.selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: this.chipBuilder,
        itemCount: widget.filters.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  ///
  /// Build a single chip
  ///
  Widget chipBuilder(context, currentIndex,) {
    Filter filter = widget.filters[currentIndex];
    bool isActive = this.selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {

          selectedIndex = currentIndex;
          widget.callback;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.appColor : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                margin: EdgeInsets.only(right: 5,left:5),

              ),
            Text(
              filter.label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppTheme.white : Colors.black,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  bool isSelected;

  Item({this.isSelected});
}
