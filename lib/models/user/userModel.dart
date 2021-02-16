// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.id,
        this.name,
        this.phone,
        this.email,
        this.gender,
        this.dob,
        this.image,
        this.paymentId,
    });

    int id;
    String name;
    String phone;
    String email;
    String gender;
    String dob;
    String image;
    int paymentId;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        image: json["image"],
        paymentId: json["payment_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "dob": dob,
        "image": image,
        "payment_id": paymentId,
    };
}
