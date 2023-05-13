import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/LoginSignup/Login/login_screen.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:scisco/models/myordersrespo.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/PersonalVehicleDetails.dart';
import 'package:scisco/models/SelectedVehicleEquipment.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';
import 'package:scisco/models/VechicleEquipmentModel.dart';
import 'package:scisco/models/VechicleTypeDatum.dart';
import 'package:scisco/models/MyProfileModel.dart';
import 'package:scisco/models/VechicleTypeModel.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation_home_screen.dart';

class VehicleDetailsUpdate extends StatefulWidget {
  @override
  _VehicleDetailsUpdateState createState() => _VehicleDetailsUpdateState();
}

class _VehicleDetailsUpdateState extends State<VehicleDetailsUpdate>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<VehicleDetailsUpdate> {
  int _currentStep = 0;
  int _MycurrentStep = 0;
  int _selectedChipVal = 1;
  bool stepercomplete = false;
  StepperType stepperType = StepperType.horizontal;
  var _imageFileServer;
  var _imageFile;
  var _imageFiledlFront;
  var _imageFiledlBack;
  var _imageFileVechicleReg;
  var _imageFileInsurance;
  String _selectedLocation; // Option 2
  String _selecteEquipmentType; // Option 2
  bool _isChecked; // Option 2
  VechicleTypeDatum _selectedVehicleType; // Option 2
  AnimationController animationController;

  List<VechicleTypeDatum> items = List<VechicleTypeDatum>();
  List<SelectedVehicleEquipment> selectedVehicleEquip = List<
      SelectedVehicleEquipment>();
  List<VechicleEquipmentDatum> itemsVehiclequipmentModel =
  List<VechicleEquipmentDatum>();
  List<String> itemsVehiclequipmentModelStr =
  List<String>();
  List<String> itemsStr = List<String>();
  var _itemsDatum;
  List _selecteCategorys = List();
  List<String> selectedEquipmentVechicle = List();
  ScrollController _controller;
  List<Item> indexList = new List();
  var selectedDate = new DateTime.now();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _mobileNumCtrl = TextEditingController();
  final _emailidCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _subUrbCtrl = TextEditingController();
  final _postCodeCtrl = TextEditingController();
  final _dateOfBirthCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _abnCtrl = TextEditingController();
  final _vehicleHeightCtrl = TextEditingController();
  final _cargoHeightCtrl = TextEditingController();
  final _cargoWidthCtrl = TextEditingController();
  final _cargolenghtCtrl = TextEditingController();
  final _bankAcNameCtrl = TextEditingController();
  final _bsbCtrl = TextEditingController();
  final _accountNumCtrl = TextEditingController();
  int index = 0;

  double _latitude = 0;
  double _longitude = 0;
  int tag = 1;
  List<String> options = [
    'One', 'Two', 'Three'
  ];

