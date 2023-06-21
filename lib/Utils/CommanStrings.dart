//String BASE_URL = "https://synramtechnology.com/scisco/admin/";
//String ASSET_URL = "https://synramtechnology.com/scisco/admin/";
String BASE_URL = "https://glasmic.com/admin/";
String ASSET_URL = "https://glasmic.com/admin/";

String sliderUrl = "app_api/slider_api";
String registerSubUrl = "app_api/signup_api";
String loginSubUrl = "app_api/login_api";
String submitUserKyc = "app_api/User_kyc";
String forgotpassUrl = "app-api/forgot-driver-password";
String statesSubUrl = "app_api/state_list";
String citiesSubUrl = "app_api/city_list";
String product_listUrl = "app-api/product_list";
String edit_tokenUrl = "app-api/edit_token";
String getaQuoteUrl = "app-api/add_product";
String my_orderUrl = "app-api/my_order";
String myQuoteOrderUrl = "app-api/order_history";
String my_order_detailsUrl = "app-api/my_order_detailsnew";
String myOrderDetailsWithoutPrice = "app_api/my_order_detailspricenull";
String product_detailsURL = "app-api/product_details";
String my_profileURl = "app-api/my_profile";
String edit_profileUrl = "app-api/edit_profile";
String supportUrl = "app-api/support";
String forgotpasswordURL = "app-api/forgotpassword";
String placeorderURL = "app-api/update_order";
String updateQuantity = "app_api/changeorderplacenew";
String updateTransactionIdURL = "app-api/update_trasactionid";
String supercategoriesURL = "app-api/supercategory_list";
String brandURL = "app_api/brand_list";
String categoriesUrl = "app_api/category_list_by_suprecategory_id";
String brandListOrderBy = "app_api/brand_list_orderby";
String brandByIDUrl = "app_api/product_list_by_brand";
String productByCatUrl = "app_api/product_list_by_category";

String checkforgotpassUrl = "app-api/driver_forgot_emailotp_check";
String changePassUrl = "app-api/driver_change_password";
String moveItemsUrl = "app-api/fetch_all_move_type";
String customerOTPVerifyUrl = "app-api/customer_reg_otp_sendtomobile";
String customer_reg_otp_checkUrl = "app-api/customer-reg-otp-check";
String mancategory_typeUrl = "app-api/fetch_all_mancategory_type";
String driver_personal_profileUrl = "app-api/get-driver-personal-profile";
String get_driver_personal_bankURL = "app-api/get-driver-personal-bank";
String get_driver_personal_vehicleURL = "app-api/get-driver-personal-vehicle";
String all_vehicleEquipmentUrl = "app-api/fetch_all_vehicle_equipment";
String update_driver_personal_profileUrl =
    "app-api/update-driver-personal-profile";
String update_driver_personal_bankURL = "app-api/update-driver-personal-bank";
String update_driver_personal_vehicleURL =
    "app-api/update-driver-personal-vehicle";
String get_driver_new_bookingsUrl = "app-api/get_driver_new_booking";
String get_driver_bookingsUrl = "app-api/get-driver-bookings";
String driver_booking_status_changeUrl = "app-api/driver-booking-status-change";
String driver_live_status_changeUrl = "app-api/driver-live-status-change";
String driver_location_changeUrl = "app-api/driver-location-change";
String get_driver_total_payment_listURL =
    "app-api/get_driver_total_payment_list";
String put_driver_booking_request_paymentURL =
    "app-api/put-driver-booking-request-payment";
String get_driver_payment_listURL = "app-api/get_driver_payment_list";
String get_driver_payment_detailUrl = "app-api/get_driver_payment_detail";
String driver_booking_detailsUrl = "app-api/driver-booking-detail";
String send_driver_messageUrl = "app-api/send_driver_message";

String driver_registrationUrl = "app-api/driver_registration";
String update_driver_personal_imageURL = "app-api/update-driver-personal-image";
String driverProfileUrl = "app-api/get_driver_profile";
String new_booking_saveUrl = "app-api/new-booking-save";
String customer_registrationUrl = "app-api/customer-registration";
String get_all_near_driver_bycustomerUrl =
    "app-api/get_all_near_driver_bycustomer";
String logoutSubUrl = "auth/logout";
//String sliderUrl = "App_api/banner";
String product_detailsUrl = "App_api/product_details";
String addtocardUrl = "App_api/addtocard";
String profiledataUrl = "App_api/profiledata";
String newAddressUrl = "App_api/newaddress";
String viewCartUrl = "App_api/viewcart";
String addressUrl = "App_api/address";
String topSellingProductUrl = "App_api/topselling_product";
String countryUrl = "App_api/country";
String bestSellerSubUrl = "products/best-seller";
String todaysDealSubUrl = "products/todays-deal";
String allCategorySubUrl = "categories";
String topBrandsSubUrl = "brands/top";
String userSubUrl = "auth/user/";
String updateUserSubUrl = "auth/update_profile";
String quantityUrl = "carts/change-quantity";
String deleteCart = "carts/deleteCart";
String addToCartSubUrl = "carts/addToCart";
String getaccessTokenPaystack = "payments/pay/paystack";
String checkoutStore = "order/store";
String getCartSubUrl = "carts/";

String appLogoImg = "assets/images/aj_splash_logo.png";

class BookingStatus {
  static String PENDING = "Booked";
  static String CONFIRM = "Confirmed";
  static String ONTHEWAY = "On the way";

  static String CANCELLED = "Cancelled";
  static String REJECTED = "Rejected";
  static String LOADED = "Loaded";
  static String ARRIVED = "Arrived";
  static String UNLOADING = "Unloading";
  static String COMPLETE = "Job Completed";
  static String ACCEPT = "Accepted";
}

class SharedPrefKey {
  static String ISLOGEDIN = "ISLOGEDIN";
  static String CATEGORIES = "ISCATEGORIES";
  static String ISKYCDONE = "ISKYCDONE";
  static String ISONLINE = "ISONLINE";
  static String USERID = "USERID";
  static String EMAILID = "EMAILID";
  static String FIRSTNAME = "FIRSTNAME";
  static String LASTNAME = "LASTNAME";
  static String MOBILENO = "MOBILENO";
  static String WHATSAPP = "WHATSAPPNO";
  static String ADDRESS = "ADDRESS";
  static String PROFILEPIC = "PROFILEPIC";
  static String SELECTEDPRODUCTS = "SELECTEDPRODUCTS";
  static String SELECTEDPRODUCTSQUANTITY = "SELECTEDPRODUCTSQUANTITY";
}

class ShardPrefReg {
  static String FIRSTNAMEREG = "FIRSTNAMEREG";
  static String LASTNAMEREG = "LASTNAMEREG";
  static String MOBILEREG = "MOBILEREG";
  static String EMAILREG = "EMAILREG";
  static String ADDRESSREG = "ADDRESSREG";
  static String SUBURBREG = "SUBURBREG";
  static String POSTCODEREG = "POSTCODEREG";
  static String DOBREG = "DOBREG";
  static String PASSWORDREG = "PASSWORDREG";
  static String PROFILEIMGREG = "PROFILEIMGREG";
  static String DLFRONT = "DLFRONT";
  static String DLBACK = "DLBACK";
  static String VRPIMG = "VRPIMG";
  static String PLIIMAGE = "PLIIMAGE";
}