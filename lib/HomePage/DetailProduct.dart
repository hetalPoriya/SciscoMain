import 'dart:convert';
import 'dart:developer';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/QuotesList.dart';
import 'package:scisco/HomePage/home_screen.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/ProImageDatum.dart';
import 'package:scisco/models/ProductsList.dart';
import 'package:scisco/models/ProductsListdetail.dart';
import 'package:scisco/models/productsdetailrespo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scisco/models/ProductsList.dart';
import 'package:scisco/models/ProductsListModel.dart';
import '../navigation_home_screen.dart';

class detailProduk extends StatefulWidget {
  var product_id = "";
  List<String> selectedProducts = new List();
  detailProduk(this.product_id);

  @override
  _detailProdukState createState() => _detailProdukState(this.product_id);
}

/// Detail Product for Recomended Grid in home screen
class _detailProdukState extends State<detailProduk> {
  String product_id;
  List<NetworkImage> sliderImages = List<NetworkImage>();
  static List<ProImageDatum> proimageDatum = List<ProImageDatum>();
  static List<ProductsListDetail> productListDetail =
      List<ProductsListDetail>();
  List<ProductsList> selectedProducts = new List();
  ProductsList product;
  SharedPreferences prefs;

  int stock = 0;
  var quantity = 1;

  _detailProdukState(this.product_id);

  var product_name = "";
  var offer_price = "";
  var currencyCode = "";
  var proDescription = "";
  var proSpecification = "";
  var mrp = "";
  var merchantName = "";
  var profeatures = "";

  @override
  static BuildContext ctx;
  List<ProductsList> productsList = List();
  // List<Item> indexList = new List();
  // List<ProductsList> selectedProducts = new List();
  // SharedPreferences prefs;

  @override
  void initState() {
    print("Product link: $product_id");
    getProductDetails();
    super.initState();
  }

