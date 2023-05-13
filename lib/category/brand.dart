import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/QuotesList.dart';
import 'package:scisco/HomePage/home_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/models/BrandListDatum.dart';
import 'package:scisco/models/BrandListModel.dart';
import 'package:scisco/models/ProductsList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class Brand extends StatefulWidget {

  const Brand({
    Key key,
    this.id,
    this.page_name,
  }) : super(key: key);
  final String id;
  final String page_name;
  @override
  _BrandState createState() => _BrandState(this.id,this.page_name);
}

class _BrandState extends State<Brand> {

   String id;
   String page_name;
  _BrandState(this.id,this.page_name);
  List<BrandListDatum> brandList = List();
   SharedPreferences prefs;
   List<ProductsList> selectedProducts = new List();

   String cartCount = '0';

   @override
  void initState(){

    super.initState();
    getBrandList();
    initPrefs();
  }

   void initPrefs() async {
     prefs = await SharedPreferences.getInstance();

     if(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS) != null &&
         prefs.getString(SharedPrefKey.SELECTEDPRODUCTS).isNotEmpty) {
       setState(() {
         // print("abcd"+json.decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS)).toString());
         selectedProducts = json.decode(prefs.getString(SharedPrefKey.SELECTEDPRODUCTS))
             .map<ProductsList>((json) => ProductsList.fromJson(json)).toList();
         cartCount = selectedProducts.length.toString();
         // print("zxcv" + selectedProducts.length.toString());
       });
     } else {
       setState(() {
         cartCount = '0';
       });
     }

   }

   Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          page_name,
          style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w800
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.white,
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              QuotesListPage())).then((value) =>
                          initPrefs()
                      );
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
                            color: Colors.white,),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: brandList.length > 0
              ? GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 20.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 2 / 2.8,
              crossAxisCount: 2,
              primary: false,
              children: List.generate(brandList.length, (index) {
                return
                  InkWell(
                    onTap: (){

                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyHomePage(
                              id: brandList[index].id,
                              superCategoryName: brandList[index].supercategory,
                              pageName: "brandbyproduct",
                            );
                          },
                        ),
                      ).then((value) =>
                         initPrefs()
                     );

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
                              brandList[index].image,
                              height: MediaQuery.of(context).size.height*0.15,
                              width: MediaQuery.of(context).size.height*0.15,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Text(
                              brandList[index].supercategory,
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
                  )
                ;
              }))
              : noItemHome()),
    );
  }
  Future<Response> getBrandList() async {
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
          "brand": "brand",
        });
        Response response = await baseApi.dio.post(brandURL, data: body);
        progressDialog.dismiss();

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString() + body);

          var brandisListModel = BrandListModel.fromJson(parsed);

          if (brandisListModel.error == "1") {
            setState(() {
              brandList = brandisListModel.data;
            });
          } else {
            String error_msg = brandisListModel.error_msg;
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


class noItemHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery
        .of(context)
        .size;

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
