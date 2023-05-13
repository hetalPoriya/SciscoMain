import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scisco/Api/BaseApi.dart';
import 'package:scisco/HomePage/MyQuoteOrders.dart';
import 'package:scisco/HomePage/my_orders.dart';
import 'package:scisco/Utils/CommanStrings.dart';
import 'package:scisco/Utils/CommonLogic.dart';
import 'package:scisco/Utils/CustomLoader.dart';
import 'package:scisco/app_theme.dart';
import 'package:scisco/models/CommonRespoModel.dart';
import 'package:scisco/models/MyOrdersDatum.dart';
import 'package:scisco/models/MyOrdersDetailDatum.dart';
import 'package:scisco/models/VechicleEquipmentDatum.dart';
import 'package:scisco/models/myordersdetailrespo.dart';
import 'package:scisco/models/myordersrespo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../navigation_home_screen.dart';

class MyOrdersDetailPlaceOrder extends StatefulWidget {
  final String orderId;
  final String orderStatus;

  MyOrdersDetailPlaceOrder({
    Key key,
    this.orderId,
    this.orderStatus,
  }) : super(key: key);

  @override
  _MyOrdersDetailPlaceOrderState createState() => _MyOrdersDetailPlaceOrderState(orderId, orderStatus);
}

class _MyOrdersDetailPlaceOrderState extends State<MyOrdersDetailPlaceOrder>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MyOrdersDetailPlaceOrder> {
  AnimationController animationController;
  List<MyOrdersDetailDatum> myordersdatum = new List();
  String orderId;
  String status;
  TextEditingController _couponCodeController = new TextEditingController();
  TextEditingController _updateTransactionController = new TextEditingController();

  dynamic grandTotal = 0;
  dynamic transportationCharges = 0.0;
  dynamic discount_amount = 0;
  dynamic discount_grand_total = -1;
  dynamic gst = 0.0;
  String orderstatus = "";
  String promocodedata = "";
  _MyOrdersDetailPlaceOrderState(this.orderId, this.status);

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    my_orderdetailReq("");
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new WillPopScope( onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: AppTheme.textcolor, //change your color here
            ),
            title: Text(
              '#${orderId}',
              style: TextStyle(
                fontSize: 20,
                fontFamily: AppTheme.fontName,
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
            elevation: 0,
            backgroundColor: AppTheme.white,
          ),
          body:

          Stack(
              children: [

                Container(
                  height: size.height*0.80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: myordersdatum.length,
                    itemBuilder: (context, index) {
                      return
                        Container(

                            height:
                            myordersdatum[index].actualPrice.isNotEmpty  && myordersdatum[index].price != "0" && myordersdatum[index].clientType.toLowerCase() != 'Credit and fixed'.toLowerCase()?
                            size.height*0.26:
                                size.height * 0.2,
                            child: Card(
                              shape: new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: HexColor("#FFFFFF"), width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: HexColor("#FFFFFF"),
                              elevation: 4.0,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[

                                  Container(

                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: 10),
                                                height: size.height *0.15,
                                                width: size.height *0.15,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          myordersdatum[index].image,
                                                        ),
//                                AssetImage(gridItem.img),
                                                        fit: BoxFit.cover)),
                                              ),


                                              Column(children: [


                                                Container(

                                                  width: size.width*0.60,
                                                  child: Text(
                                                      '${myordersdatum[index].product_name}',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme.textcolor,
                                                          fontWeight: FontWeight.w800,
                                                          fontFamily: "WorkSans")),
                                                ),
                                                SizedBox(height: 5,),
                                                Container(

                                                  width: size.width*0.60,
                                                  child: Text(
                                                          myordersdatum[index].category != null?
                                                      'Category: ${myordersdatum[index].category}'
                                                      :
                                                      "Category: -",
                                                      textAlign: TextAlign.start,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppTheme.textcolor,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "WorkSans")),
                                                ),

                                                SizedBox(height: 5,),
                                                Container(

                                                  width: size.width*0.60,
                                                  child: Text(
                                                      'Sub Category: ${myordersdatum[index].supercategory_name}',
                                                      textAlign: TextAlign.start,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppTheme.textcolor,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "WorkSans")),
                                                ),
                                                SizedBox(height: 5,),
                                                Container(

                                                  width: size.width*0.60,
                                                  child: Text(
                                                      'Brand Name: ${myordersdatum[index].brand_name}',
                                                      textAlign: TextAlign.start,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppTheme.textcolor,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "WorkSans")),
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                  width: size.width*0.60,
                                                  child: Text(
                                                      'Quantity: ${myordersdatum[index].quantity}',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppTheme.textcolor,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "WorkSans")),
                                                ),
                                                SizedBox(height: 5,),
                                                orderstatus.toLowerCase() == "Partially Delivered".toLowerCase() ?
                                                Column(
                                                    children: [
                                                      Container(
                                                        width: size.width*0.60,
                                                        child: Text(
                                                            'Delivered Quantity: ${myordersdatum[index].deliverQuantity}',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.textcolor,
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: "WorkSans")),
                                                      ),
                                                      SizedBox(height: 5,),
                                                    ]
                                                )
                                                    :
                                                Wrap(),
                                                myordersdatum[index].actualPrice.isNotEmpty  && myordersdatum[index].price != "0" && myordersdatum[index].clientType.toLowerCase() != 'Credit and fixed'.toLowerCase()?
                                                Container(
                                                  width: size.width*0.60,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Price: ',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.textcolor,
                                                                fontWeight: FontWeight.w800,
                                                                fontFamily: "WorkSans"),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '₹${myordersdatum[index].actualPrice}',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),),
                                                        ],
                                                      ),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'GST: ',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.textcolor,
                                                                fontWeight: FontWeight.w800,
                                                                fontFamily: "WorkSans"),
                                                          ),

                                                          myordersdatum[index].gst.isNotEmpty?
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '${myordersdatum[index].gst}%',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),)
                                                              :
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '-  ',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Discount: ',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.textcolor,
                                                                fontWeight: FontWeight.w800,
                                                                fontFamily: "WorkSans"),
                                                          ),

                                                          myordersdatum[index].discount != null && myordersdatum[index].discount != '0' && myordersdatum[index].discount.isNotEmpty?
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '${myordersdatum[index].discount}%',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),)
                                                              :
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '-  ',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),),
                                                        ],
                                                      ),

                                                      myordersdatum[index].price.isNotEmpty?
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            'Total: ',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: AppTheme.textcolor,
                                                                fontWeight: FontWeight.w800,
                                                                fontFamily: "WorkSans"),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 20),
                                                            child: Text(
                                                              '₹${double.parse(myordersdatum[index].price)}',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppTheme.textcolor,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "WorkSans"),
                                                            ),)
                                                        ],
                                                      )
                                                          :
                                                      Wrap(),
                                                    ],
                                                  ),
                                                ) :Wrap(),


                                              ],)


                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            )
                        );
                    },
                  ),

                ),

