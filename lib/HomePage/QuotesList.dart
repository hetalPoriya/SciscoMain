import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/ProductsList.dart';
import 'package:scisco/models/ProductsListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../navigation_home_screen.dart';
import 'DetailProduct.dart';

class QuotesListPage extends StatefulWidget {
  const QuotesListPage({
    Key key,
  }) : super(key: key);
  @override
  _QuotesListPageState createState() => _QuotesListPageState();
}

class _QuotesListPageState extends State<QuotesListPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool multiple = true;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging();
  String fcmToken = "";
  Location location;
  LocationData currentLocation;
  List<Item> indexList = new List();
  List<ProductsList> selectedProducts = new List();
  SharedPreferences prefs;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();

    // initPlatformState();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler());
    var initializationSettingsAndroid =
        // new AndroidInitializationSettings('@mipmap/ic_launcher');
        new AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // displayNotification(message);
      _showNotificationCustomSound(message);
    });

    initPrefs();

    _requestPermissions();
    FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);

      fcmToken = token;

      if (prefs.getString(SharedPrefKey.USERID) != null || prefs != null) {
        edit_token();
      }
      print("FIREABSETOKEN = " + token);
    });

    // if(pageName == "brandbyproduct") {
    //   getBrandsList();
    // } else if(pageName == "categorybysupercategory") {
    //   getProductsList();
    // }
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString(SharedPrefKey.SELECTEDPRODUCTS) != null &&
        prefs.getString(SharedPrefKey.SELECTEDPRODUCTS).isNotEmpty) {
      setState(() {
        // print("abcd"+json.decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS)).toString());
        selectedProducts = json
            .decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS))
            .map<ProductsList>((json) => ProductsList.fromJson(json))
            .toList();
        for (ProductsList productsList in selectedProducts) {
          indexList.add(new Item(isSelected: true));
        }
        // print("zxcv" + selectedProducts[0].id);
      });
    }
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future displayNotification(RemoteMessage message) async {
    var bigTextStyleInformation = BigTextStyleInformation(
      message.notification.body,
      htmlFormatBigText: true,
      contentTitle: message.notification.title,
      htmlFormatContentTitle: true,
      //summaryText: '$summary',
    );
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'GLASMIC', 'GLASMIC', 'your channel description',
        //'SCISCO', 'SCISCO', 'your channel description',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        styleInformation: bigTextStyleInformation);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification.title,
      message.notification.body,
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  Future<void> _showNotificationCustomSound(RemoteMessage message) async {
    /*bigTextStyleInformation = BigTextStyleInformation(
      message.notification.body,
      htmlFormatBigText: true,
      contentTitle: message.notification.title,
      htmlFormatContentTitle: true,
      //summaryText: '$summary',
    );*/

    String textData = message.notification.body.toString();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your other channel id',
            'your other channel name', 'your other channel description',
            sound: RawResourceAndroidNotificationSound('slow_spring_board'),
            enableVibration: true,
            playSound: true,
            styleInformation: BigTextStyleInformation(''));
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const MacOSNotificationDetails macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message.notification.title,
        message.notification.body, platformChannelSpecifics);
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {},
          ),
        ],
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          title: Text(
            "My Cart",
            style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w800),
          ),

          // Image.asset("assets/images/glasmic.png",height: 55,width: 100,),
          centerTitle: false,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    bottom: selectedProducts.length > 0 ? 50 : 0),
                child: selectedProducts.length > 0
                    ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        // crossAxisSpacing: 10.0,
                        // mainAxisSpacing: 15.0,
                        // childAspectRatio: MediaQuery.of(context).size.height/1400,
                        // crossAxisCount: 2,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemGrid(
                            productsListDatum: selectedProducts[index],
                            callBack: () {
                              setState(() {
                                if (indexList[index].isSelected) {
                                  indexList.removeAt(index);
                                  onItemunSelected(index);
                                } else {
                                  onItemSelected(index);
                                }
                              });
                            },
                            increaseCallBack: () {
                              setState(() {
                                onItemQuantityIncrease(index);
                              });
                            },
                            decreaseCallBack: () {
                              setState(() {
                                onItemQuantityDecrease(index);
                              });
                            },
                            cardselected: indexList[index].isSelected,
                          );
                        },
                        itemCount: selectedProducts.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 10.0));
                        },
                      )
                    : noItemHome()),
            selectedProducts.length > 0
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: size.height * 0.08,
                      color: AppTheme.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${selectedProducts.length.toString()} ${selectedProducts.length > 1 ? 'Items' : 'Item'}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AppTheme.nearlyBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.fontName)),
                          ButtonTheme(
                              buttonColor: AppTheme.appColor,
                              minWidth: 20.0,
                              height: 30.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                onPressed: () async {
                                  quoteOrLoginPage("placeorder");
                                  /*prefs.getString(SharedPrefKey.USERID)!=null?
                                getaQuote():Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return LoginScreen(selectedProducts: []);
                                    },
                                  ),
                                );*/
                                },
                                child: Text('Place order',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontName)),
                              )),
                          ButtonTheme(
                              buttonColor: AppTheme.appColor,
                              minWidth: 20.0,
                              height: 30.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                onPressed: () async {
                                  quoteOrLoginPage("getaquote");
                                  /*prefs.getString(SharedPrefKey.USERID)!=null?
                                getaQuote():Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return LoginScreen(selectedProducts: []);
                                    },
                                  ),
                                );*/
                                },
                                child: Text('Get a quote',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontName)),
                              ))
                        ],
                      ),
                    ),
                  )
                : Wrap()
          ],
        ));
  }

  onItemSelected(int index) {
    setState(() {});

    print(index.toString() +
        " POSITION-------"); /*json.encode(mBookingSubmitModel)*/
  }

  onItemunSelected(int index) {
    setState(() {
      selectedProducts.remove(selectedProducts[index]);
      prefs.setString(
          SharedPrefKey.SELECTEDPRODUCTS, json.encode(selectedProducts));
    });
    print(index.toString() +
        " POSITION-------"); /*json.encode(mBookingSubmitModel)*/
  }

  onItemQuantityIncrease(int index) {
    setState(() {
      // selectedProducts.removeAt(index);
      selectedProducts[index].quantity++;
      prefs.setString(
          SharedPrefKey.SELECTEDPRODUCTS, json.encode(selectedProducts));
    });
    // print(index.toString() + " POSITION-------");/*json.encode(mBookingSubmitModel)*/
  }

  onItemQuantityDecrease(int index) {
    setState(() {
      // selectedProducts.removeAt(index);
      selectedProducts[index].quantity >= 2
          ? selectedProducts[index].quantity--
          : null;
      prefs.setString(
          SharedPrefKey.SELECTEDPRODUCTS, json.encode(selectedProducts));
    });
    print(index.toString() +
        " POSITION-------"); /*json.encode(mBookingSubmitModel)*/
  }

  Widget loadingLayoutSlider() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }

