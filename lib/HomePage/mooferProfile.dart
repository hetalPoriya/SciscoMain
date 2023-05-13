import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/edit_profile.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/models/AllReviewData.dart';
import 'package:scisco/models/AllVehicleData.dart';
import 'package:scisco/models/DriverProfileModel.dart';
import 'package:scisco/models/meals_list_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../main.dart';
import '../navigation_home_screen.dart';

class MooferProfile extends StatefulWidget {
  const MooferProfile(
      {Key key, this.driverId, this.pickupAddressLat, this.pickupAddressLng})
      : super(key: key);
  final String driverId;
  final double pickupAddressLat;
  final double pickupAddressLng;

  @override
  _MooferProfileState createState() =>
      _MooferProfileState(driverId, pickupAddressLat, pickupAddressLng);
}

class _MooferProfileState extends State<MooferProfile>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MooferProfile> {
  _MooferProfileState(
      this.driverId, this.pickupAddressLat, this.pickupAddressLng);

  String driverId;
  double pickupAddressLat;
  double pickupAddressLng;

  List<AllVehicleData> items = List<AllVehicleData>();
  AnimationController animationController;
  bool multiple = true;
  bool isContinueVisible = false;
  ScrollController _controller;
  List<Item> indexList = new List();
  int count = 9;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;
  List<AllVehicleData> allVehicleData = List<AllVehicleData>();
  List<AllReviewData> allReviewData = List<AllReviewData>();
  var driverName = "";
  var driverImage = "";
  var strontRating = "";
  var efficientRating = "";
  var carefullRating = "";
  var politeRating = "";
  var totalRating = "";
  var rating = "2.5";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    fetch_driverProfile(driverId);
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
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return new WillPopScope(
        onWillPop: () {
      _willPopCallback();
    },
    child:

      Scaffold(
      backgroundColor: AppTheme.white,
      appBar:
      AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          driverName,
          style: TextStyle(
            fontSize: 20,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.white,
        actions: [
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new EditProfile()),
              );
            },
            child: Text(
              "Edit",
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body:
      FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Container(

                child: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Container(
                    width: size.width / 3,
                    height: size.height / 5,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(driverImage)))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, top: 10),
                              child: RatingBarIndicator(
                                rating: double.parse(rating),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Color(0xFFfc7c1d),
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, top: 2),
                              child: Text(
                                  rating + " (" + totalRating + " ratings)",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textcolor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppTheme.fontName)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: Color(0xFFdfe1e6),
                          height: 1,
                          thickness: 1,
                          indent: 30,
                          endIndent: 30,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 5, top: 5),
                                      child: RatingBarIndicator(
                                        rating: 1,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Color(0xFFfc7c1d),
                                        ),
                                        itemCount: 1,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, top: 0),
                                      child: Text(strontRating,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textcolor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 0),
                                  child: Text("Strong",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textcolor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 5, top: 5),
                                      child: RatingBarIndicator(
                                        rating: 1,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Color(0xFFfc7c1d),
                                        ),
                                        itemCount: 1,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, top: 0),
                                      child: Text(efficientRating,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textcolor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 2),
                                  child: Text("Efficient",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textcolor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 5, top: 5),
                                      child: RatingBarIndicator(
                                        rating: 1,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Color(0xFFfc7c1d),
                                        ),
                                        itemCount: 1,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, top: 0),
                                      child: Text(carefullRating,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textcolor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 2),
                                  child: Text("Careful",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textcolor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 5, top: 5),
                                      child: RatingBarIndicator(
                                        rating: 1,
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Color(0xFFfc7c1d),
                                        ),
                                        itemCount: 1,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, top: 0),
                                      child: Text(politeRating,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textcolor,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5, top: 2),
                                  child: Text("Polite",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.textcolor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: AppTheme.dividerColor,
                          height: 8,
                          thickness: 8,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, top: 35),
                      child: Text("Included in truck",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textcolor,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontName)),
                    ),
                    Container(
                      height: size.height / 4.5,
                      child:
                      ListView.builder(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: allVehicleData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = allVehicleData.length > 10
                              ? 10
                              : mealsListData.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController.forward();

                          return MealsView(
                            mealsListData: allVehicleData[index],
                            animation: animation,
                            animationController: animationController,
                          );
                        },
                      ),
                    ),
                    const Divider(
                      color: AppTheme.dividerColor,
                      height: 8,
                      thickness: 8,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, top: 35),
                      child: Text("Reviews",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textcolor,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontName)),
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true, //just set this property

                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: allReviewData.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = allReviewData.length > 10
                              ? 10
                              : allReviewData.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn)));
                          animationController.forward();

                          return ReviewItemListView(
                            moveitemDatum: allReviewData[index],
                            animation: animation,
                            animationController: animationController,
                            cardselected: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]));
          }
        },
      ),
    ));
  }

  ///
  /// handle pressed on the item of list
  ///
  onItemSelected(int index) {
    setState(() {
      print(index.toString() + " POSITION");
    });
  }

  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print(isContinueVisible.toString());
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print(isContinueVisible.toString());
      });
    }
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
  }
  Future<Response> fetch_driverProfile(String driver_id) async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();

        var body = json.encode({
          "driver_id": prefs.getString(SharedPrefKey.USERID),
          "current_lat": "0.0",
          "current_lng": "0.0",
          "current_radius": "5",
        });
        Response response =
            await baseApi.dio.post(driverProfileUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var driverProfileModel = DriverProfileModel.fromJson(parsed);

          print("RESPOONSE:" + parsed.toString());
          progressDialog.dismiss();
          if (driverProfileModel.error == "1") {
            setState(() {
              driverName = driverProfileModel.driver_name;
              driverImage = driverProfileModel.driver_image;
              strontRating = driverProfileModel.strong;
              efficientRating = driverProfileModel.efficient;
              carefullRating = driverProfileModel.careful;
              politeRating = driverProfileModel.polite_rating;
              totalRating = driverProfileModel.total_rating;
              rating = driverProfileModel.rating;

              allVehicleData = driverProfileModel.all_vehicledata;
              allReviewData = driverProfileModel.all_reviewsdata;

              /*  for (int i = 0; i < items.length; i++) {
                // indexList.add(new Item(isSelected: false));
              }
*/
              isContinueVisible = true;
            });
          } else {
            String error_msg = driverProfileModel.error_msg;
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
  bool get wantKeepAlive => true;
}

void _showMyDialog(
  BuildContext context,
  String msg,
) {
  showDialog(
      context: context,
      builder: (BuildContext context) {

    return CupertinoAlertDialog(
        title: Text("Price details"),
        content: Text(msg),
        actions: <Widget>[
          /*CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel")
          ),*/
          CupertinoDialogAction(
              textStyle: TextStyle(color: Colors.red),
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
                    fontFamily: AppTheme.fontName, color: AppTheme.buttoncolor),
              )),
        ],
      );});
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final AllVehicleData mealsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

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
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: "assets/images/office.png",
                    fit: BoxFit.contain,
                    image: mealsListData.image_name,
                    height: size.height * 0.13,
                    width: size.width * 0.13,
                    alignment: Alignment.center,
                  ),
                  Text(
                    mealsListData.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppTheme.textcolor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Item {
  bool isSelected;

  Item({this.isSelected});
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

  final AllReviewData moveitemDatum;
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

  AllReviewData moveitemDatum;
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
              aspectRatio: 4 / 3,
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
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 20, top: 0),
                                          child: GestureDetector(
                                              child: Container(
                                                  width: size.width / 7,
                                                  height: size.height / 9,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.contain,
                                                          image: new NetworkImage(
                                                              moveitemDatum
                                                                  .image_name)))),
                                              onTap: () => {}
                                        ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 0),
                                              child: Text(
                                                  moveitemDatum.customer_name,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 14, top: 5),
                                                  child: Text(
                                                      moveitemDatum
                                                          .reviews_date,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: widget
                                                                  .cardselected
                                                              ? AppTheme
                                                                  .textcolor
                                                              : AppTheme
                                                                  .textcolor,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily: AppTheme
                                                              .fontName)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 0,right:20),
                                      child: Text(moveitemDatum.message,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: widget.cardselected
                                                  ? AppTheme.textcolor
                                                  : AppTheme.textcolor,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: AppTheme.fontName)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5, top: 5),
                                                  child: RatingBarIndicator(
                                                    rating: 1,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Color(0xFFfc7c1d),
                                                    ),
                                                    itemCount: 1,
                                                    itemSize: 20.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, top: 0),
                                                  child: Text(
                                                      moveitemDatum
                                                          .strong_rating,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme
                                                              .textcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: AppTheme
                                                              .fontName)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 0),
                                              child: Text("Strong",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5, top: 5),
                                                  child: RatingBarIndicator(
                                                    rating: 1,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Color(0xFFfc7c1d),
                                                    ),
                                                    itemCount: 1,
                                                    itemSize: 20.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, top: 0),
                                                  child: Text(
                                                      moveitemDatum
                                                          .efficient_rating,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme
                                                              .textcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: AppTheme
                                                              .fontName)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 2),
                                              child: Text("Efficient",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5, top: 5),
                                                  child: RatingBarIndicator(
                                                    rating: 1,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Color(0xFFfc7c1d),
                                                    ),
                                                    itemCount: 1,
                                                    itemSize: 20.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, top: 0),
                                                  child: Text(
                                                      moveitemDatum
                                                          .careful_rating,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme
                                                              .textcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: AppTheme
                                                              .fontName)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 2),
                                              child: Text("Careful",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5, top: 5),
                                                  child: RatingBarIndicator(
                                                    rating: 1,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Icon(
                                                      Icons.star,
                                                      color: Color(0xFFfc7c1d),
                                                    ),
                                                    itemCount: 1,
                                                    itemSize: 20.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5, top: 0),
                                                  child: Text(
                                                      moveitemDatum
                                                          .polite_rating,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme
                                                              .textcolor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: AppTheme
                                                              .fontName)),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, top: 2),
                                              child: Text("Polite",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppTheme.textcolor,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily:
                                                          AppTheme.fontName)),
                                            ),
                                          ],
                                        )
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
}
