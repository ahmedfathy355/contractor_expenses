// To parse this JSON data, do
//
//     final accounts = accountsFromMap(jsonString);

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:contractor_expenses/Models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../Utility/utils.dart';
import '../Models/user.dart' as userRepo;

class Accounts {
  Accounts({
    this.serial,
    this.parentSerial,
    this.accountItemId,
    this.subAccountItemId,
    this.notes,
    this.details,
    this.amount,
    this.type,
    this.documentNumber,
    this.duoDate,
    this.createdBy,
    this.checkNumber,
    this.checkDate,
    this.costCenterId,
    this.approvedBy,
    this.approvedDate,
    this.isApproved,
  });

  final int serial;
  final int parentSerial;
  final int accountItemId;
  final int subAccountItemId;
  final String notes;
  final String details;
  final int amount;
  final String type;
  final String documentNumber;
  final DateTime duoDate;
  final int createdBy;
  final CheckNumber checkNumber;
  final dynamic checkDate;
  final int costCenterId;
  final int approvedBy;
  final DateTime approvedDate;
  final bool isApproved;

  factory Accounts.fromJSON(String str) => Accounts.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Accounts.fromMap(Map<String, dynamic> json) => Accounts(
    serial: json["Serial"],
    parentSerial: json["ParentSerial"] == null ? null : json["ParentSerial"],
    accountItemId: json["AccountItemID"],
    subAccountItemId: json["SubAccountItemID"] == null ? null : json["SubAccountItemID"],
    notes: json["Notes"],
    details: json["Details"] == null ? null : json["Details"],
    amount: json["Amount"],
    type: json["Type"],
    documentNumber: json["DocumentNumber"],
    duoDate: DateTime.parse(json["DuoDate"]),
    createdBy: json["CreatedBy"],
    checkNumber: json["CheckNumber"] == null ? null : checkNumberValues.map[json["CheckNumber"]],
    checkDate: json["CheckDate"],
    costCenterId: json["CostCenterID"] == null ? null : json["CostCenterID"],
    approvedBy: json["ApprovedBy"] == null ? null : json["ApprovedBy"],
    approvedDate: json["ApprovedDate"] == null ? null : DateTime.parse(json["ApprovedDate"]),
    isApproved: json["IsApproved"],
  );

  Map<String, dynamic> toMap()  {
    var map = new Map<String, dynamic>();
    map["Serial"] = serial;
    map["ParentSerial"] = parentSerial == null ? null : parentSerial;
    map["AccountItemID"] = accountItemId;
    map["SubAccountItemID"] = subAccountItemId == null ? null : subAccountItemId;
    map["Notes"] = notes;
    map["Details"] = details == null ? null : details;
    map["Amount"] = amount;
    map["Type"] = type;
    map["DocumentNumber"] = documentNumber;
    map["DuoDate"] = duoDate.toIso8601String();
    map["CreatedBy"] = createdBy;
    map["CheckNumber"] = checkNumber == null ? null : checkNumberValues.reverse[checkNumber];
    map["CheckDate"] = checkDate;
    map["CostCenterID"] = costCenterId == null ? null : costCenterId;
    map["ApprovedBy"] = approvedBy == null ? null : approvedBy;
    map["ApprovedDate"] = approvedDate == null ? null : approvedDate.toIso8601String();
    map["IsApproved"] = isApproved;
  return map;
  }
}

enum CheckNumber { THE_2020202020202, THE_303030303030, THE_5555555555, EMPTY }

final checkNumberValues = EnumValues({
  "": CheckNumber.EMPTY,
  "2020202020202": CheckNumber.THE_2020202020202,
  "303030303030": CheckNumber.THE_303030303030,
  "5555555555": CheckNumber.THE_5555555555
});

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
Future<List<Accounts>> getAccounts() async {
  final String url = '${Utils.restURL}ViewAccounts';
  final client = new http.Client();
  final response = await client.get( Uri.parse(url),headers: { 'Authorization': Utils.basicAuth, });
  var _code = 'ViewAccounts Code = ' + response.statusCode.toString();
  print(_code);
  final responseJson = jsonDecode(response.body).cast<Map<String, dynamic>>();
  return responseJson.map<Accounts>((json) => Accounts.fromJSON(json)).toList();
}


//get/id
Future<Accounts> getAccItem(Accounts acc) async {
  User _user = userRepo.currentUser.value;
  final String url =  '${Utils.restURL}ViewAccounts/${_user.UserID}' ;
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
  return Accounts.fromJSON(json.decode(response.body)[0]);
}


//post
Future<Accounts> addAccountItem(Accounts acc) async {
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
  return Accounts.fromJSON(json.decode(response.body)[0]);
}


//put/id
Future<Accounts> updateAccountItem(Accounts accItems) async {
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
  return Accounts.fromJSON(json.decode(response.body)[0]);
}

//delete/id
Future<Accounts> addAccount(Accounts acc) async {
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
  return Accounts.fromJSON(json.decode(response.body)[0]);
}


