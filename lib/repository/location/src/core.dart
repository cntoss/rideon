library google_maps_webservice.utils;

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rideon/config/appConfig.dart';

abstract class RideonWebService {
  @protected
  final String _url;

  @protected
  final Options _apiHeaders;

  String get url => _url;

  Options get apiHeaders => _apiHeaders;

  RideonWebService({
    required String apiKey,
    required String url,
    Options? apiHeaders,
  })  :
        _url = '$baseUrl$url',
        _apiHeaders = apiHeaders!;

  @protected
  String buildQuery(Map<String, dynamic> params) {
    final query = [];
    params.forEach((key, val) {
      if (val != null) {
        if (val is Iterable) {
          query.add("$key=${val.map((v) => v.toString()).join("|")}");
        } else {
          query.add('$key=${val.toString()}');
        }
      }
    });
    return query.join('&');
  }


  @protected
  Future<Response> doGet(String url, {Options? headers}) {
    return Dio().get(url, options: headers);
  }

  @protected
  Future<Response> doPost(
    String url,
    String? body, {
    Options? headers,
  }) {
    return Dio().post(url, data: body, options: headers);
  }
}

