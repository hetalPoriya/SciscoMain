import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/home_screen.dart';
import 'package:scisco/HomePage/my_orders_detail.dart';
import 'package:scisco/LoginSignup/Login/forgetpass_screen.dart';
import 'package:scisco/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/components/already_have_an_account_acheck.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/kyc/ConsumerKYC.dart';
import 'package:scisco/kyc/DealerKYC.dart';
import 'package:scisco/kyc/HospitalKYC.dart';
import 'package:scisco/kyc/PathologyKYC.dart';
import 'package:scisco/models/CityResponseModel.dart';
import 'package:scisco/models/LoginRespoModel.dart';
import 'package:scisco/models/StatesResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_theme.dart';
import '../../navigation_home_screen.dart';
import 'components/background.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  List<String> selectedProducts = new List();

  SignUpScreen({
    Key key,
    this.selectedProducts,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState(selectedProducts);
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedState,
      selectedCity,
      selectedCategories,
      selectedStateId,
      selectedCityId;
  List<String> selectedProducts = new List();

  List<String> categoriesList = ['Dealer', 'Hospital', 'Pathology', 'Consumer'];
  List<String> stateList = [];
  List<String> citiesList = [];

  List<StateListModel> stateListModel = [];
  List<CityListModel> cityListModel = [];

  final _emailAddressCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _whatsappMobileCtrl = TextEditingController();
  final _organisationCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  _SignUpScreenState(this.selectedProducts);

  @override
  void initState() {
    super.initState();
    getStates();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: size.height * 0.03),
              /*SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),*/

              Image.asset(
                "assets/images/glasmic.png",
                fit: BoxFit.contain,
                height: 100,
                width: 200,
                alignment: Alignment.center,
              ),
              SizedBox(height: size.height * 0.03),
              // Name
              TextFieldContainer(
                child: TextField(
                  controller: _nameCtrl,
                  keyboardType: TextInputType.name,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Email TextField
              TextFieldContainer(
                child: TextField(
                  controller: _emailAddressCtrl,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Your Email Id",
                    border: InputBorder.none,
                  ),
                ),
              ),
              //Mobile Number
              TextFieldContainer(
                child: TextField(
                  controller: _mobileCtrl,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    counterText: "",
                    border: InputBorder.none,
                  ),
                ),
              ),
              //Whatsapp Number
              TextFieldContainer(
                child: TextField(
                  controller: _whatsappMobileCtrl,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Whatsapp Number",
                    counterText: "",
                    border: InputBorder.none,
                  ),
                ),
              ),
              //Password TextField
              TextFieldContainer(
                child: TextField(
                  inputFormatters: [
                    //     new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,;={}()<>]')),
                  ],
                  controller: _passwordCtrl,
                  obscureText: !_passwordVisible,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //Confirm Password TextField
              TextFieldContainer(
                child: TextField(
                  inputFormatters: [
                    //new BlacklistingTextInputFormatter(new RegExp('[\\.|\\,;={}()<>]')),
                  ],
                  controller: _confirmPasswordCtrl,
                  obscureText: !_confirmPasswordVisible,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //Spinner State
              TextFieldContainer(
                child: DropdownButton<String>(
                  value: selectedState,
                  hint: Text("Select State"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  onChanged: (String data) {
                    setState(() {
                      selectedState = data;
                      selectedStateId = stateListModel
                          .elementAt(stateList.indexOf(selectedState))
                          .id;
                      getCities(selectedStateId);
                      print(selectedStateId);
                    });
                  },
                  items:
                      stateList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              //Spinner City
              TextFieldContainer(
                child: DropdownButton<String>(
                  value: selectedCity,
                  hint: Text("Select City"),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  onChanged: (String data) {
                    setState(() {
                      selectedCity = data;
                      selectedCityId = cityListModel
                          .elementAt(citiesList.indexOf(selectedCity))
                          .id;
                    });
                  },
                  items:
                      citiesList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              // //Spinner Categories
              // TextFieldContainer(
              //   child: DropdownButton<String>(
              //     value: selectedCategories,
              //     hint: Text("Select Categories"),
              //     isExpanded: true,
              //     icon: Icon(Icons.arrow_drop_down),
              //     iconSize: 24,
              //     elevation: 16,
              //     style: TextStyle(color: Colors.black, fontSize: 18),
              //     underline: Container(
              //       height: 0,
              //       color: Colors.black,
              //     ),
              //     onChanged: (String data) {
              //       setState(() {
              //         selectedCategories = data;
              //       });
              //     },
              //     items: categoriesList
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //   ),
              // ),
              //Organisation
              TextFieldContainer(
                child: TextField(
                  controller: _organisationCtrl,
                  keyboardType: TextInputType.name,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Organisation(If Dealer, Laboratory or Hospital)",
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),

              RoundedButton(
                text: "SIGN UP",
                color: AppTheme.appColor,
                press: () {
                  if (_nameCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Name");
                  } else if (selectedState == null) {
                    _showMyDialog(context, "Please Select State");
                  } else if (citiesList != null &&
                      citiesList.isNotEmpty &&
                      selectedCity == null) {
                    _showMyDialog(context, "Please Select City");
                  } else if (_mobileCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Mobile Number");
                  } else if (_whatsappMobileCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Whatsapp Number");
                  } else if (_emailAddressCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Email Id");
                  } else if (!validateEmail(
                      _emailAddressCtrl.text.toString())) {
                    _showMyDialog(context, "Please Enter Valid email Id");
                  }
                  // else if (selectedCategories == null) {
                  //   _showMyDialog(context, "Please Select Category");
                  // }
                  else if (_passwordCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Password");
                  } else if (_confirmPasswordCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Confirm Password");
                  } else if (_confirmPasswordCtrl.text.toString() !=
                      _passwordCtrl.text.toString()) {
                    _showMyDialog(
                        context, "Password and Confirm Password is not same.");
                  } else {
                    loginreq();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyDialog(BuildContext context, String msg) {
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

  Future<Response> loginreq() async {
    bool isDeviceOnline = true;
    print(selectedProducts);
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));

      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();
        if (selectedProducts == null) {
          selectedProducts = new List();
        }
        var body = json.encode({
          "email": _emailAddressCtrl.text.toString(),
          "password": _passwordCtrl.text.toString(),
          "mobile": _mobileCtrl.text.toString(),
          "name": _nameCtrl.text.toString(),
          "state": selectedStateId,
          "city": selectedCityId,
          "whatsapp": _whatsappMobileCtrl.text.toString(),
          "organisation": _organisationCtrl.text.toString(),
          "categories": selectedCategories,
          "product_id": selectedProducts,
        });

        print(body.toString());

        Response response = await baseApi.dio.post(registerSubUrl, data: body);
        print("Response ${response}");

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var loginrespo = LoginRespoModel.fromJson(parsed);

          print('RE ${loginrespo.category}');
          if (loginrespo.error == "1") {
            progressDialog.dismiss();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(SharedPrefKey.ISLOGEDIN, true);
            prefs.setBool(SharedPrefKey.ISKYCDONE, loginrespo.kyc == "1");
            prefs.setString(SharedPrefKey.USERID, loginrespo.user_id);
            prefs.setString(SharedPrefKey.FIRSTNAME, loginrespo.name);
            prefs.setString(SharedPrefKey.LASTNAME, loginrespo.name);
            // prefs.setString(SharedPrefKey.CATEGORIES, loginrespo.category);
            prefs.setString(SharedPrefKey.WHATSAPP, loginrespo.whatsapp);
            prefs.setString(SharedPrefKey.EMAILID, loginrespo.email);
            prefs.setString(SharedPrefKey.MOBILENO, loginrespo.mobile);
            print('Order ${loginrespo.order_id}');
            setState(() {
/*              if(prefs.getBool(SharedPrefKey.ISLOGEDIN) != null) {
                String category = prefs.getString(SharedPrefKey.CATEGORIES);
                if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Dealer") {
                  print("category");
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new DealerKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Hospital") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new HospitalKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Pathology") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new PathologyKYC()));
                  });
                } else if (prefs.getBool(SharedPrefKey.ISLOGEDIN) &&
                    !prefs.getBool(SharedPrefKey.ISKYCDONE) && category == "Consumer") {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => new ConsumerKYC()));
                  });
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => new NavigationHomeScreen()));
                }
              } else {*/
              // if (loginrespo.order_id.isNotEmpty) {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(
              //           builder: (BuildContext context) => new MyOrdersDetail(
              //                 orderId: loginrespo.order_id,
              //               )),
              //       (route) => false);
              // } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new NavigationHomeScreen()),
                  (route) => false);
              //}
            });
          } else {
            progressDialog.dismiss();

            String error_msg = loginrespo.error_msg;
            _showMyDialog(context, error_msg);
          }
        }

        return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();

        // displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> getStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedState = null;
    selectedStateId = null;
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    try {
      BaseApi baseApi = new BaseApi();

      Response response = await baseApi.dio.post(statesSubUrl);

      if (response != null) {
        // List<dynamic> body = jsonDecode(response.data);

        final parsed = json.decode(response.data).cast<String, dynamic>();
        print("RESPOONSE:" + parsed.toString());
        progressDialog.dismiss();

        var stateRespo = StateResponseModel.fromJson(parsed);

        setState(() {
          stateListModel.clear();
          stateListModel.addAll(stateRespo.states);
          stateList.clear();
          for (StateListModel stateListModel in stateRespo.states) {
            stateList.add(stateListModel.name);
          }
        });
      }

      // return response;
    } catch (e) {
      print("RESPOONSE:" + e.toString());
      progressDialog.dismiss();

      // displayToast("Something went wrong", context);
      return null;
    }
  }

  Future<Response> getCities(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCity = null;
    selectedCityId = null;
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    try {
      BaseApi baseApi = new BaseApi();
      var body = json.encode({
        "state_id": id,
      });
      Response response = await baseApi.dio.post(citiesSubUrl, data: body);

      if (response != null) {
        // List<dynamic> body = jsonDecode(response.data);

        final parsed = json.decode(response.data).cast<String, dynamic>();
        print("RESPOONSE:" + parsed.toString());
        progressDialog.dismiss();

        var cityRespo = CityResponseModel.fromJson(parsed);

        setState(() {
          cityListModel.clear();
          cityListModel.addAll(cityRespo.cities);
          citiesList.clear();
          for (CityListModel cityListModel in cityRespo.cities) {
            citiesList.add(cityListModel.name);
          }
        });
      }

      // return response;
    } catch (e) {
      print("RESPOONSE:" + e.toString());
      progressDialog.dismiss();

      // displayToast("Something went wrong", context);
      return null;
    }
  }
}
