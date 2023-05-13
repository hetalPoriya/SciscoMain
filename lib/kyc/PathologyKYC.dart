import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/components/rounded_button.dart';
import 'package:scisco/components/text_field_container.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../navigation_home_screen.dart';

class PathologyKYC extends StatefulWidget {
  @override
  _PathologyKYCState createState() => _PathologyKYCState();
}

class _PathologyKYCState extends State<PathologyKYC> {
  final _panNoCtrl = TextEditingController();

  List<File> fileitems = List<File>();
  List<String> fileitemsStr = List<String>();
  List<dynamic> fileitemsServer = List<dynamic>();

  var _aadharFile;
  var _registrationFile;
  SharedPreferences prefs;

  @override
  void initState() {
    initprefs();
    super.initState();
  }

  initprefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update KYC",
          style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w800),
        ),

        // Image.asset("assets/images/glasmic.png",height: 55,width: 100,),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Update KYC for Hospital",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
              child: TextField(
                controller: _panNoCtrl,
                keyboardType: TextInputType.name,
                cursorColor: AppTheme.nearlyBlack,
                decoration: InputDecoration(
                  hintText: "PAN Card",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.9,
              child: Text(
                "Upload your Aadhar",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                    child: Row(
                  children: [
                    _aadharFile != null
                        ? Stack(children: <Widget>[
                            Container(
                              height: size.width / 1.50,
                              width: size.width / 1.125,
                              child:
                                  Image.file(_aadharFile, fit: BoxFit.contain),
                            ),
                          ])
                        : Stack(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(
                                    AppBar().preferredSize.height),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  padding: EdgeInsets.only(
                                      left: size.width / 2.5,
                                      right: size.width / 2.5,
                                      top: size.width / 5,
                                      bottom: size.width / 5),
                                  child: Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                ),
                                onTap: () {
                                  _showSelectionDialog(context, "aadhar");
                                },
                              ),
                            ],
                          ),
                  ],
                ))),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.9,
              child: Text(
                "Upload your Registration",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                    child: Row(
                  children: [
                    _registrationFile != null
                        ? Stack(children: <Widget>[
                            Container(
                              height: size.width / 1.50,
                              width: size.width / 1.125,
                              child: Image.file(_registrationFile,
                                  fit: BoxFit.contain),
                            ),
                          ])
                        : Stack(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(
                                    AppBar().preferredSize.height),
                                child: DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  padding: EdgeInsets.only(
                                      left: size.width / 2.5,
                                      right: size.width / 2.5,
                                      top: size.width / 5,
                                      bottom: size.width / 5),
                                  child: Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                ),
                                onTap: () {
                                  _showSelectionDialog(context, "registration");
                                },
                              ),
                            ],
                          ),
                  ],
                ))),
            RoundedButton(
              text: "Submit KYC",
              color: AppTheme.appColor,
              press: () {
                if (_panNoCtrl.text.toString().isEmpty) {
                  _showMyDialog(context, "Please Enter Pan Number");
                } else if (_aadharFile == null) {
                  _showMyDialog(context, "Please Upload your Aadhar");
                } else if (_registrationFile == null) {
                  _showMyDialog(context, "Please Upload your Registration");
                } else {
                  submitKYCReq();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Response> submitKYCReq() async {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    try {
      BaseApi baseApi = new BaseApi();

      String aadharString = _aadharFile.path.split('/').last;
      String registrationString = _registrationFile.path.split('/').last;
      Map<String, dynamic> formData = {
        "user_id": prefs.getString(SharedPrefKey.USERID),
        "categories": prefs.getString(SharedPrefKey.CATEGORIES),
        "pan": _panNoCtrl.text.toString(),
      };

      // profileImage
      var formDatareq = FormData.fromMap(formData);

      //[4] ADD IMAGE TO UPLOAD
      if (_aadharFile != null) {
        var aadharImageFile = await MultipartFile.fromFile(_aadharFile.path,
            filename: aadharString,
            contentType: MediaType("image", aadharString));

        formDatareq.files.add(MapEntry("aadhar_card_upload", aadharImageFile));
      }
      if (_registrationFile != null) {
        var registrationImageFile = await MultipartFile.fromFile(
            _registrationFile.path,
            filename: registrationString,
            contentType: MediaType("image", registrationString));

        formDatareq.files
            .add(MapEntry("registration_upload", registrationImageFile));
      }
      Response response =
          await baseApi.dio.post(submitUserKyc, data: formDatareq);

      if (response != null) {
        // List<dynamic> body = jsonDecode(response.data);

        final parsed = json.decode(response.data).cast<String, dynamic>();
        print("RESPOONSE:" + parsed.toString());

        String error = parsed["error"].toString();

        if (error == "1") {
          progressDialog.dismiss();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(SharedPrefKey.ISKYCDONE, true);

          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NavigationHomeScreen();
                },
              ),
            );
          });
        } else {
          progressDialog.dismiss();
          String error_msg = parsed["error_msg"].toString();
          _showMyDialog(context, error_msg);
        }
      }

      // return response;
    } catch (e) {
      print("RESPOONSE:" + e.toString());
      progressDialog.dismiss();

      // displayToast("Something went wrong", context);
      return null;
    }
  }

  Future<void> _showSelectionDialog(BuildContext context, String imageType) {
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
                        captureImage(ImageSource.gallery, imageType);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        captureImage(ImageSource.camera, imageType);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> captureImage(ImageSource imageSource, String fileType) async {
    try {
      final imageFile =
          await ImagePicker.platform.pickImage(source: imageSource);
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
        if (fileType == "aadhar") {
          _aadharFile = compressedImage;
        } else if (fileType == "registration") {
          _registrationFile = compressedImage;
        }
        // fileitemsServer.add(imageFile.readAsBytesSync());
      });
    } catch (e) {
      print(e);
    }
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
}
