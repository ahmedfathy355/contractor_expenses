import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utility/utils.dart';

class User {
  int UserID;
  String UserName;
  String Password;
  String PasswordStored;
  String Mobile;
  bool Active;
  bool IsEmployee;
  double Salary;
  String EmpCode;
  String apiToken;
  String deviceToken;
  // used for indicate if client logged in or not
  bool auth;

  User({this.UserID, this.UserName, this.Password,this.PasswordStored, this.Mobile, this.Active, this.IsEmployee,  this.Salary, this.EmpCode, this.apiToken, this.deviceToken});

  // preview from Database
  factory User.fromJSON(Map<String, dynamic> jsonMap) => User(
      UserID : jsonMap['UserID']  ,
      UserName : jsonMap['UserName'] as String,
      Password :jsonMap["Password"] as String,
      PasswordStored :jsonMap["PasswordStored"] as String,
      Mobile :jsonMap["Mobile"] as String,
      Active :  jsonMap['Active'],
      IsEmployee :  jsonMap['IsEmployee'],
      EmpCode :jsonMap["EmpCode"] as String,
      Salary :jsonMap["Salary"] as double,
      apiToken : jsonMap['api_token'] as String,
      deviceToken : jsonMap['device_token'] as String,
  );

// insert in database
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["UserID"]  = UserID  as int;
    map["UserName"] = UserName as String;
    map["Password"] = Password as String;
    map["PasswordStored"] = PasswordStored as String;
    map["Mobile"] = Mobile as String;
    map["Active"] = Active;
    map["IsEmployee"] = IsEmployee;
    map["EmpCode"] = EmpCode as String;
    map["Salary"] = Salary as double;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
   // map["media"] = image?.toMap();
    return map;
  }

  @override
  String toString1() {
    var map = this.toMap();
    return map.toString();
  }
}


ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<User> login_mo(User user) async {
  final Uri url =  '${Utils.restURL}login' as Uri;
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    //must return all data (entitiy) from api
    currentUser.value = User.fromJSON(json.decode(response.body));
  }
  return currentUser.value;
}

Future<User> register(User user) async {
  final Uri url = Uri.parse('${Utils.restURL}register')  ;
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  }
  return currentUser.value;
}

Future<User> resetPassword(User user) async {

  final Uri url = Uri.parse('${Utils.restURL}reset_password/${user.UserID}');
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    //must return all data (entitiy) from api
    currentUser.value = User.fromJSON(json.decode(response.body));
  }
  return currentUser.value;
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString) != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)));
  }
}

Future<Stream<User>> getUsers() async {
  final String url = '${Utils.restURL}user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));


  var _code = streamedRest.statusCode;

  return streamedRest
      .stream
      .transform(utf8.decoder)
      .transform(json.decoder)
  //.cast<Map<String, dynamic>>()
  //.map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => User.fromJSON(data));
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.clear();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value = User.fromJSON(json.decode(await prefs.get('current_user')));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  currentUser.notifyListeners();
  return currentUser.value;
}


Future<User> update(User user) async {
  //final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final Uri url = Uri.parse('${Utils.restURL}users/${currentUser.value.UserID}');
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body));
  return currentUser.value;
}

