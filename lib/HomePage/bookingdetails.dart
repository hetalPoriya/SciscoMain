import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/models/AllImages.dart';
import 'package:scisco/models/BookingDetailsModel.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/MoveItemsDatum.dart';
import 'package:scisco/models/insuranceSavedData.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';
import '../main.dart';
import '../navigation_home_screen.dart';
import 'SliderShowFullmages.dart';

class BookinDetails extends StatefulWidget {
  const BookinDetails(
      {Key key,
      this.selectedMoveType,
      this.id,
      this.customer_id,
      this.order_id,
      this.isCurrentBooking,
      })
      : super(key: key);
  final String selectedMoveType;
  final String id;
  final String customer_id;
  final String order_id;
  final bool isCurrentBooking;

  @override
  _BookinDetailsState createState() => _BookinDetailsState(
      this.selectedMoveType,
      this.id,
      this.customer_id,
      this.order_id,
      this.isCurrentBooking,

  );
}

class _BookinDetailsState extends State<BookinDetails>
    with TickerProviderStateMixin {
  _BookinDetailsState(
      this.selectedMoveType,
      this.id,
      this.customer_id,
      this.order_id,
      this.isCurrentBooking,
      );

  String selectedMoveType;
  String id;
  String customer_id;
  String order_id;

  var pickupAddress = "";
  var pickupAddressUnitNo = "";
  var deliveryAddressUnitNo = "";
  var deliveryAddress = "";
  var deliveryDate = "";
  var pickupArrivalTime = "";
  var show_mobile = "0";
  var jobDetails = "";
  var anyStairInvolved = "";
  var accessIssue = "";
  var parkingInstructions = "";
  var truckType = "";
  var truckTypeImage = "";
  var driverRating = "2.5";
  var driverImage="";
  var driverId="";
  var allrating="";
  var driverName="";
  var kmAway="";
  var amount="";
  var _bookingStatus="Rejected";
  var _customer_mobile="";
  var booking_type="";
  var _imageFile;
  var _imageFileServer;
  List<MoveItemsDatum> items = List<MoveItemsDatum>();
  List<AllImages> allimages = List<AllImages>();
  List<String> allimagesUrl = List<String>();
  AnimationController animationController;
  bool multiple = true;
  bool isCurrentBooking;
  bool isContinueVisible = false;
  bool isMobileNumberVerified = false;
  List<InsuranceSavedData> insuranceDataList = List<InsuranceSavedData>();

  // List<Item> indexList = new List();

  final _fullNameText = TextEditingController();
  final _mobileNumberText = TextEditingController();
  final _emailAddressText = TextEditingController();
  final _creditCardNumText = TextEditingController();
  final _expiryText = TextEditingController();
  final _cvvText = TextEditingController();

  bool _validateFullName = false;
  bool _validateMobileNumber = false;
  bool _validateEmailAddress = false;
  bool _validateEmailAddressValid = false;
  bool _validateCreditCardNum = false;
  bool _validateExpiry = false;
  bool _validateCvv = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();

    customer_booking_detail(id,customer_id);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.grayWhite,
      appBar: AppBar(

        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Column(
          children: [
            Text(
              selectedMoveType,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Booking # "+order_id,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: show_mobile=="0"?false:true,
            child: FlatButton(

              onPressed: () {
                launch("tel://"+_customer_mobile);

              },
              child:
              RawMaterialButton(
                onPressed: () {
                  launch("tel://"+_customer_mobile);
                },
                elevation: 2.0,
                fillColor: Colors.green,
                child: Icon(

                  Icons.call,
                  color: AppTheme.white,
                  size: 20.0,
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              )

            )
          ),


        ],
        elevation: 0,
        backgroundColor: AppTheme.grayWhite,
      ),

      body: RefreshIndicator(
    onRefresh: _getData,
    child:

      SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [




              Visibility(
                visible: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 5),
                  child: Text("Booking details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textcolor,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppTheme.fontName)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pickup address",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(pickupAddressUnitNo==''?pickupAddress:pickupAddress+" Unit #"+pickupAddressUnitNo,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),
                    SizedBox(
                      height: 20,
                    ),

                    Text("Delivery address",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(deliveryAddress==''?deliveryAddress:deliveryAddress+" Unit #"+deliveryAddressUnitNo,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),


                    SizedBox(
                      height: 20,
                    ),

                    Text("Delivery date",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(deliveryDate,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),


                    SizedBox(
                      height: 20,
                    ),

                    Text("Pickup arrival time",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(pickupArrivalTime,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),


                    SizedBox(
                      height: 20,
                    ),

                    Text("Type of move",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(selectedMoveType,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),

                    // Job Detail
                    SizedBox(
                      height: 20,
                    ),

                    Text("Job Detail",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(jobDetails,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),

                    // Any Stair Involved
                    SizedBox(
                      height: 20,
                    ),

                    Text("Any stairs involved",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(anyStairInvolved,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),

                    // Access Issue
                    SizedBox(
                      height: 20,
                    ),

                    Text("Access Issue",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(accessIssue,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),

                    // Parking Instructions
                    SizedBox(
                      height: 20,
                    ),

                    Text("Parking Instructions",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(parkingInstructions,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),

                    // Truck TYpe Removalist Instructions
                    SizedBox(
                      height: 20,
                    ),

                    Text("Moofer package",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),
                    Text(truckType!=null?truckType:'',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppTheme.fontName)),
                    GestureDetector(
                      child: Center(
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/images/office.png",
                          fit: BoxFit.scaleDown,
                          image: truckTypeImage,
                          width: size.width * 0.7,
                          height: size.height * 0.2,
                          alignment: Alignment.center,
                        ),
                      ),

                      // onTap: () =>

                      // Scaffold
                      // .of(context)
                      // .showSnackBar(SnackBar(content: Text('RUN'))),
                    ),

                    // Photos
                    SizedBox(
                      height: 20,
                    ),

                    Text("Photos",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textcolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: "WorkSans")),
                    SizedBox(
                      height: 5,
                    ),

                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: allimages.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        return
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliderShowFullmages(listImagesModel: allimagesUrl, current: index)));

                            },
                            child:  FadeInImage.assetNetwork(
                              placeholder: "assets/images/office.png",
                              fit: BoxFit.cover,
                              image: allimages !=
                                  null
                                  ? allimages[index].image_url
                                  : "",
                              width: size.width * 0.3,
                              height: size.height * 0.3,
                              alignment: Alignment.center,
                            )
                          );/*Image.file(
                          fileitems[index],
                          fit: BoxFit.cover,
                        );*/
                      },
                    ),
                    Visibility(

                      visible: insuranceDataList.length==0?false:true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            height: 20,
                          ),

                          Text("Value Inventory List",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.textcolor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "WorkSans")),

                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width*0.35,
                                child:
                                Text("Insured Item(s)",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textcolor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "WorkSans")),
                              ),
                              Container(

                                width: size.width*0.12,
                                child:Text("Qty",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textcolor,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontFamily: "WorkSans")),),
                              Container(

                                width: size.width*0.20,
                                child:
                                Text("Total Value",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textcolor,
                                        fontWeight:
                                        FontWeight.w700,
                                        fontFamily: "WorkSans")),)
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: insuranceDataList.length,
                            itemBuilder: (context, position1) {
                              return   ListView.builder(
                                shrinkWrap: true,
                                itemCount: insuranceDataList[position1].data.length,
                                itemBuilder: (context, position2) {


                                  return  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                        width: size.width*0.35,
                                        child: Text(insuranceDataList[position1].data[position2].categoryName,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textcolor,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "WorkSans")),

                                      ),
                                      Container(

                                        width: size.width*0.12,
                                        child: Text(insuranceDataList[position1].data[position2].qty,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textcolor,
                                                fontWeight:
                                                FontWeight.w400,
                                                fontFamily: "WorkSans")),
                                      ),
                                      Container(

                                        width: size.width*0.18,
                                        child: Text('\$'+insuranceDataList[position1].data[position2].totalValue,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textcolor,
                                                fontWeight:
                                                FontWeight.w400,
                                                fontFamily: "WorkSans")),
                                      )


                                    ],
                                  );



                                },
                              );
                            },
                          ),

                        ],
                      ),),

                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Visibility(
                  visible: !isCurrentBooking,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 10,
                  color: Color(0xFFdfe1e6),
                  ),

                  Padding(padding: EdgeInsets.only(left:15,right:15, top:15),

                      child:  Text("Payment Made",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textcolor,
                          fontWeight: FontWeight.w700,
                          fontFamily: "WorkSans")),

              ),

                  Padding(padding: EdgeInsets.only(left:15,right:15, top:5,bottom: 15),

                      child:  Text("\$"+amount,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFFfc7c1d),
                          fontWeight: FontWeight.w700,
                          fontFamily: "WorkSans")),

              ),



                ],

              )),

              Visibility(

                  visible: false,
                  child: Container(
                color: Colors.white,
                child:               Padding(
                  padding: EdgeInsets.only(
                      top: 15, bottom: 15, left: 25, right: 25),
                  child:
                  RichText(
                    text: TextSpan(
                        text:
                        'Final price will be determined at the delivery job.',
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.textcolor,fontFamily: AppTheme.fontName,fontWeight: FontWeight.w800),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' You will be charged once the job is complete ',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: AppTheme.fontName,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF0f1b4c)),
                          ),

                        ]),
                  ),
                ),

              )

              )
            ],
          )),),


    bottomNavigationBar: Visibility(
          visible: isCurrentBooking,
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.15,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

               showAcceptReject()

              ],
            ),
          )),
    );
  }


  Widget showAcceptReject(){
    Size size = MediaQuery.of(context).size;

    print(_bookingStatus);
    if(booking_type=="schedule"){
      if(_bookingStatus=='Booked'){

        return
          Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child:
                FlatButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    color: Colors.green,

                    onPressed: () {    driver_booking_status_change(
                        customer_id,
                        "Accepted",
                        id,
                        ""); },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          'Accept',

                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppTheme.fontName,
                              fontSize: 15),
                        ),
                      ],
                    )),
              ),
            ),
            SizedBox(width: 20,),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child:
                FlatButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    color: Color(0x1f7596ef),

                    onPressed: () { driver_booking_status_change(
                        customer_id,
                        "Rejected",
                        id,
                        ""); },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          'Reject',

                          style: TextStyle(
                              color: Color(0xFFfc7c1d),
                              fontFamily: AppTheme.fontName,
                              fontSize: 15),
                        ),
                      ],
                    )),
              ),
            )
          ],
        );
      }
      /*else if(_bookingStatus=='On the way')
      {
        return  Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: size.width * 0.80,
              height: size.height * 0.08,
              child: SwipingButton(
                key: GlobalKey<ScaffoldState>(),
                height: 80,
                text: 'Arrived',
                backgroundColor: Colors.green,
                buttonTextStyle: TextStyle(
                    fontSize: 14,
                    fontFamily:
                    AppTheme.fontName,
                    color: Colors.white),
                onSwipeCallback: () {
                  driver_booking_status_change(
                      customer_id,
                      BookingStatus.ARRIVED,
                      id,
                      "");
                },
              ),
            ),
          ],
        );

      }
      else if(_bookingStatus=='Arrived')
      {
        return   Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: size.width * 0.80,
              height: size.height * 0.08,
              child: SwipingButton(
                height: 80,
                key: GlobalKey<ScaffoldState>(),

                text: 'Loaded',
                backgroundColor: Colors.green,
                buttonTextStyle: TextStyle(
                    fontSize: 14,
                    fontFamily:
                    AppTheme.fontName,
                    color: Colors.white),
                onSwipeCallback: () {
                  driver_booking_status_change(
                      customer_id,
                      BookingStatus.LOADED,
                      id,
                      "");
                },
              ),
            ),
          ],
        );
      }
      else if(_bookingStatus=='Accepted')
      {
        return   Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: size.width * 0.80,
              height: size.height * 0.08,
              child: SwipingButton(
                key: GlobalKey<ScaffoldState>(),

                height: 80,
                text: 'On The Way',
                backgroundColor: Colors.green,
                buttonTextStyle: TextStyle(
                    fontSize: 14,
                    fontFamily:
                    AppTheme.fontName,
                    color: Colors.white),
                onSwipeCallback: () {
                  driver_booking_status_change(
                      customer_id,
                      BookingStatus.ONTHEWAY,
                      id,
                      "");
                },
              ),
            )
          ],
        );
      }
      else if(_bookingStatus=='Loaded'){
        return
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: size.width * 0.80,
                height: size.height * 0.08,
                child: SwipingButton(
                  key: GlobalKey<ScaffoldState>(),

                  height: 80,
                  text: 'Unloading',
                  backgroundColor: Colors.green,
                  buttonTextStyle: TextStyle(
                      fontSize: 14,
                      fontFamily:
                      AppTheme.fontName,
                      color: Colors.white),
                  onSwipeCallback: () {
                    driver_booking_status_change(
                        customer_id,
                        BookingStatus.UNLOADING,
                        id,
                        "");
                  },
                ),
              )
            ],
          );
      }
      else if(_bookingStatus=='Unloading')
      {
        return
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: size.width * 0.90,
                height: size.height * 0.08,
                child: SwipingButton(
                  key: GlobalKey<ScaffoldState>(),

                  height: 80,
                  text: 'Complete Booking',
                  backgroundColor: Colors.green,
                  buttonTextStyle: TextStyle(
                      fontSize: 14,
                      fontFamily:
                      AppTheme.fontName,
                      color: Colors.white),
                  onSwipeCallback: () {
                    driver_booking_status_change(
                        customer_id,
                        BookingStatus.COMPLETE,
                        id,
                        "");
                  },
                ),
              ),
            ],
          );
      } */
      else{
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child:
            FlatButton(
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: 40),
                color: Color(0x1f7596ef),

                onPressed: () { null; },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      _bookingStatus,

                      style: TextStyle(
                          color: Color(0xFFfc7c1d),
                          fontFamily: AppTheme.fontName,
                          fontSize: 15),
                    ),
                  ],
                )),
          ),
        );
      }

    }else{

     return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child:
          FlatButton(
              padding: EdgeInsets.symmetric(
                  vertical: 20, horizontal: 40),
              color: Color(0x1f7596ef),

              onPressed: () { null; },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    _bookingStatus,

                    style: TextStyle(
                        color: Color(0xFFfc7c1d),
                        fontFamily: AppTheme.fontName,
                        fontSize: 15),
                  ),
                ],
              )),
        ),
      );
    }

  }

  Future<void> _getData() async {
    setState(() {
      customer_booking_detail(id,customer_id);
    });
  }
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "From where do you want to take the photo?",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        captureImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        captureImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
  Future<Response> driver_booking_status_change(String customer_id,
      String new_status, String booking_id, String reject_type) async {
    bool isDeviceOnline = true;

    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "driver_id": prefs.getString(SharedPrefKey.USERID),
          "customer_id": customer_id,
          "new_status": new_status,
          "booking_id": booking_id,
          "reject_type": reject_type,
        });
        Response response =
        await baseApi.dio.post(driver_booking_status_changeUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var commonResponse = CommonRespoModel.fromJson(parsed);

          if (commonResponse.error == "1") {
            progressDialog.dismiss();



            customer_booking_detail(id,customer_id);



          } else {
            progressDialog.dismiss();
            customer_booking_detail(id,customer_id);
            _showMyDialog(context, commonResponse.error_msg);
            String error_msg = commonResponse.error_msg;
            displayToast(error_msg.toString(), context);
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSEBOokingstatus:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }
  Future<void> captureImage(ImageSource imageSource) async {

    try {
      final imageFile = await ImagePicker.platform.pickImage(source: imageSource);
      final dir = await path_provider.getTemporaryDirectory();

      final targetPath = dir.absolute.path +
          "/temp" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";

      // Compress plugin
      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 50,
      );

      setState(() {
        _imageFile = compressedImage;

        // fileitemsServer.add(imageFile.readAsBytesSync());
      });
    } catch (e) {
      print(e);
    }


   /* try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;

      });
    } catch (e) {
      print(e);
    }*/
  }
  Future<void> _cancelBookingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Cancel Booking'),
          content: Text('Are you sure? you want to cancel booking'),
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



              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => NavigationHomeScreen()));

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
                textStyle:
                    TextStyle(color: Colors.red, fontFamily: AppTheme.fontName),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                /*  Navigator.pushAndRemoveUntil(context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new NavigationHomeScreen()), ModalRoute.withName('/')
                  );*/
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
 void _showSuccessMyDialog(
    BuildContext context,
    String msg,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {

       return CupertinoAlertDialog(
          title: Text("Booking Success"),
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

  bool validateFullNameTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateFullName = true;
      });
      return false;
    }
    setState(() {
      _validateFullName = false;
    });
    return true;
  }

  bool validateMobileNumTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateMobileNumber = true;
      });
      return false;
    }
    setState(() {
      _validateMobileNumber = false;
    });
    return true;
  }

  bool validateEmailTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateEmailAddress = true;
      });
      return false;
    }
    setState(() {
      _validateEmailAddress = false;
    });
    return true;
  }

  bool validateCreditCardTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateCreditCardNum = true;
      });
      return false;
    }
    setState(() {
      _validateCreditCardNum = false;
    });
    return true;
  }

  bool validateExpiryTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateExpiry = true;
      });
      return false;
    }
    setState(() {
      _validateExpiry = false;
    });
    return true;
  }

  bool validateCVVTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        _validateCvv = true;
      });
      return false;
    }
    setState(() {
      _validateCvv = false;
    });
    return true;
  }

  bool validateValidEmailTextField(String userInput) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(userInput)) {
      setState(() {
        _validateEmailAddressValid = true;
      });
      return false;
    }
    setState(() {
      _validateEmailAddressValid = false;
    });
    return true;
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
                child: Image.asset(
                  "assets/images/backimg.png",
                  fit: BoxFit.contain,
                  height: 20,
                  width: 20,
                  alignment: Alignment.topLeft,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Text(
                      'I am moving',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'House',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.darkText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: AppTheme.grayWhite,
            ),
          ),
        ],
      ),
    );
  }
  Future<Response> customer_booking_detail(String booking_id,String customer_id) async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          "customer_id": customer_id,
          "booking_id": booking_id,
        });
        Response response =
        await baseApi.dio.post(driver_booking_detailsUrl, data: body);
        print("RESPOONSE:" + response.toString());

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var boookingDetailsModel = BookingDetailsModel.fromJson(parsed);

          // print("RESPOONSE:" + parsed.toString());

          if (boookingDetailsModel.error == "1") {

            progressDialog.dismiss();
            setState(() {
              driverName = boookingDetailsModel.driver_name;
              driverImage = boookingDetailsModel.driver_image;
              driverId = boookingDetailsModel.driver_id;
              pickupAddress = boookingDetailsModel.pickup_address;
              pickupAddressUnitNo = boookingDetailsModel.pickup_address_unit_no;
              deliveryAddress = boookingDetailsModel.delivery_address;
              deliveryAddressUnitNo = boookingDetailsModel.delivery_address_unit_no;
              deliveryDate = boookingDetailsModel.pickup_date;
              pickupArrivalTime = boookingDetailsModel.pickup_time;
              jobDetails = boookingDetailsModel.job_detail;
              anyStairInvolved = boookingDetailsModel.any_stairs_involved;
              accessIssue = boookingDetailsModel.access_issues;
              parkingInstructions = boookingDetailsModel.parking_inst;
              truckType = boookingDetailsModel.truck_type;
              truckTypeImage = boookingDetailsModel.category_image;
              allrating = boookingDetailsModel.driver_total_rating;
              kmAway = boookingDetailsModel.driver_distance.toString();
              allimages = boookingDetailsModel.all_images;
              insuranceDataList = boookingDetailsModel.insurance_data;

              amount = boookingDetailsModel.total_amount;
              _bookingStatus = boookingDetailsModel.booking_status;
              show_mobile = boookingDetailsModel.show_mobile;
              _customer_mobile = boookingDetailsModel.customer_mobile_number;
              booking_type = boookingDetailsModel.booking_type;

              order_id = boookingDetailsModel.order_id;

              allimagesUrl.clear();
              for(var images in boookingDetailsModel.all_images){
                allimagesUrl.add(images.image_url);
              }
              isContinueVisible = true;
            });
          } else {
            progressDialog.dismiss();

            String error_msg = boookingDetailsModel.error_msg;
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
      // progressDialog.dismiss();

      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }
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

  final MoveItemsDatum moveitemDatum;
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

  MoveItemsDatum moveitemDatum;
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
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 2.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 150,
                      child:
                      Card(
                        shape: widget.cardselected
                            ? new RoundedRectangleBorder(
                                side: new BorderSide(
                                    color: AppTheme.cardcolor, width: 2.0),
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
                            ? AppTheme.grayWhite
                            : AppTheme.white,
                        elevation: 4.0,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: size.height,
                                  width: size.width / 2.5,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(moveitemDatum.name,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: widget.cardselected
                                                ? AppTheme.textcolor
                                                : AppTheme.textcolor,
                                            fontWeight: widget.cardselected
                                                ? FontWeight.w800
                                                : FontWeight.w500,
                                            fontFamily: "WorkSans")),
                                  ),
                                ),
                                FadeInImage.assetNetwork(
                                  placeholder: "assets/images/office.png",
                                  fit: BoxFit.contain,
                                  image: moveitemDatum.image_url,
                                  height: size.height,
                                  width: 180,
                                  alignment: Alignment.bottomCenter,
                                ),
                              ],
                            ),
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
