import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

class Networker {
  Dio _dio;
  GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Networker() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: "${Env.baseURL}",
        contentType: "application/json",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data'
        },
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError error) {
          if (error.response.statusCode == 500) {
            navigatorKey.currentState.pushNamedAndRemoveUntil(
                "/", (route) => route.isFirst);
          }
        },
        /*onRequest: (RequestOptions options) async {
          var token = await _getToken();
          options.headers['Authorization'] = "Bearer $token";
        },*/
      ),
    );
  }
/*
  _getToken() async {
    var prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
*/
  Future post(route, {params}) {
    return _dio.post(route, data: params);
  }

  Future put(route, {params}) {
    return _dio.put(route, data: params);
  }

  Future get(route) {
    return _dio.get(route);
  }

  Future delete(route) {
    return _dio.delete(route);
  }
}

final Networker worker = Networker();