  String _firstName = "";
  String _lastName = "";
  String _emailAddress = "";
  String _mobileNumber = "";
  String _dob = "";
  String _postCode = "";
  String _address = "";
  String _subUrb = "";
  String _driverImage = "";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    // get_driver_personal_vehicle();
    fetch_all_vehicle_equipment();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return
      new WillPopScope(
          onWillPop: () {
            _willPopCallback();
          },
          child:
          Scaffold(
            appBar:
            AppBar(
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: AppTheme.textcolor, //change your color here
              ),
              title: Text(
                "Vehicle Details",
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
              scrollDirection: Axis.vertical,

              child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 40, right: 40, top: 0, bottom: 10),
                              child: Text("Type of vehicle",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AppTheme.fontName)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 0, bottom: 10),
                            child: Container(
                              width: size.width * 0.9,
                              height: size.height * 0.08,
                              decoration: BoxDecoration(
                                color: AppTheme.chipBackground,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: DropdownButtonHideUnderline(

                                key:UniqueKey(),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: DropdownButton(

                                      hint: Text(
                                        'choose',
                                        style:
                                        TextStyle(
                                            fontFamily: AppTheme.fontName),
                                      ),
                                      // Not necessary for Option 1
                                      value: items.length > 0
                                          ? items[this.index]
                                          : _selectedVehicleType,
                                      // items.length>0?items[index]:_selectedVehicleType,
                                      onChanged: (VechicleTypeDatum pt) {
                                        setState(() {
                                          _selectedLocation = pt.id;

                                          index = items.indexOf(pt);
                                          print(index.toString()+" SELECTEDINDEX");
                                        });
                                      },
                                      items: items.map((VechicleTypeDatum pt) {
                                        return DropdownMenuItem(
                                          child: new Text(pt.title),
                                          value: pt,
                                        );
                                      }).toList(),
                                    ),
                                  )),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 45, right: 20, top: 10, bottom: 0),
                              child: Text(
                                  "How many man (including yourself) in daily operation",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppTheme.fontName)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              height: 40,
                              child:

                              ChipsChoice<int>.single(
                                value: tag,
                                onChanged: (val) => setState(() => tag = val),
                                choiceItems: C2Choice.listFrom<int, String>(
                                  source: options,
                                  value: (i, v) => i,
                                  label: (i, v) => v,
                                ),
                              )

                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 40, right: 40, top: 0, bottom: 10),
                              child: Text("Equipment in your vehicle",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppTheme.dark_grey,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: AppTheme.fontName)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),


                          Padding(
                            padding: EdgeInsets.only(
                                left: 40, right: 40, top: 0, bottom: 0),
                            child: Container(
                              height: size.height / 1.8,
                              child: FutureBuilder<bool>(
                                future: getData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox();
                                  } else {
                                    return itemsVehiclequipmentModel.length > 0
                                        ? ListView(
                                      controller: _controller,
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0),
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      children: List<Widget>.generate(
                                        itemsVehiclequipmentModel.length,
                                            (int index) {
                                          final int count =
                                              itemsVehiclequipmentModel
                                                  .length;
                                          final Animation<double>
                                          animation = Tween<double>(
                                              begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve:
                                                  Curves.fastOutSlowIn),
                                            ),
                                          );
                                          animationController.forward();
                                          return HomeItemListView(
                                            animation: animation,
                                            animationController:
                                            animationController,
                                            moveitemDatum:
                                            itemsVehiclequipmentModel[
                                            index],
                                            cardselected:
                                            indexList[index].isSelected,
                                            callBack: () {
                                              setState(() {
                                                /*for (int i = 0;
                                                        i < indexList.length;
                                                        i++) {
                                                      if (i == index) {
                                                        indexList[i]
                                                            .isSelected = true;
                                                      } else {
                                                        indexList[i]
                                                            .isSelected = false;
                                                      }
                                                    }*/
                                                // if (indexList[index]
                                                //     .isSelected = false)
                                                indexList[index].isSelected =
                                                !indexList[index].isSelected;
                                                // else
                                                //   indexList[index]
                                                //       .isSelected = false;

                                                onItemSelected(index);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    )
                                        : loadingLayoutSlider();
                                  }
                                },
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 15
                            ),
                            child: Text('Vehicle height', style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontName),),
                          ),

                          TextFieldContainer(
                            child: TextField(
                              controller: _vehicleHeightCtrl,
                              // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                              cursorColor: AppTheme.nearlyBlack,
                              decoration: InputDecoration(
                                hintText: "Vehicle height (in meters)",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 15
                            ),
                            child: Text('Cargo area height', style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontName),),
                          ),

                          TextFieldContainer(
                            child: TextField(
                              controller: _cargoHeightCtrl,
                              // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                              cursorColor: AppTheme.nearlyBlack,
                              decoration: InputDecoration(
                                hintText: "Cargo area height (in meters)",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 15
                            ),
                            child: Text('Cargo area Width', style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontName),),
                          ),

                          TextFieldContainer(
                            child: TextField(
                              controller: _cargoWidthCtrl,
                              // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                              cursorColor: AppTheme.nearlyBlack,
                              decoration: InputDecoration(
                                hintText: "Cargo area Width (in meters)",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 15
                            ),
                            child: Text('Cargo area length', style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontName),),
                          ),

                          TextFieldContainer(
                            child: TextField(
                              controller: _cargolenghtCtrl,
                              // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],

                              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                              cursorColor: AppTheme.nearlyBlack,
                              decoration: InputDecoration(
                                hintText: "Cargo area length (in meters)",
                                border: InputBorder.none,
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 10,
                          ),


                        ],
                      )
                  )

              ),

            ),
            bottomNavigationBar:
            Visibility(
                visible: true,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height * 0.12,
                  color: AppTheme.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                        color: AppTheme.buttoncolor,
                        text: "Update",
                        press: () {
                          update_driver_personal_vehicle();
                        },
                      ),
                    ],
                  ),
                )),
          ));
  }

  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
  }

  onItemSelected(int index) {
    setState(() {
      // selectedlabourType = items[index].title;
      // selectedlabourTypeImg = items[index].image_url;
      // selectedlabourTypeId = items[index].id;
      // selectedlabourTypePrice = items[index].price;

      if (indexList[index].isSelected) {
        selectedEquipmentVechicle.add(itemsVehiclequipmentModel[index].id);
      } else {
        selectedEquipmentVechicle.remove(itemsVehiclequipmentModel[index].id);
      }

      print(index.toString() + " POSITION");
    });
  }

  onChipSelected(int index) {
    setState(() {
      // selectedlabourType = items[index].title;
      // selectedlabourTypeImg = items[index].image_url;
      // selectedlabourTypeId = items[index].id;
      // selectedlabourTypePrice = items[index].price;

      print(index.toString() + " POSITION");
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<Response> fetch_all_mancategory_type() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Response response = await baseApi.dio.post(mancategory_typeUrl);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var vehicleTypeModel = VehicleTypeModel.fromJson(parsed);

          if (vehicleTypeModel.error == "1") {
            setState(() {
              items = vehicleTypeModel.all_mancat_type;

              for (int i = 0; i < items.length; i++) {
                if (items[i].id.toString() == _selectedLocation) {
                  this.index = i;
                  // break;
                }
                // _selectedLocation = items[i].id.toString();

              }

              print(this.index.toString()+" Categories");
            });
          } else {
            String error_msg = vehicleTypeModel.error_msg;
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


  Future<Response> fetch_all_vehicle_equipment() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Response response = await baseApi.dio.post(all_vehicleEquipmentUrl);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var vehicleEquipmentModel = VechicleEquipmentModel.fromJson(parsed);

          if (vehicleEquipmentModel.error == "1") {
            setState(() {
              itemsVehiclequipmentModel =
                  vehicleEquipmentModel.all_vehicle_equipment;

              for (int i = 0; i < itemsVehiclequipmentModel.length; i++) {
                indexList.add(new Item(isSelected: false));
                itemsVehiclequipmentModelStr.add(
                    vehicleEquipmentModel.all_vehicle_equipment[i].id);
              }
            });

            get_driver_personal_vehicle();

          } else {
            String error_msg = vehicleEquipmentModel.error_msg;
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


  tapped(int step) {
    setState(() => _currentStep = step);
  }


  void _showMyDialog(BuildContext context,
      String msg,) {
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

  cancel() {
    if (_currentStep == 0) {
      _MycurrentStep = 0;
    } else if (_currentStep == 1) {
      _MycurrentStep = 1;
    } else if (_currentStep == 2) {
      _MycurrentStep = 2;
    }
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }


  Future<Response> get_driver_personal_vehicle() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "driver_id": prefs.getString(SharedPrefKey.USERID),

        });
        Response response = await baseApi.dio.post(
            get_driver_personal_vehicleURL, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          progressDialog.dismiss();
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE:" + parsed.toString());

          var respo = PersonalVehicleDetails.fromJson(parsed);

          if (respo.error == "1") {
            setState(() {
              if (itemsVehiclequipmentModelStr.length > 0) {
                for (int i = 0; i < respo.vehicle_equipment.length; i++) {
                  selectedEquipmentVechicle.add(respo.vehicle_equipment[i].id);

                  if (itemsVehiclequipmentModelStr.contains(
                      respo.vehicle_equipment[i].id)) {
                    indexList[i].isSelected = true;
                  }
                }
              }
              selectedVehicleEquip.addAll(respo.vehicle_equipment);


              tag = respo.how_many_men;
              _selectedLocation = respo.vehicle_type;

              _vehicleHeightCtrl.text = respo.vehicle_height;
              _cargoHeightCtrl.text = respo.cargo_area_height;
              _cargoWidthCtrl.text = respo.cargo_area_width;
              _cargolenghtCtrl.text = respo.cargo_area_lenght;
            });
            fetch_all_mancategory_type();

          } else {
            String error_msg = respo.error_msg;
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

  Future<Response> fdget_driver_personal_vehicle() async {
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

        });
        Response response = await baseApi.dio.post(
            get_driver_personal_vehicleURL, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE " + parsed);

          var bankdetailrespo = CommonRespoModel.fromJson(parsed);
          progressDialog.dismiss();

          if (bankdetailrespo.error == "1") {
            setState(() {
              // for(int i=0; i<itemsVehiclequipmentModel.length;i++){
              //   if(itemsVehiclequipmentModel.contains(bankdetailrespo.vehicle_equipment[i].id)){
              //     indexList[i].isSelected = true;
              //   }
              //
              // }
              // selectedVehicleEquip.addAll(bankdetailrespo.vehicle_equipment);

              // tag = bankdetailrespo.how_many_men;
              // _vehicleHeightCtrl.text = bankdetailrespo.vehicle_height;
              // _cargoHeightCtrl.text = bankdetailrespo.cargo_area_height;
              // _cargoWidthCtrl.text = bankdetailrespo.cargo_area_width;
              // _cargolenghtCtrl.text = bankdetailrespo.cargo_area_lenght;

            });
          } else {
            String error_msg = bankdetailrespo.error_msg;
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

  Future<Response> update_driver_personal_vehicle() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        var body = json.encode({
          "driver_id": prefs.getString(SharedPrefKey.USERID),
          "vehicle_type": _selectedLocation,
          "how_many_men": tag.toString(),
          "vehicle_equipment": jsonEncode(selectedEquipmentVechicle),
          "vehicle_height": _vehicleHeightCtrl.text.toString(),
          "cargo_area_height": _cargoHeightCtrl.text.toString(),
          "cargo_area_width": _cargoWidthCtrl.text.toString(),
          "cargo_area_lenght": _cargolenghtCtrl.text.toString(),

        });
        print("RESPOONSE:" + body.toString());


        Response response = await baseApi.dio.post(
            update_driver_personal_vehicleURL, data: body);
        progressDialog.dismiss();
        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var commonRespo = CommonRespoModel.fromJson(parsed);

          if (commonRespo.error == "1") {
            _showSuccessMyDialog(context, commonRespo.error_msg);
          } else {
            String error_msg = commonRespo.error_msg;
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var formatter = new DateFormat('yyyy-MM-dd');

        _dateOfBirthCtrl.text = formatter.format(selectedDate);
      });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    Position location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = location.latitude;
    _longitude = location.longitude;


    return await Geolocator.getCurrentPosition();
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}

typedef void MyCallback(int foo);

void _showSuccessMyDialog(BuildContext context,
    String msg,) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Update Vehicle Details"),
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

class HomeItemListView extends StatefulWidget {
  const HomeItemListView({
    Key key,
    this.moveitemDatum,
    this.callBack,
    this.animationController,
    this.animation,
    this.cardselected,
  }) : super(key: key);

  final VechicleEquipmentDatum moveitemDatum;
  final VoidCallback callBack;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final bool cardselected;

  @override
  _HomeItemListViewState createState() =>
      _HomeItemListViewState(
          moveitemDatum: moveitemDatum,
          callBack: callBack,
          animationController: animationController,
          animation: animation,
          cardselected: cardselected);
}

class _HomeItemListViewState extends State<HomeItemListView> {
  _HomeItemListViewState({this.moveitemDatum,
    this.callBack,
    this.animationController,
    this.animation,
    this.cardselected});

  VechicleEquipmentDatum moveitemDatum;
  VoidCallback callBack;
  AnimationController animationController;
  Animation<dynamic> animation;
  bool cardselected = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 40 * (1.0 - animation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 4.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Card(
                        shape: widget.cardselected
                            ? new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: AppTheme.appColor, width: 2.0),
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
                            ? AppTheme.white
                            : AppTheme.white,
                        elevation: 2.0,
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
                                height: size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding:
                                        EdgeInsets.only(left: 20, top: 5),
                                        child: Row(
                                          children: [
                                            Text(moveitemDatum.name,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: widget.cardselected
                                                        ? AppTheme.darkerText
                                                        : AppTheme.darkerText,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily:
                                                    AppTheme.fontName)),
                                          ],
                                        )),
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
// =============================================================================

///
/// Filter entity
///
class Filter {
  ///
  /// Displayed label
  ///
  final String label;

  ///
  /// The displayed icon when selected
  ///
  final IconData icon;

  const Filter({this.label, this.icon});
}

// =============================================================================

///
/// The filter widget
///
class ChipsFilter extends StatefulWidget {
  ///
  /// The list of the filters
  ///
  final List<Filter> filters;

  ///
  /// The default selected index starting with 0
  ///
  final int selected;
  final VoidCallback callback;

  ChipsFilter({Key key, this.filters, this.selected, this.callback})
      : super(key: key);

  @override
  _ChipsFilterState createState() => _ChipsFilterState();
}

class _ChipsFilterState extends State<ChipsFilter> {
  ///
  /// Currently selected index
  ///
  ///
  _ChipsFilterState({this.selectedIndex,
    this.callback
  });

  int selectedIndex;
  final VoidCallback callback;

  @override
  void initState() {
    // When [widget.selected] is defined, check the value and set it as
    // [selectedIndex]
    if (widget.selected != null &&
        widget.selected >= 0 &&
        widget.selected < widget.filters.length) {
      this.selectedIndex = widget.selected;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: this.chipBuilder,
        itemCount: widget.filters.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  ///
  /// Build a single chip
  ///
  Widget chipBuilder(context, currentIndex,) {
    Filter filter = widget.filters[currentIndex];
    bool isActive = this.selectedIndex == currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = currentIndex;
          widget.callback;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.appColor : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isActive)
              Container(
                margin: EdgeInsets.only(right: 5, left: 5),

              ),
            Text(
              filter.label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppTheme.white : Colors.black,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  bool isSelected;

  Item({this.isSelected});
}
