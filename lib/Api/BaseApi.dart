
import 'package:dio/dio.dart';
import 'package:scisco/Utils/CommanStrings.dart';

class BaseApi{
  Dio dio;
  BaseApi()
  {
    BaseOptions options = new BaseOptions(
      baseUrl: BASE_URL,
    );

    dio = new Dio(options);
  }
}