/*                discount_grand_total.toString()!="-1"?discount_grand_total!=null?
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(

                    mainAxisSize: MainAxisSize.min,
                    children: [
                      promocodedata=='' && orderstatus!='Completed'?
                      Container(
                        color: Colors.grey.shade200,
                        child:Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20,right: 20,top:20,bottom: 20),

                          height: MediaQuery.of(context).size.height*0.06,
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(


                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3.0),
                            color:Colors.white,
                          ),
                          child: TextField(
                            controller: _couponCodeController,
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(

                                hintText: 'Enter Promo Code if any?',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15),
                                border: InputBorder.none,
                                suffix:
                                InkWell(
                                    onTap: (){

                                      my_orderdetailReq(_couponCodeController.text.toString());

                                    },
                                    child:  Padding(
                                        padding: EdgeInsets.only(right: 10,),
                                        child: Text('Apply'.toUpperCase(),style:TextStyle(
                                            color: Colors.green.shade300,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),)
                                    )
                                )



                            ),


                          ),
                        ),

                      ):Wrap(),

                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top:10),
                        color: Colors.grey.shade200,
                        child:
                        Text('Payment Info'.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,fontFamily: AppTheme.fontName,color: Colors.black),),


                      ),

                      Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        color: Colors.grey.shade200,
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Item Total',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w400)),
                            Text('₹${grandTotal.toString()}',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w400))
                          ],
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                        color: Colors.grey.shade200,
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w400)),
                            Text('-₹${discount_amount}',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w400))
                          ],
                        ),

                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                        color: Colors.grey.shade200,
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w800),),
                            Text('₹${discount_grand_total}',style: TextStyle(fontFamily: AppTheme.fontName,fontSize: 12,fontWeight: FontWeight.w800))
                          ],
                        ),

                      ),


                      orderstatus=="Order Placed"||orderstatus=="Completed"?Wrap():
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.08,
                        color: AppTheme.appColor,

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Total: ₹${discount_grand_total.toString()}',style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontName)),
                            ButtonTheme(
                                buttonColor: Colors.white,
                                minWidth: 20.0,
                                height: 30.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          18.0),
                                      side: BorderSide(
                                          color: Colors
                                              .white)),
                                  onPressed: () async {


                                    placeOrder(promocodedata);
                                  },
                                  child: Text(
                                      'Place Order',
                                      textAlign:
                                      TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ))


                          ],
                        ),
                      ),


                    ],
                  )

                  ,)
                    :
                Wrap()
                    :
                Wrap(),*/
                myordersdatum.isNotEmpty ?
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(

                    mainAxisSize: MainAxisSize.min,
                    children: [

                      myordersdatum[0].clientType.toLowerCase() != 'Credit and fixed'.toLowerCase() && (orderstatus.toLowerCase()=="Price updated".toLowerCase() || orderstatus.toLowerCase() == "Order Placed".toLowerCase())?
                      Container(
                        height: size.height*0.30,
                        color: AppTheme.white,
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
/*                                (incl. of ${gst}% GST)*/
                                Text('Transportation Charge: ₹${transportationCharges.toString()} (Incl. GST)',style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Grand Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        width: size.width* 0.58,
                                        child: Text('Kindly pay amount ₹ ${grandTotal} in below Bank Details or you can pay by scan beside QR Code.', style: TextStyle(fontSize: 8),),
                                      ),
                                      Text('BANK DETAILS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                      Container(
                                        padding: EdgeInsets.only(top: 2.5),
                                        width: size.width* 0.58,
                                        child: Text('Bank Name: ICICI bank, Lashkar, Gwalior', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2.5),
                                        width: size.width* 0.58,
                                        child: Text('Account Number: 143805001072', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2.5),
                                        width: size.width* 0.58,
                                        child: Text('IFSC Code:- ICIC0001438', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 2.5),
                                        width: size.width* 0.58,
                                        child: Text('Name: SCIENTIFIC SUPPLIES & MFG. CO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Image.asset('assets/images/scisco_qr.jpg', width: size.width * 0.33,height: size.width * 0.33,),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: AppTheme.appColor,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  /*Text('Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontName)),*/
                                  Container(
                                    width: size.width * 0.53,
                                    margin: EdgeInsets.only(top: 10, bottom: 10),
                                    padding: EdgeInsets.only(left: 5),
                                    height: 35,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                                    child: TextField(
                                      controller: _updateTransactionController,
                                      textCapitalization: TextCapitalization.sentences,
                                      style: TextStyle(fontSize: 13),
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        hintText: 'Please Enter Transaction ID',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 13),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: size.width * 0.36,
                                      child: ButtonTheme(
                                          buttonColor: AppTheme.white,
                                          minWidth: 20.0,
                                          height: 30.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    18.0),
                                                side: BorderSide(
                                                    color: AppTheme.appColor)),
                                            onPressed: () async {
                                              updateTransactionId();
                                            },
                                            child: Text(
                                                'Update Transaction ID',
                                                textAlign:
                                                TextAlign.end,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 8.5,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    fontFamily: AppTheme
                                                        .fontName)),
                                          ))
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),

                      orderstatus.toLowerCase()=='pending'.toLowerCase() ?
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.08,
                        color: AppTheme.white,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Your Order #${orderId} has been Placed Successfully.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Once we will update prices. You will get Payment Details.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),

                      myordersdatum[0].clientType.toLowerCase() != 'Credit and fixed'.toLowerCase() && orderstatus.toLowerCase()=='completed'.toLowerCase()?
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.08,
                        color: AppTheme.white,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