/*  Future<void> _getData() async {
    setState(() {
      if(pageName == "brandbyproduct") {
        getBrandsList();
      } else if(pageName == "categorybysupercategory") {
        getProductsList();
      }

    });
  }*/

/*

  Future<Response> getBrandsList() async {
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
          "brandid": id,
        });
        Response response =
        await baseApi.dio.post(brandByIDUrl, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE:" + parsed.toString() + body);

          var productsListModel = ProductsListModel.fromJson(parsed);

          if (productsListModel.error == "1") {
            setState(() {
              productsList = productsListModel.list;
              for (int i = 0; i < productsList.length; i++) {
                bool status = false;
                if (selectedProducts != null && selectedProducts.isNotEmpty) {
                  for (ProductsList productList in selectedProducts) {
                    if (productsList[i].id == productList.id) {
                      status = true;
                      break;
                    } else {
                      status = false;
                    }
                  }
                }

                indexList.add(new Item(isSelected: status));
                // indexList.add(new Item(isSelected: false));
              }
            });
          } else {
            String error_msg = productsListModel.error_msg;
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE NEwBooking:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }
  Future<Response> getProductsList() async {
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
          "brandid": id,
        });
        Response response =
        await baseApi.dio.post(brandByIDUrl, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE:" + parsed.toString() + body);

          var productsListModel = ProductsListModel.fromJson(parsed);

          if (productsListModel.error == "1") {
            setState(() {

              productsList = productsListModel.list;


              for (int i = 0; i < productsList.length; i++) {
                for (ProductsList productList in selectedProducts) {
                  if(productsList[i].id == productList.id) {
                    indexList.add(new Item(isSelected: true));
                  } else {
                    indexList.add(new Item(isSelected: false));
                  }
                }
                // indexList.add(new Item(isSelected: false));
                if(mBookingSubmitModel!=null){
                  if(items[i].id==mBookingSubmitModel.labourMensId){
                    indexList.add(new Item(isSelected: true));
                    onItemSelected(i);
                  }else{
                    indexList.add(new Item(isSelected: false));

                  }

                }else{
                indexList.add(new Item(isSelected: false));

                 }

              }
            });
          } else {
            String error_msg = productsListModel.error_msg;
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE NEwBooking:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

*/

  Future<Response> edit_token() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "usre_id": prefs.getString(SharedPrefKey.USERID),
          "divice": 'android',
          "token": fcmToken,
        });
        Response response = await baseApi.dio.post(edit_tokenUrl, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var productsListModel = CommonRespoModel.fromJson(parsed);

          if (productsListModel.error == "1") {
          } else {
            String error_msg = productsListModel.error_msg;
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE NEwBooking:" + e.toString());

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  void quoteOrLoginPage(String orderType) async {
    List<String> list = new List();
    List<String> quantity = new List();
    for (ProductsList productsList in selectedProducts) {
      list.add(productsList.id);
      quantity.add(productsList.quantity.toString());
    }
    prefs.getString(SharedPrefKey.USERID) != null
        ? getaQuote(list, quantity, orderType)
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen(selectedProducts: list);
              },
            ),
          );
  }

  Future<Response> getaQuote(
      List<String> list, List<String> quantity, String orderType) async {
/*
    List<String> list = new List();
    for (ProductsList productsList in selectedProducts) {
      list.add(productsList.id);
    }*/

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
          "user_id": prefs.getString(SharedPrefKey.USERID),
          "product": list,
          "quantity": quantity,
          "ordertype": orderType,
        });
        print(body);
        Response response = await baseApi.dio.post(getaQuoteUrl, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var productsListModel = CommonRespoModel.fromJson(parsed);

          if (productsListModel.error == "1") {
            selectedProducts.clear();
            prefs.setString(
                SharedPrefKey.SELECTEDPRODUCTS, json.encode(selectedProducts));
            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new NavigationHomeScreen()),
                  (route) => false);
            });
            displayToast(productsListModel.error_msg, context);
          } else {
            String error_msg = productsListModel.error_msg;
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE NEwBooking:" + e.toString());
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

class ItemGrid extends StatefulWidget {
  const ItemGrid({
    Key key,
    this.productsListDatum,
    this.increaseCallBack,
    this.decreaseCallBack,
    this.callBack,
    this.cardselected,
  }) : super(key: key);

  final ProductsList productsListDatum;
  final VoidCallback callBack;
  final VoidCallback increaseCallBack;
  final VoidCallback decreaseCallBack;

  final bool cardselected;

  @override
  _ItemGridState createState() => _ItemGridState(
      productsListDatum: productsListDatum,
      callBack: callBack,
      increaseCallBack: increaseCallBack,
      decreaseCallBack: decreaseCallBack,
      cardselected: cardselected);
}

class _ItemGridState extends State<ItemGrid> {
  _ItemGridState(
      {this.productsListDatum,
      this.callBack,
      this.increaseCallBack,
      this.decreaseCallBack,
      this.cardselected});

  ProductsList productsListDatum;
  VoidCallback callBack;
  VoidCallback increaseCallBack;
  VoidCallback decreaseCallBack;

  bool cardselected = false;

  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initprefs();
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF656565).withOpacity(0.15),
              blurRadius: 4.0,
              spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          /// Set Animation image to detailProduk layout
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return detailProduk(productsListDatum.id);
                    },
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: mediaQueryData.size.height / 5.0,
                    width: mediaQueryData.size.width / 3.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(
                              productsListDatum.image,
                            ),
