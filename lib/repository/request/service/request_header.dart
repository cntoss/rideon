import 'package:dio/dio.dart';

class RequestHeader {
  Options optionsWithToken(String token) {
    return Options(
      headers: {
        "Authorization": "Basic xxxxxx",
        "Token": token
      },
      contentType: "application/json",
    );
  }

  Options optionsForFirebase() {
    return Options(
      headers: {
        "Authorization": "key=AAAABYBX-D8:APA91bH6kB5Mh6F8mrHBfGdbA-p3KPO4bW-dtCm9K5C_wUsg_NC2fOBIJ0ZODm1kHGPKMq290sHNY74O2fbEqEtPCZQoTpF9GDwzapamRatV4lEt_Rk0j2Dt6aGzUInYq3VhAtWF2HLX",
      },
      contentType: "application/json",
    );
  }
}
