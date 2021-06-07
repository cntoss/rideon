import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rideon/config/appConfig.dart';
import 'package:rideon/widgets/custom_dialog.dart';

class LoginRequest {
  Future<LoginResponse?> loginRequest(String phone) async {
    try {
      var response = await Dio().post(baseUrl + 'login',
          options: Options(
            contentType: "application/json",
          ),
          data: {"phone": phone});
      print(LoginResponse.fromJson(response.data).message);
      return LoginResponse.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response!.data != null) {
        /* CustomDialog().showCustomDialog(
            title: 'Login Failed',
            content: LoginResponse.fromJson(error.response.data).message); */
        return LoginResponse.fromJson(error.response!.data);
      } else {
        CustomDialog().showCustomDialog(
            title: 'Login Failed',
            content: "Unable to login with this phone number");
        return null;
      }
    }
  }
}

// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.valid,
    this.data,
    this.message,
  });

  bool? valid;
  Data? data;
  String? message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        valid: json["valid"],
        data: json.containsKey('data') ? Data.fromJson(json["data"]) : null,
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "valid": valid,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.token,
  });

  String? token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
