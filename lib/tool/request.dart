import 'package:dio/dio.dart';

class Request {
  Dio dio;
  Request() {
    dio = Dio();
    dio.options.connectTimeout = 15000;
    dio.options.baseUrl = 'http://video.heroitsme.com/apis/';
  }

  Future<Response> get(String path, Map<String, dynamic> queryParameters) async {
    try{
      return dio.get(path, queryParameters: queryParameters);
    }on DioError catch (e){
      print(e);
    }
    return null;
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    try{
      return dio.post(path, data: data);
    }on DioError catch (e){
      print(e);
    }
    return null;
  }
}