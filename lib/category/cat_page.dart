import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scisco/HomePage/QuotesList.dart';
import 'package:scisco/HomePage/my_orders.dart';
import 'package:scisco/HomePage/my_orders_detail.dart';
import 'package:scisco/category/BrandByProduct.dart';
import 'package:scisco/category/brand.dart';
import 'package:scisco/category/cat_by_supercat.dart';
import 'package:scisco/models/CategoriesListDatum.dart';
import 'package:scisco/models/CategoriesListModel.dart';
import 'package:scisco/models/ProductsList.dart';
import 'package:scisco/models/SliderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../Api/BaseApi.dart';
import '../Utils/CommanStrings.dart';
import '../Utils/CommonLogic.dart';
import '../app_theme.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoriesListDatum> categoriesList = List();
  List<ListElement> sliderList = List();
  SharedPreferences prefs;
  List<ProductsList> selectedProducts = new List();

  String cartCount = '0';
  @override
  void initState() {
    super.initState();
    getCategoriesList();
    initPrefs();
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
        cartCount = selectedProducts.length.toString();
        // print("zxcv" + selectedProducts.length.toString());
      });
    } else {
      setState(() {
        cartCount = '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          "GLASMIC",
          style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w800),
        ),

        // Image.asset("assets/images/glasmic.png",height: 55,width: 100,),
        titleSpacing: 55.0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        brightness: Brightness.light,

        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 6.0, top: 3),
            child: Stack(
              children: [
                IconButton(
                    color: Colors.black,
                    iconSize: 35,
                    icon: ImageIcon(
                      AssetImage('assets/icons/cart1.png'),
                    ),
                    onPressed: () {
                      // if (isCartCount) {
                      //   Navigator.pushNamed(context, PageRoutes.restviewCart)
                      //       .then((value) {
                      //     getCartCount_new();
                      //   });
                      // } else {
                      //   Toast.show('No Value in the cart!', context,
                      //       duration: Toast.LENGTH_SHORT);
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => QuotesListPage()))
                          .then((value) => initPrefs());
                    }),
                Positioned(
                    right: 25,
                    top: 5,
                    child: Visibility(
                      // visible: isCartCount,
                      child: CircleAvatar(
                        minRadius: 4,
                        maxRadius: 8,
                        backgroundColor: AppTheme.appColor,
                        child: Text(
                          cartCount,
                          // '${selectedProducts.length}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child:   Container(
              height: 150.0,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0.7,
                child: CarouselSlider(
                  options: CarouselOptions(

                      autoPlay: true,

                      viewportFraction: 1.0,

                  ),
                  items:List.generate(sliderList.length, (index) =>  Image.network(sliderList[index].image,height: 200,fit: BoxFit.fill,isAntiAlias: true,))

                ),
              ),
            ),
            // child: ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image(
            //     image: AssetImage("assets/images/medical_equipment.jpg"),
            //   ),
           // ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 0, left: 5, right: 5),
              child: categoriesList.length > 0
                  ? GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 9 / 10,
                      crossAxisCount: 2,
                      primary: false,
                      children: List.generate(categoriesList.length, (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CategoryBySuperCategory(
                                    id: categoriesList[index].id,
                                    page_name:
                                        categoriesList[index].supercategory,
                                  );
                                },
                              ),
                            ).then((value) => initPrefs());
                            // if (categoriesList[index].page_name == "brand")
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return Brand(
                            //             id: categoriesList[index].id,
                            //             page_name: categoriesList[index]
                            //                 .supercategory);
                            //       },
                            //     ),
                            //   ).then((value) => initPrefs());
                            // else if (categoriesList[index].page_name ==
                            //     "categorybysupercategory")
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return CategoryBySuperCategory(
                            //           id: categoriesList[index].id,
                            //           page_name:
                            //               categoriesList[index].supercategory,
                            //         );
                            //       },
                            //     ),
                            //   ).then((value) => initPrefs());
                            // else if (categoriesList[index].page_name ==
                            //     "brandbyproduct")
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return BrandByProduct(
                            //           id: categoriesList[index].id,
                            //           page_name:
                            //               categoriesList[index].supercategory,
                            //         );
                            //       },
                            //     ),
                            //   ).then((value) => initPrefs());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Image.network(
                                    categoriesList[index].image,
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    width: MediaQuery.of(context).size.height *
                                        0.10,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Text(
                                    categoriesList[index].supercategory,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        fontFamily: AppTheme.fontName),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }))
                  : noItemHome()),
        ],
      ),
    );
  }

  Future<Response> getCategoriesList() async {
    await sliderApi();
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
          "supercategory": "supercategory",
        });
        Response response =
            await baseApi.dio.post(supercategoriesURL, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var categoreisListModel = CategoriesListModel.fromJson(parsed);

          if (categoreisListModel.error == "1") {
            setState(() {
              categoriesList = categoreisListModel.data;
            });
          } else {
            String errorMsg = categoreisListModel.error_msg;
          }
        }

        return response;
      } catch (e) {
        print("RESPONSE NEwBooking:" + e.toString());
        progressDialog.dismiss();

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> sliderApi() async {
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
        Response response =
        await baseApi.dio.get(sliderUrl);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var slider = SliderModel.fromMap(parsed);

          if (slider.error == "1") {
            setState(() {
              sliderList = slider.list;
            });
          } else {
            String errorMsg = slider.errorMsg;
          }
        }

        return response;
      } catch (e) {
        print("RESPONSE NEwBooking:" + e.toString());
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
                fit: BoxFit.cover,
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