/*                                (incl. of ${gst}% GST)*/
                                Text('Transportation Charge: ₹${transportationCharges.toString()} (Inc. GST)',style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Grand Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Your Order #${orderId} has been Placed Successfully.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'You will Recieve Your Order very soon.',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),

                      orderstatus.toLowerCase()=='finished'.toLowerCase() ?
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.06,
                        color: AppTheme.white,
                        child: Column(
                          children: [
                            /*Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Transportation Charge: ₹${transportationCharges.toString()} (Inc. GST)',style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Grand Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),*/
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Your Order #${orderId} has been Delivered Successfully.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Thanks for Ordering with us.',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),
                      myordersdatum[0].clientType.toLowerCase() == 'Credit and fixed'.toLowerCase() && myordersdatum[0].orderstatus.toLowerCase() != 'Partially Delivered'.toLowerCase() && myordersdatum[0].orderstatus.toLowerCase() != 'Finished'.toLowerCase()?
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.1,
                        color: AppTheme.white,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
/*                                (incl. of ${gst}% GST)*/
                                Text('Transportation Charge: ₹${transportationCharges.toString()} (Inc. GST)',style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Grand Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Your Order #${orderId} has been Completely Dispatched Sucessfully.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'You will Recieve Your Order very soon.',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),
                      myordersdatum[0].orderstatus.toLowerCase() == 'Partially Delivered'.toLowerCase()?
                      Container(
                        padding: EdgeInsets.only(left: 10,right:10),
                        height: size.height*0.11,
                        color: AppTheme.white,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
/*                                (incl. of ${gst}% GST)*/
                                Text('Transportation Charge: ₹${transportationCharges.toString()} (Inc. GST)',style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:
                                Text('Grand Total: ₹${grandTotal.toString()}',style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.nearlyBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontName)),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Your Order #${orderId} has been Partially Delivered Successfully.',
                                      textAlign:
                                      TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          fontFamily: AppTheme
                                              .fontName)),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(padding: EdgeInsets.all(0)),
                                Container(
                                  width: size.width*0.9,
                                  child: Text(
                                      'Thanks for Ordering with us.',
                                      textAlign: TextAlign.end,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: AppTheme.fontName)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          :
                      Wrap(),
                    ],
                  ),
                )
                    :
                Wrap(),

              ])
      ),
    );
  }
  Future<bool> _onWillPop() async {
    return Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
            builder: (BuildContext context) => new NavigationHomeScreen()),(route) => false) ?? false;
  }

  Widget loadingLayoutSlider() {
    return CustomLoader(
      color: Color(0xFF6991C7),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext ctx) => NavigationHomeScreen()));

    return false; // return true if the route to be popped
  }

  void navigateToPage(
      BuildContext context,
      String msg,
      ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Alert"),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(msg),
            ),
            actions: <Widget>[

              CupertinoDialogAction(
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new MyQuoteOrders()));
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

  Future<Response> my_orderdetailReq(String promocode) async {
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
          "order_id": orderId,
        });
        String url;
        print(status);
        if(status.toLowerCase() == "pending".toLowerCase())
          url = myOrderDetailsWithoutPrice;
        else
          url = my_order_detailsUrl;

        print(url);
        print(body);
        Response response = await baseApi.dio.post(url, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          print(response);
          final parsed = json.decode(response.data).cast<String, dynamic>();
          var myordersRespo = MyOrdersDetailRespo.fromJson(parsed);
          progressDialog.dismiss();
          if (myordersRespo.error == "0") {

            setState(() {
              myordersdatum = myordersRespo.list;
              orderstatus = myordersRespo.orderstatus;
              if(myordersRespo.orderstatus.toLowerCase() != 'Pending'.toLowerCase()) {
                //grandTotal = myordersRespo.grand_total;
                discount_amount = myordersRespo.discount_amount;
                discount_grand_total = myordersRespo.discount_grand_total;

                print(discount_grand_total.toString() + " DISCOUNT");
                // if(myordersRespo.list.isNotEmpty)
                promocodedata = myordersRespo.promocodedata;
                _updateTransactionController.text = myordersRespo.transactionId;

                print(myordersRespo.transactionId);
                grandTotal = myordersRespo.grand_total;
                transportationCharges =myordersRespo.transportationCharges;
                for (MyOrdersDetailDatum data in myordersdatum) {
                  if (data.gst.isNotEmpty && data.price.isNotEmpty) {
                    if (double.parse(data.gst) > gst)
                      gst = double.parse(data.gst);
                  }
                }
                // transportationCharges += gst;
                print(grandTotal.toString() + '\n' +
                    transportationCharges.toString());
              }
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


  Future<Response> updateTransactionId() async {
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
          "user_id": prefs.getString(SharedPrefKey.USERID),
          "order_id": orderId,
          "trasaction_id": _updateTransactionController.text.toString(),
          // "promocode": promocode,
          // "grand_total": grandTotal.toString(),
          // "discount_amount": discount_amount.toString(),
          // "discount_grand_total": discount_grand_total.toString(),
        });


        print("Request:" + body.toString());
        Response response =
        await baseApi.dio.post(updateTransactionIdURL, data: body);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();

          var myordersRespo = CommonRespoModel.fromJson(parsed);

          progressDialog.dismiss();
          if (myordersRespo.error == "1") {

            navigateToPage(context, myordersRespo.error_msg.toString());
            // displayToast(myordersRespo.error_msg.toString(), context);


          } else {
            String error_msg = myordersRespo.error_msg;
            displayToast(error_msg.toString(), context);
          }
        }

        print("RESPOONSE:" + response.toString());
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

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}

typedef void MyCallback(int foo);

void _showSuccessMyDialog(
    BuildContext context,
    String msg,
    ) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Update Bank Details"),
          content: Padding(
            padding: EdgeInsets.all(10),
            child: Text(msg),
          ),
          actions: <Widget>[

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

