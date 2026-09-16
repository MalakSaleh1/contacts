import 'dart:io';

import 'package:flutter/foundation.dart';

class ContactModel {
  final String name;
  final String email;
  final String phone;
  final String imagePath;

  ContactModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'imagePath': imagePath,
  };

  factory ContactModel.fromJson(Map<String,dynamic> json){
   return  ContactModel(
       imagePath: json["imagePath"],
       name: json["name"],
       email: json["email"],
       phone: json["phone"]);
  }

}