import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiManager {
  static bool showLog = true;

  Future<dynamic> callGetApi(String webLink, String token,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? additionalHeaders}) async {
    Dio dio = Dio();
    try {
      final headers = _mergeHeaders({
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      }, additionalHeaders);

      final Response response = await dio.get(webLink,
          queryParameters: queryParameters, options: Options(headers: headers));

      var data = response.data;

      if (showLog) {
        log('\n\n**************************URL**************************\n\n$webLink\n\n');
        log('\n\n**************************QUERY PARAMETERS**************************\n\n$queryParameters\n\n');
        log('\n\n**************************RESPONSE**************************\n\n$data\n\n');
      }
      return data;
    } on DioException catch (error) {
      debugPrint('dio Error >> || $error');
      log(error.toString());
      rethrow;
    } catch (e) {
      debugPrint('General Error >> || $e');
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> callPostApi(String webLink, Object params, String token,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? additionalHeaders}) async {
    Dio dio = Dio();
    try {
      final headers = _mergeHeaders({
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      }, additionalHeaders);

      final Response response = await dio.post(webLink,
          data: params,
          queryParameters: queryParameters,
          options: Options(headers: headers));

      var data = response.data;
      if (showLog) {
        log('\n\n**************************URL**************************\n\n$webLink\n\n');
        log('\n\n**************************REQUESTS**************************\n\n${jsonEncode(params)}\n\n');
        log('\n\n**************************RESPONSE**************************\n\n$data\n\n');
      }
      return data;
    } on DioException catch (error) {
      debugPrint('DIO ERROR>>>> $error');
      log(error.toString());
      rethrow;
    } catch (e) {
      debugPrint('General Error >> || $e');
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> callPutApi(String webLink, Object params, String token,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? additionalHeaders}) async {
    Dio dio = Dio();
    try {
      final headers = _mergeHeaders({
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      }, additionalHeaders);

      final Response response = await dio.put(webLink,
          data: params,
          queryParameters: queryParameters,
          options: Options(headers: headers));

      var data = response.data;
      if (showLog) {
        log('\n\n**************************URL**************************\n\n$webLink\n\n');
        log('\n\n**************************REQUESTS**************************\n\n${jsonEncode(params)}\n\n');
        log('\n\n**************************RESPONSE**************************\n\n$data\n\n');
      }
      return data;
    } on DioException catch (error) {
      debugPrint('DIO ERROR>>>> $error');
      log(error.toString());
      rethrow;
    } catch (e) {
      debugPrint('General Error >> || $e');
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> callDeleteApi(String webLink, String token,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? additionalHeaders}) async {
    Dio dio = Dio();
    try {
      final headers = _mergeHeaders({
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      }, additionalHeaders);

      final Response response = await dio.delete(webLink,
          queryParameters: queryParameters, options: Options(headers: headers));

      var data = response.data;

      if (showLog) {
        log('\n\n**************************URL**************************\n\n$webLink\n\n');
        log('\n\n**************************QUERY PARAMETERS**************************\n\n$queryParameters\n\n');
        log('\n\n**************************RESPONSE**************************\n\n$data\n\n');
      }
      return data;
    } on DioException catch (error) {
      debugPrint('DIO ERROR>>>> $error');
      log(error.toString());
      rethrow;
    } catch (e) {
      debugPrint('General Error >> || $e');
      log(e.toString());
      rethrow;
    }
  }

  Future<dynamic> callMultiPartApi(String webLink, var params, String token,
      {Function(String)? onProgress,
      Map<String, String>? additionalHeaders}) async {
    Dio dio = Dio();
    try {
      final headers = _mergeHeaders({
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      }, additionalHeaders);

      final Response response = await dio.post(webLink,
          data: FormData.fromMap(params),
          options: Options(headers: headers), onSendProgress: (sent, total) {
        if (onProgress != null) {
          onProgress('${(sent / total * 100).toStringAsFixed(0)}%');
        }
      });

      var data = response.data;

      if (showLog) {
        log('\n\n**************************URL**************************\n\n$webLink\n\n');
        log('\n\n**************************RESPONSE**************************\n\n$data\n\n');
      }
      return data;
    } on DioException catch (error) {
      log(error.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Map<String, String> _mergeHeaders(
      Map<String, String> baseHeaders, Map<String, String>? additionalHeaders) {
    if (additionalHeaders != null) {
      return {...baseHeaders, ...additionalHeaders};
    }
    return baseHeaders;
  }
}
