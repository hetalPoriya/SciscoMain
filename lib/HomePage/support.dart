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
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/models/myordersrespo.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';
import 'package:scisco/models/VechicleEquipmentModel.dart';
import 'package:scisco/models/VechicleTypeDatum.dart';
import 'package:scisco/models/MyProfileModel.dart';
import 'package:scisco/navigation_home_screen.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Support> {


  AnimationController animationController;

  List<VechicleTypeDatum> items = List<VechicleTypeDatum>();
  List<VechicleEquipmentDatum> itemsVehiclequipmentModel =
      List<VechicleEquipmentDatum>();
  List<String> itemsStr = List<String>();
  var _itemsDatum;
  List<String> selectedEquipmentVechicle = List();
  ScrollController _controller;
  var selectedDate = new DateTime.now();


  final _msgCtr = TextEditingController();
  int index = 0;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);


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

    return  new WillPopScope(
        onWillPop: () {
          _willPopCallback();
    },

     child: Scaffold(
      appBar:
      AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "Support",
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.white,

      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,

        child:Container(
          alignment: Alignment.center,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[


              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: AppTheme.chipBackground,
                  borderRadius: BorderRadius.circular(15),

                ),                child: TextField(
                  keyboardType: TextInputType.multiline,
        //        inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),],

                maxLines: 6,

                  controller: _msgCtr,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Write Something",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                alignment: Alignment.center,
                height: size.height * 0.12,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedButton(
                      color: AppTheme.buttoncolor,
                      text: "Send Message",
                      press: () {

                        if(_msgCtr.text.toString().isEmpty){
                          _showMyDialog(context, "Error","Please Write Something.");
                        }else{
                          _dialogForSupport();
                        }
                      },
                    ),
                  ],
                ),
              )


            ],
          )
        ),

      ),

    ));
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
  }
  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }



  onChipSelected(int index) {
    setState(() {
      // selectedlabourType = items[index].title;
      // selectedlabourTypeImg = items[index].image_url;
      // selectedlabourTypeId = items[index].id;
      // selectedlabourTypePrice = items[index].price;

      print(index.toString() + " POSITION");
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }






  void _showMyDialog(
    BuildContext context,
    String title,
    String msg,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          return CupertinoAlertDialog(
          title: Text(title),
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

  Future<void> _dialogForSupport() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Support'),
          content: Text('Are you sure? you want to proceed'),
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
                send_driver_message();
              },
            ),
          ],
        );
      },
    );
  }


  Future<Response> send_driver_message() async {
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
          "user_id": prefs.getString(SharedPrefKey.USERID),
          "message": _msgCtr.text.toString(),

        });
        Response response = await baseApi.dio.post(supportUrl,data:body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var bankdetailrespo = CommonRespoModel.fromJson(parsed);
          progressDialog.dismiss();
          if (bankdetailrespo.error == "1") {

            _showMyDialog(context,"Support", bankdetailrespo.error_msg);
            _msgCtr.text = "";

          } else {
            String error_msg = bankdetailrespo.error_msg;
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var formatter = new DateFormat('yyyy-MM-dd');

        // _dateOfBirthCtrl.text = formatter.format(selectedDate);
      });
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
      builder: (BuildContext context) {

    return CupertinoAlertDialog(
        title: Text("Update Bank Details"),
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

              },
              child: Text(
                "Okay",
                style: TextStyle(
                    fontFamily: AppTheme.fontName, color: AppTheme.buttoncolor),
              )),
        ],
      );});
}



