import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  User({this.UserID, this.UserName, this.Password,this.PasswordStored, this.Mobile, this.Active, this.IsEmployee,  this.Salary, this.EmpCode, this.apiToken, this.deviceToken,this.auth});
  //User({this.UserID, this.UserName, this.Password,this.PasswordStored});

  // preview from Database
  User.fromJSON(Map<String, dynamic> jsonMap){
    UserID = jsonMap['UserID'] as int;
    UserName=jsonMap['UserName'].toString() ;
    Password =jsonMap["Password"] .toString() ;
    PasswordStored =jsonMap["PasswordStored"] .toString() ;
    Mobile =jsonMap["Mobile"].toString()  ;
    Active =  jsonMap['Active']  as bool;
    IsEmployee =  jsonMap['IsEmployee'] as bool ;
    EmpCode =jsonMap["EmpCode"] .toString()  ;
    Salary =jsonMap["Salary"] as double ;
    apiToken = jsonMap['api_token'].toString() ;
    deviceToken = jsonMap['device_token'] .toString();

    }


// insert in database
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["UserID"]  = UserID  ;
    map["UserName"] = UserName ;
    map["Password"] = Password.toString() ;
    map["PasswordStored"] = PasswordStored.toString() ;
    map["Mobile"] = Mobile ;
    map["Active"] = Active ;
    map["IsEmployee"] = IsEmployee ;
    map["EmpCode"] = EmpCode ;
    map["Salary"] = Salary ;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
   //map["media"] = image?.toMap();
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    return map.toString();
  }

  @override
  bool operator ==(dynamic user) {
    return user.UserID == this.UserID;
  }
}








ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<List<User>> getUsers() async {
  final String url = '${Utils.restURL}user';
  final client = new http.Client();
  final streamedRest = await client.get( Uri.parse(url),headers: { 'Authorization': Utils.basicAuth, });
  var _code = 'getUser Code = ' + streamedRest.statusCode.toString();
  print(_code);
  final responseJson = jsonDecode(streamedRest.body).cast<Map<String, dynamic>>();
  return responseJson.map<User>((json) => User.fromJSON(json)).toList();
}

Future<User> loginCurrentUser(User user) async {
  final String url =  '${Utils.restURL}user/${user.UserID}' ;
  final client = new http.Client();
  final response = await client.get( Uri.parse(url) , headers: {'Authorization': Utils.basicAuth }, );
  print(response);
  if (response.statusCode == 200)
  {
    setCurrentUser(response.body);
    //must return all data (entitiy) from api
    //[0] for one row
    currentUser.value = User.fromJSON(json.decode(response.body)[0]);
  }
  return currentUser.value;
}

Future<User> registerNewUser(User user) async {
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

Future<User> updateUser(User user) async {
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

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString) != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)[0]));
  }
}
Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.clear();
  if (currentUser.value.UserID == null && prefs.containsKey('current_user')) {
    currentUser.value = User.fromJSON(json.decode(await prefs.get('current_user')));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  currentUser.notifyListeners();
  return currentUser.value;
}


Object getData(Map<String, dynamic> data) {
  return data['data'] ?? [];
}




