// To parse this JSON data, do
//
//     final accountItems = accountItemsFromJson(jsonString);

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:contractor_expenses/Models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../Utility/utils.dart';
import '../Models/user.dart' as userRepo;

class AccountItems {
  AccountItems({
    this.id,
    this.parentId,
    this.accountItemName,
    this.accountItemType,
  });

  final int id;
  final int parentId;
  final String accountItemName;
  final String accountItemType;

  factory AccountItems.fromRawJson(String str) => AccountItems.fromJSON(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // preview from Database
  factory AccountItems.fromJSON(Map<String, dynamic> json) => AccountItems(
    id: json["ID"],
    parentId: json["ParentID"],
    accountItemName: json["AccountItemName"],
    accountItemType: json["AccountItemType"],
  );

  // insert in database
  Map<String, dynamic> toMap()  {
    var map = new Map<String, dynamic>();
    //"ID": id,
    map["ParentID"] = parentId;
    map["AccountItemName"] = accountItemName;
    map["AccountItemType"] = accountItemType;
    return map;
  }
}


//get
Future<List<AccountItems>> getAccountItems() async {
  final String url = '${Utils.restURL}AccountItems';
  final client = new http.Client();
  final response = await client.get( Uri.parse(url),headers: { 'Authorization': Utils.basicAuth, });
  var _code = 'accountItems Code = ' + response.statusCode.toString();
  print(_code);
  final responseJson = jsonDecode(response.body).cast<Map<String, dynamic>>();
  return responseJson.map<AccountItems>((json) => AccountItems.fromJSON(json)).toList();
}


//get/id
Future<AccountItems> getAccIteByID(AccountItems accItems) async {
  final String url =  '${Utils.restURL}AccountItems/${accItems.id}' ;
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
  return AccountItems.fromJSON(json.decode(response.body)[0]);
}


//post
Future<AccountItems> addAccountItem(AccountItems accItems) async {
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
    body: json.encode(accItems.toMap()),
  );
  if (response.statusCode == 200) {
    print("Saved Ok");
  }
  return AccountItems.fromJSON(json.decode(response.body)[0]);
}


//put/id
Future<AccountItems> updateAccountItem(AccountItems accItems) async {
  //final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final Uri url = Uri.parse('${Utils.restURL}AccountItems/${currentUser.value.UserID}');
  final client = new http.Client();
  final response = await client.post(
    url,
    //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    headers: {'Authorization': Utils.basicAuth },
    body: json.encode(accItems.toMap()),
  );
  if (response.statusCode == 200) {
    print("Saved Ok");
  }
  return AccountItems.fromJSON(json.decode(response.body)[0]);
}

//delete/id