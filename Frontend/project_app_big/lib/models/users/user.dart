
// ignore_for_file: non_constant_identifier_names
// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
//List<User> userFromJson_List (String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
User userToJson01(String str) => User.fromJson(json.decode(str));
class User {
    User({
         this.id = 0,
         this.name = '',
         this.email = '',
         this.password = '',
         this.tel = '',
         this.image 
    });

    int id;
    String name;
    String email;
    String password;
    String tel;
    dynamic image;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        tel: json["tel"],
        image: json["image"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "tel": tel,
        "image": image,
    };
}
