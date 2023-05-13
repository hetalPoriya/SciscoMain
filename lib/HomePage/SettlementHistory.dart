import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/SettlementDatum.dart';
import 'package:scisco/models/SettlementListModel.dart';
import 'package:scisco/models/TotalEarningModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../navigation_home_screen.dart';

class SettlementHistory extends StatefulWidget {
  @override
  _SettlementHistoryState createState() => _SettlementHistoryState();
}

class _SettlementHistoryState extends State<SettlementHistory>  with TickerProviderStateMixin {


  AnimationController animationController;

  List<SettlementDatum> settlementDatumList = List();
  List<Map<String, String>> listOfColumns = List();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  Scaffold(
        appBar: AppBar(


          brightness: Brightness.light,
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          title: Text(
            "Settlement History",
            style: TextStyle(
              fontSize: 20,
              color: AppTheme.darkText,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 0,
          backgroundColor: AppTheme.white,
        ),

        body: listOfColumns.length>0?
        DataTable(
          columns: [
            DataColumn(label: Text('Date',style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w800),)),
            DataColumn(label: Text('Released\nDate ',style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w800),)),
            DataColumn(label: Text('Amount',style: TextStyle(fontFamily: AppTheme.fontName,fontWeight: FontWeight.w800),)),
          ],
          rows:
          listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
              .map(
            ((element) => DataRow(
              cells: <DataCell>[
                DataCell(Text(element["Name"]!=null?element["Name"]:'')), //Extracting from Map element the value
                DataCell(Text(element["Number"]!=null?element["Number"]:'')),
                DataCell(Text(element["State"]!=null?element["State"]:'')),
              ],
            )),
          )
              .toList(),
        ):noItemHome()
    );



  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
  }
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();


    get_driver_payment_list();
  }

  Future<Response> get_driver_payment_list() async {
    bool isDeviceOnline = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "driver_id": prefs.getString(SharedPrefKey.USERID),
        });
        Response response =
        await baseApi.dio.post(get_driver_total_payment_listURL, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var totalEarning = SettlementListModel.fromJson(parsed);

          if (totalEarning.error == "1") {

            setState(() {

              for(int i=0;i<totalEarning.all_payment.length;i++){
                listOfColumns = [
                  {"Name":totalEarning.all_payment[i].created_at.toString(),"Number":totalEarning.all_payment[i].release_date.toString(),"State":"\$ "+totalEarning.all_payment[i].req_amount.toString()}];

              }

              // final List<Map<String, String>> listOfColumns = [
              //   {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
              //   // {"Name": "BBBBBB", "Number": "2", "State": "no"},
              //   // {"Name": "CCCCCC", "Number": "3", "State": "Yes"}
              // ];

              settlementDatumList.addAll(totalEarning.all_payment);

            });


          } else {
            String error_msg = totalEarning.error_msg;
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
}
class noItemHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.only(top: mediaQueryData.padding.top + 50.0)),
            Image.asset(
              "assets/images/placeholder.png",
              width: 250.0,
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 5.0)),
            Text(
              'Data not found',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.5,
                  color: Colors.black26.withOpacity(0.5),
                  fontFamily: AppTheme.fontName),
            ),
            Padding(
              padding:
              EdgeInsets.only(bottom: 5.0, left: 25, right: 25, top: 10),
              child: Text(
                'Data Not Found Please try after some time later',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10.5,
                    color: Colors.black26.withOpacity(0.8),
                    fontFamily: AppTheme.fontName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentBookingsListView extends StatefulWidget {
  const CurrentBookingsListView({
    Key key,
    this.currentBookingsDatum,
    this.callBack,
    this.animationController,
    this.animation,
    this.cardselected,
  }) : super(key: key);

  final SettlementDatum currentBookingsDatum;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool cardselected;

  @override
  _CurrentBookingsListViewState createState() => _CurrentBookingsListViewState(
      currentBookingsDatum: currentBookingsDatum,
      callBack: callBack,
      animationController: animationController,
      animation: animation,
      cardselected: cardselected);
}

class _CurrentBookingsListViewState extends State<CurrentBookingsListView> {
  _CurrentBookingsListViewState(
      {this.currentBookingsDatum,
        this.callBack,
        this.animationController,
        this.animation,
        this.cardselected});

  SettlementDatum currentBookingsDatum;
  VoidCallback callBack;
  AnimationController animationController;
  Animation<dynamic> animation;
  bool cardselected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            height: size.height,
            color: AppTheme.darkerText,
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding:
                  EdgeInsets.only(left: 5, top: 0),
                  child: Text(
                      currentBookingsDatum.created_at,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.cardselected
                              ? AppTheme.textcolor
                              : AppTheme.textcolor,
                          fontWeight: FontWeight.w800,
                          fontFamily: "WorkSans")),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: 5, top: 0),
                  child: Text(
                      currentBookingsDatum.release_date,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.cardselected
                              ? AppTheme.textcolor
                              : AppTheme.textcolor,
                          fontWeight: FontWeight.w800,
                          fontFamily: "WorkSans")),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: 5, top: 0),
                  child: Text(
                      "\$ "+currentBookingsDatum.req_amount,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: widget.cardselected
                              ? AppTheme.textcolor
                              : AppTheme.textcolor,
                          fontWeight: FontWeight.w800,
                          fontFamily: "WorkSans")),
                ),
              ],
            )),
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
      ],
    );

  }
}