  int valueItemChart = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  /// BottomSheet for view more in specification
  void _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: 1500.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Center(
                          child: Text(
                        'Specification',
                        style: _subHeaderCustomStyle,
                      )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                          child: Html(
                            /*gridItem.description*/
                            data: proSpecification,
                            /*   style: _detailText*/
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString(SharedPrefKey.SELECTEDPRODUCTS) != null &&
        prefs.getString(SharedPrefKey.SELECTEDPRODUCTS).isNotEmpty) {
      setState(() {
        // print("abcd"+json.decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS)).toString());
        selectedProducts = json
            .decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS))
            .map<ProductsList>((json) => ProductsList.fromJson(json))
            .toList();
        // print("zxcv" + selectedProducts.length.toString());

        for (int i = 0; i < productsList.length; i++) {
          for (ProductsList productList in selectedProducts) {
            if (productsList[i].id == productList.id) {
              productsList[i].quantity = productList.quantity;
              break;
            }
          }
        }
      });
    }
  }

  /// Custom Text black
  static var _customTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: AppTheme.fontName,
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  /// Custom Text black
  static var _customTextStylelinethrow = TextStyle(
      color: Colors.black,
      fontFamily: AppTheme.fontName,
      fontSize: 17.0,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough);

  /// Custom Text for Header title
  static var _subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: AppTheme.fontName,
      fontSize: 16.0);

  /// Custom Text for Detail title
  static var _detailText = TextStyle(
      fontFamily: AppTheme.fontName,
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    /// Variable Component UI use in bottom layout "Top Rated Products"
    var _suggestedItem = Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 20.0, top: 30.0, bottom: 20.0),
      child: Container(
        height: 280.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Related Products",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppTheme.fontName,
                      fontSize: 15.0),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: Colors.indigoAccent.withOpacity(0.8),
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    // var data = EasyLocalizationProvider.of(context).data;
    return Scaffold(
        key: _key,
        appBar: AppBar(
          brightness: Brightness.light,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          actions: <Widget>[],
          elevation: 0.5,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Product Detail',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 17.0,
              fontFamily: AppTheme.fontName,
            ),
          ),
        ),
        body: product_name == ''
            ? CustomLoader(
                color: Color(0xFF6991C7),
              )
            : Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Header image slider
                                imageSlider(context),

                                /// Background white title,price and ratting
                                Container(
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF656565)
                                              .withOpacity(0.15),
                                          blurRadius: 1.0,
                                          spreadRadius: 0.2,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10.0, right: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          product_name,
                                          style: _customTextStyle,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 5.0)),
                                        Text(
                                          'Category: ${productListDetail[0].category}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: AppTheme.fontName,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Super Category: ${productListDetail[0].supercategoryname}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: AppTheme.fontName,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Brand: ${productListDetail[0].brand_name}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: AppTheme.fontName,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Brochure: ${productListDetail[0].brochure}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: AppTheme.fontName,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.0)),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Background white for description
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    width: 600.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF656565)
                                                .withOpacity(0.15),
                                            blurRadius: 1.0,
                                            spreadRadius: 0.2,
                                          )
                                        ]),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Text(
                                              'Description',
                                              style: _subHeaderCustomStyle,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0,
                                                right: 20.0,
                                                bottom: 10.0,
                                                left: 20.0),
                                            child: Html(
                                              data: proDescription,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Container(
                                              color: Colors.black26,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      0.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      0.0))),
                                                  child: new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20.0,
                                                                left: 20),
                                                        child: Text(
                                                          'Specification',
                                                          style:
                                                              _subHeaderCustomStyle,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  left: 20.0,
                                                                  right: 20.0,
                                                                  bottom: 20.0),
                                                          child: Html(
                                                            //                gridItem.description
                                                            data:
                                                                proSpecification,
                                                            //                 style: _detailText
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Container(
                                              color: Colors.black26,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      0.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      0.0))),
                                                  child: new Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 20.0,
                                                                left: 20),
                                                        child: Text(
                                                          'Features',
                                                          style:
                                                              _subHeaderCustomStyle,
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  left: 20.0,
                                                                  right: 20.0,
                                                                  bottom: 20.0),
                                                          child: Html(
                                                            //                gridItem.description
                                                            data: profeatures,
                                                            //                 style: _detailText
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// Background white for Ratting
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                    width: 600.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF656565)
                                                .withOpacity(0.15),
                                            blurRadius: 1.0,
                                            spreadRadius: 0.2,
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: size.height * 0.08,
                      color: AppTheme.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonTheme(
                              buttonColor: AppTheme.appColor,
                              minWidth: 20.0,
                              height: 30.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)),
                                onPressed: () async {
                                  setState(() {
                                    log('A  ${product}');
                                   if(product != null) product.quantity = 1;
                                    selectedProducts.add(product);

                                    prefs.setString(
                                        SharedPrefKey.SELECTEDPRODUCTS,
                                        json.encode(selectedProducts));
                                  });
                                },
                                child: Text('Add to cart',
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
                  ),
                ],
              ));
  }

  /// ImageSlider in header
  Widget imageSlider(BuildContext context) {
    return Container(
        height: 250,
        child: CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              scrollDirection: Axis.horizontal,
              height: MediaQuery.of(context).size.height,
              autoPlay: true,
            ),
            items: proimageDatum
                .map((item) => Container(
                      child: Center(
                          child: Image.network(
                        item.product_image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                      )),
                    ))
                .toList()));
  }

  Future<Response> getProductDetails() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    /* ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();*/
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "product_id": product_id,
        });
        Response response =
            await baseApi.dio.post(product_detailsURL, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE:" + parsed.toString() + body);

          var myordersRespo = ProductsDetailRespo.fromJson(parsed);

          // progressDialog.dismiss();
          if (myordersRespo.error == "1") {
            setState(() {
              productListDetail = myordersRespo.list;
              proimageDatum = myordersRespo.multi_image;
              product_name = productListDetail[0].product_name;
              proDescription = productListDetail[0].description;
              proSpecification = productListDetail[0].specification;
              profeatures = productListDetail[0].features;
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

  onItemSelected(int index) {
    setState(() {
      productsList[index].quantity = 1;
      selectedProducts.add(productsList[index]);

      prefs.setString(
          SharedPrefKey.SELECTEDPRODUCTS, json.encode(selectedProducts));
    });

    print(index.toString() +
        " POSITION-------SELECTED"); /*json.encode(mBookingSubmitModel)*/
  }
}