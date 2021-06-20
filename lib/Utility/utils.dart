
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';


class Utils{
  static String tableValue = "";

 // static String restURL = "http://masrawy.ubuntu-eg.com/api/";
  static String restURL = "http://smartapps-001-site20.dtempurl.com/api/";
  //static String restURL = "http://localhost:57441/api/";
  static String basicAuth = 'Basic aWn0S46WgOPKWmaxgjXjqFsOX2UijrbwKWVYbiIJKTsfTI5+404cPYfhIuObNaTdkMZPKKwTGE3wt3VLcb4PDGK0HXxrhddCDi/yt/hx2l8=';
  static int statusCode ;
  static bool needChangePassword ;
  static bool orderHaveItems  = false;
  static bool isConnected = false;


  static TextStyle kTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w100,
    color: Color(0xFF0EAD6A),
    fontFamily: 'NeoSans',


  );


  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}