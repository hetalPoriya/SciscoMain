import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/my_orders_detail.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/models/MyOrdersDatum.dart';
import 'package:scisco/models/myordersrespo.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';
import 'package:scisco/models/VechicleTypeDatum.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../navigation_home_screen.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MyOrders> {
  AnimationController animationController;
  List<MyOrdersDatum> myordersdatum = new List();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    my_orderReq();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new WillPopScope(
        onWillPop: () {
          _willPopCallback();
        },
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: AppTheme.textcolor, //change your color here
              ),
              title: Text(
                "My Quotes",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppTheme.fontName,
                  color: AppTheme.darkText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              elevation: 0,
              backgroundColor: AppTheme.white,
            ),
            body:

            ListView.builder(
              shrinkWrap: true,
              itemCount: myordersdatum.length,
              itemBuilder: (context, index) {
                return
                InkWell(
                  onTap: (){

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyOrdersDetail(
                              orderId: myordersdatum[index]
                                  .order_id, orderStatus: myordersdatum[index].orderstaus,);
                        },
                      ),(route)=>false
                    );
                  },
                  child: Container(

                      height: size.height*0.12,
                      child: Card(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: HexColor("#FFFFFF"), width: 2.0),
                            borderRadius: BorderRadius.circular(5.0)),
                        color: HexColor("#FFFFFF"),
                        elevation: 4.0,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[

                            Container(


                                padding: EdgeInsets.all(10),
                                alignment: Alignment.topLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(

                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            'Order Id: #${myordersdatum[index].order_id}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.textcolor,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: "WorkSans")),
                                        Text(
                                            'Order Date: #${myordersdatum[index].order_date}',

                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textcolor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "WorkSans")),


                                      ],)

                                      ,
                                    Container(
                                      padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red[500],
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                      child:
                                      Text(myordersdatum[index].orderstaus,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 10,fontFamily: AppTheme.fontName),)

                                    )

                                  ],
                                )
                                ),
                          ],
                        ),
                      )
                  )
                );
              },
            )));
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

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
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

  Future<Response> my_orderReq() async {
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
        });
        print(body.toString());
        Response response =
            await baseApi.dio.post(my_orderUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          print(response.toString());
          final parsed = json.decode(response.data).cast<String, dynamic>();

          var myordersRespo = MyOrdersRespo.fromJson(parsed);
          progressDialog.dismiss();
          if (myordersRespo.error == "1") {
            setState(() {
              myordersdatum = myordersRespo.list;

            });
          } else {
            String error_msg = myordersRespo.error_msg;
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
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.buttoncolor),
                )),
          ],
        );
      });
}
