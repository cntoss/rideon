// To parse this JSON data, do
//
//     final generalResponse = generalResponseFromJson(jsonString);

import 'dart:convert';

GeneralResponse generalResponseFromJson(String str) => GeneralResponse.fromJson(json.decode(str));

String generalResponseToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
    GeneralResponse({
        this.expired,
        this.valid,
        this.data,
        this.error,
        this.message,
    });

    bool? expired;
    bool? valid;
    dynamic data;
    dynamic error;
    String? message;

    factory GeneralResponse.fromJson(Map<String, dynamic> json) => GeneralResponse(
        expired: json["expired"],
        valid: json["valid"],
        data: json["data"],
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "expired": expired,
        "valid": valid,
        "data": data,
        "error": error,
        "message": message,
    };
}
