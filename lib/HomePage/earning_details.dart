import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/models/AllPaymentDatum.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/EarningDetailModel.dart';
import 'package:scisco/models/TotalEarningModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../main.dart';
import '../navigation_home_screen.dart';

class EarningDetails extends StatefulWidget {
  const EarningDetails({
    Key key,
    this.id,
  }) : super(key: key);
  final String id;

  @override
  _EarningDetailsState createState() => _EarningDetailsState(this.id);
}

class _EarningDetailsState extends State<EarningDetails>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<EarningDetails> {
  _EarningDetailsState(
    this.id,
  );

  String id = "";
  String _totalEarning = "0";
  String _jobAmt = "0";
  String _taxCharges = "0";
  String _serviceFee = "0";
  String _releaseAmount = "0";
  var now = new DateTime.now();
  var formatter = new DateFormat('dd MMM');

  String _selectedYear = DateTime.now().year.toString();
  String _selectedStartDate = new DateFormat('dd MMM').format(DateTime.now());
  String _selectedEndDate = new DateFormat('dd MMM')
      .format(new DateTime.now().add(new Duration(days: 7)));

  List<AllPaymentDatum> allReviewData = List<AllPaymentDatum>();
  AnimationController animationController;
  ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "Earnings Detail",
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
          child: Padding(
        padding: EdgeInsets.only(left: 10, right: 5),
        child: Column(
          children: [
            // dashedHorizontalLine(),

            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Paid to you",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.nearlyBlack,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "Job Amount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "A \$" + _jobAmt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            dashedHorizontalLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "Service fee",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "- A \$" + _serviceFee,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),

            /*  dashedHorizontalLine(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(padding: EdgeInsets.only(top:10,left: 5,right: 5,bottom: 0),
                        child:Text(
                          "GST",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.nearlyBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                      ),
                      Padding(padding: EdgeInsets.only(top:10,left: 5,right: 5,bottom: 0),
                        child: Text(
                          "- A \$" +_taxCharges,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.nearlyBlack,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                      )


                    ],
                  ),
*/

            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.black,
              height: 2,
              thickness: 1,
            ),

            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "Total Earning",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
                  child: Text(
                    "A \$" + _totalEarning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.nearlyBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Divider(
              color: Colors.black,
              height: 30,
              thickness: 1,
            )
          ],
        ),
      )),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      // setState(() {
      // //   print(isContinueVisible.toString());
      // });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      // setState(() {
      //   // print(isContinueVisible.toString());
      // });
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    get_driver_payment_detail();
  }

  Future<Response> get_driver_payment_detail() async {
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
          "driver_id": prefs.getString(SharedPrefKey.USERID),
          "payment_id": id,
        });

        Response response =
            await baseApi.dio.post(get_driver_payment_detailUrl, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var earningDetails = EarningDetailModel.fromJson(parsed);

          if (earningDetails.error == "1") {
            setState(() {
              _totalEarning = earningDetails.earn_amount.toString();
              _jobAmt = earningDetails.booking_amount.toString();
              _taxCharges = earningDetails.tax_charge.toString();
              _serviceFee = earningDetails.service_fee.toString();
            });
          } else {
            String error_msg = earningDetails.error_msg;
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

  Future<void> _successDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            msg != null ? msg : '',
            style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class noItemHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.transparent,
      height: size.height / 2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 50.0)),
            Image.asset(
              "assets/images/booking_success.png",
              width: 250.0,
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 5.0)),
            Text(
              'Payment history not found',
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
                'Payment history not found please wait...',
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

class ReviewItemListView extends StatefulWidget {
  const ReviewItemListView({
    Key key,
    this.moveitemDatum,
    this.callBack,
    this.animationController,
    this.animation,
    this.cardselected,
  }) : super(key: key);

  final AllPaymentDatum moveitemDatum;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool cardselected;

  @override
  _ReviewItemListViewState createState() => _ReviewItemListViewState(
      moveitemDatum: moveitemDatum,
      callBack: callBack,
      animationController: animationController,
      animation: animation,
      cardselected: cardselected);
}

class _ReviewItemListViewState extends State<ReviewItemListView> {
  _ReviewItemListViewState(
      {this.moveitemDatum,
      this.callBack,
      this.animationController,
      this.animation,
      this.cardselected});

  AllPaymentDatum moveitemDatum;
  VoidCallback callBack;
  AnimationController animationController;
  Animation<dynamic> animation;
  bool cardselected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cardWidth = MediaQuery.of(context).size.width * 0.15;
    double cardHeight = MediaQuery.of(context).size.height * 0.15;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 2 / 0.7,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Card(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: HexColor("#F5F5F5"), width: 2.0),
                            borderRadius: BorderRadius.circular(15.0)),
                        color: HexColor("#F5F5F5"),
                        elevation: 0.0,
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
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                  moveitemDatum.created_at,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: widget.cardselected
                                                          ? AppTheme.textcolor
                                                          : AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: Text(
                                                  "Job Number: " +
                                                      moveitemDatum.job_num,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: widget.cardselected
                                                          ? AppTheme.textcolor
                                                          : AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: false,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10, top: 0),
                                                  child: ButtonTheme(
                                                      buttonColor: Colors.green,
                                                      minWidth: 20.0,
                                                      height: 30.0,
                                                      child:
                                                      RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .green)),
                                                        onPressed: () async {
                                                          _requestforMoney(
                                                              moveitemDatum.id);
                                                        },
                                                        child: Text(
                                                            'Request Money',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: widget
                                                                        .cardselected
                                                                    ? AppTheme
                                                                        .white
                                                                    : AppTheme
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily: AppTheme
                                                                    .fontName)),
                                                      ))),
                                            ),
                                            Visibility(
                                              visible: moveitemDatum.status ==
                                                      "Credited"
                                                  ? true
                                                  : false,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10, bottom: 5),
                                                child: Text(
                                                    putstatus(
                                                        moveitemDatum.status),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: moveitemDatum
                                                                    .status ==
                                                                "Rejected"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            AppTheme.fontName)),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 10, top: 0),
                                              child: Text(
                                                  'A \$ ' +
                                                      moveitemDatum.req_amount,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: widget.cardselected
                                                          ? AppTheme.textcolor
                                                          : AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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

  Future<Response> put_driver_booking_request_payment(String payment_id) async {
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
          "driver_id": prefs.getString(SharedPrefKey.USERID),
          "payment_id": payment_id,
        });
        Response response = await baseApi.dio
            .post(put_driver_booking_request_paymentURL, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var totalEarning = CommonRespoModel.fromJson(parsed);

          if (totalEarning.error == "1") {
            _successDialog(totalEarning.error_msg);
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

  Future<void> _successDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            msg != null ? msg : '',
            style: TextStyle(fontFamily: AppTheme.fontName, fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new NavigationHomeScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestforMoney(String payment_id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Request Money'),
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
                put_driver_booking_request_payment(payment_id);
              },
            ),
          ],
        );
      },
    );
  }

  String putstatus(String status) {
    if (status == "Pending") {
      return "Pending";
    } else if (status == "Rejected") {
      return "Rejected";
    } else if (status == "Credited") {
      return "Credited";
    } else {
      return "";
    }
  }

  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}

Widget dashedHorizontalLine() {
  return Row(
    children: [
      for (int i = 0; i < 30; i++)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
    ],
  );
}
