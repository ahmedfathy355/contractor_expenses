// To parse this JSON data, do
//
//     final accounts = accountsFromMap(jsonString);

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:contractor_expenses/Models/accounts.dart';
import 'package:contractor_expenses/Models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../Utility/utils.dart';
import '../Models/accounts.dart' as accRepo;

class AccountImages {
  AccountImages({
    this.serial,
    this.accountSerial,
    this.documentNumber,
    this.documentPhoto,
  });

  final int serial;
  final String accountSerial;
  final String documentNumber;
  final String documentPhoto;

  factory AccountImages.fromJSON(String str) => AccountImages.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountImages.fromMap(Map<String, dynamic> json) => AccountImages(
    serial: json["Serial"],
    accountSerial: json["AccountSerial"] ,
    documentNumber: json["DocumentNumber"],
    documentPhoto: json["DocumentPhoto"] ,
  );

  Map<String, dynamic> toMap()  {
    var map = new Map<String, dynamic>();
    map["Serial"] = serial;
    map["AccountSerial"] = accountSerial;
    map["DocumentNumber"] = documentNumber;
    map["DocumentPhoto"] = documentPhoto;

    return map;
  }
}


class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}





//get
Future<List<AccountImages>> getAccounts() async {
  final String url = '${Utils.restURL}Account_Images';
  final client = new http.Client();
  final response = await client.get( Uri.parse(url),headers: { 'Authorization': Utils.basicAuth, });
  var _code = 'Account_Images Code = ' + response.statusCode.toString();
  print(_code);
  final responseJson = jsonDecode(response.body).cast<Map<String, dynamic>>();
  return responseJson.map<AccountImages>((json) => AccountImages.fromJSON(json)).toList();
}


//get/id
Future<AccountImages> getAccountImage(Accounts acc) async {

  final String url =  '${Utils.restURL}Account_Images/${acc.serial}' ;
  final client = new http.Client();
  final response = await client.get(
    Uri.parse(url) ,
    headers: {'Authorization': Utils.basicAuth },
  );
  print(response);
  if (response.statusCode == 200)
  {
    //must return all data (entity) from api
    //[0] for one row
    var _code = 'accountItems Code = ' + response.statusCode.toString();
    print(_code);
    //final responseJson = jsonDecode(response.body).cast<Map<String, dynamic>>();
    //return responseJson.map<AccountItems>((json) => AccountItems.fromJSON(json)).toList();
  }
  return AccountImages.fromJSON(json.decode(response.body)[0]);
}


//post
Future<AccountImages> addAccountItem(AccountImages acc_img) async {
  //User _user = userRepo.currentUser.value;
  // Map<String, dynamic> decodedJSON = {};
  //  final String _apiToken = 'api_token=${_user.apiToken}';
  //  final String _resetParam = 'reset=${reset ? 1 : 0}';
  //accItems. = _user.UserID;

  final Uri url = Uri.parse('${Utils.restURL}AccountItems')  ;
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {'Authorization': Utils.basicAuth },
    //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(acc_img.toMap()),
  );
  if (response.statusCode == 200) {
    print("Saved Ok");
  }
  return AccountImages.fromJSON(json.decode(response.body)[0]);
}


//put/id
Future<AccountImages> updateAccountItem(AccountImages accImg) async {
  //final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final Uri url = Uri.parse('${Utils.restURL}AccountItems/${accImg.serial}');
  final client = new http.Client();
  final response = await client.post(
    url,
    //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    headers: {'Authorization': Utils.basicAuth },
    body: json.encode(accImg.toMap()),
  );
  if (response.statusCode == 200) {
    print("Saved Ok");
  }
  return AccountImages.fromJSON(json.decode(response.body)[0]);
}

//delete/id
Future<AccountImages> addAccount(AccountImages acc) async {
  //User _user = userRepo.currentUser.value;
  // Map<String, dynamic> decodedJSON = {};
  //  final String _apiToken = 'api_token=${_user.apiToken}';
  //  final String _resetParam = 'reset=${reset ? 1 : 0}';
  //accItems. = _user.UserID;

  final Uri url = Uri.parse('${Utils.restURL}AccountItems')  ;
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {'Authorization': Utils.basicAuth },
    //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(acc.toMap()),
  );
  if (response.statusCode == 200) {
    print("Saved Ok");
  }
  return AccountImages.fromJSON(json.decode(response.body)[0]);
}



//// save image in shared preferance and load it again

const String IMG_KEY = 'IMAGE_KEY';
Future<bool> saveImageToPreferences(String value) async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(IMG_KEY, value);
}

Future<String> getImageFromPreferences() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(IMG_KEY);
}