//                                AssetImage(gridItem.img),
                            fit: BoxFit.cover)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (productsListDatum.flat.isNotEmpty &&
                            productsListDatum.flat != '0')
                          Badge(
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: AppTheme.appColor,
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            badgeContent:
                                Text('Flat Rs.' + productsListDatum.flat,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    )),
                          ),
                        if (productsListDatum.discount.isNotEmpty &&
                            productsListDatum.discount != '0')
                          Badge(
                            toAnimate: false,
                            shape: BadgeShape.square,
                            badgeColor: Colors.deepPurple,
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            badgeContent: Text(
                                'Discount: ' + productsListDatum.discount + '%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
          Padding(padding: EdgeInsets.only(top: 7.0)),

          Flexible(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return detailProduk(productsListDatum.id);
                    },
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
//                    gridItem.title,
                      productsListDatum.product_name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          letterSpacing: 0.5,
                          color: Colors.black54,
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.0),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 0.0, bottom: 5),
                    child: Text(
                      'Category: ${productsListDatum.category}',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, bottom: 5),
                    child: Text(
                      'Sub category: ${productsListDatum.supercategoryname}',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 5.0, bottom: 5),
                    child: Text(
                      'Brand: ${productsListDatum.brand_name}',
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // prefs!=null?
                  // prefs.getBool(SharedPrefKey.ISLOGEDIN)?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 25.00,
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.decreaseCallBack();
                                });
                              },
                              child: Icon(
                                Icons.do_not_disturb_on,
                                color: AppTheme.appColor,
                              ),
                            ),
                            Text(
                              productsListDatum.quantity.toString(),
                              style: TextStyle(color: AppTheme.appColor),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.increaseCallBack();
                                  });
                                },
                                child: Icon(Icons.add_circle,
                                    color: AppTheme.appColor)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: 20, top: 10, left: 10),
                          child: InkWell(
                            onTap: () async {
                              widget.callBack();
                            },
                            child: Icon(Icons.delete_outlined),
                          ),
                          /*child: ButtonTheme(
                              buttonColor: Colors.white,
                              minWidth: 70.0,
                              height: 30.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        15.0),
                                    side: BorderSide(
                                        color: AppTheme.white)),
                                onPressed: () async {

                                  widget.callBack();

                                },
                                child: Icon(Icons.delete_outlined),
*/ /*                                Text(
                                    !widget.cardselected?
                                    'Add':'Remove',
                                    textAlign:
                                    TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: !widget.cardselected?Colors.black:AppTheme.white,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily: AppTheme
                                            .fontName)),*/ /*
                              )))*/
                        ),
                      ),
                    ],
                  ),
                  /*Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, top: 10,left: 10),
                      child: InkWell( onTap: () async {
                        widget.callBack();
                      },
                        child: Icon(Icons.delete_outlined),
                      ),
                      */ /*child: ButtonTheme(
                              buttonColor: Colors.white,
                              minWidth: 70.0,
                              height: 30.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        15.0),
                                    side: BorderSide(
                                        color: AppTheme.white)),
                                onPressed: () async {

                                  widget.callBack();

                                },
                                child: Icon(Icons.delete_outlined),
*/ /**/ /*                                Text(
                                    !widget.cardselected?
                                    'Add':'Remove',
                                    textAlign:
                                    TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: !widget.cardselected?Colors.black:AppTheme.white,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily: AppTheme
                                            .fontName)),*/ /**/ /*
                              )))*/ /*
                    ),
                  ),*/
                  //:Wrap():Wrap()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class noItemHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          margin: new EdgeInsets.symmetric(vertical: 20.0),
          alignment: Alignment.center,
          color: Colors.white,
          height: size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.only(top: mediaQueryData.padding.top + 5.0)),
              Image.asset(
                "assets/images/tutor_one.png",
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
                  'Sit back and please wait',
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
        ));
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final CallbackHandle resumeCallBack;
  final CallbackHandle detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print("inactive");
        break;

      case AppLifecycleState.paused:
        print("pause");
        break;
      case AppLifecycleState.detached:
        print("Detached");

        await detachedCallBack;
        break;
      case AppLifecycleState.resumed:
        print("Resume");

        await resumeCallBack;
        break;
    }

    // print('$state');
    /* _log.finest('''
=============================================================
               $state
=============================================================
''');*/
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}

class Item {
  bool isSelected;

  Item({this.isSelected});
}
