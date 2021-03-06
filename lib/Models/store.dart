import 'dart:convert';
import 'dart:io';
import '../Utility/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  String StoreID;
  String StoreName;
  String Active;


  Store({this.StoreID, this.StoreName, this.Active});

  factory Store.fromJSON(Map<String, dynamic> jsonMap) => Store(
    StoreID : jsonMap['StoreID'].toString(),
    StoreName : jsonMap['StoreName'],
    Active :  jsonMap['Active'].toString(),
  );

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["StoreID"] = StoreID;
    map["StoreName"] = StoreName;
    map["Active"] = Active;
    return map;
  }
  @override
  String toString() {
    var map = this.toMap();
    return map.toString();
  }
}

ValueNotifier<Store> currentStore = new ValueNotifier(Store());

Future<Store> single_store(Store store) async {
  final Uri url = '${Utils.restURL}stores' as Uri;
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(store.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentStore(response.body);
    currentStore.value = Store.fromJSON(json.decode(response.body));
  }
  return currentStore.value;
}

void setCurrentStore(jsonString) async {
  if (json.decode(jsonString) != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_store', json.encode(json.decode(jsonString)));
  }
}

Future<Stream<Store>> getStores() async {
  final String url = '${Utils.restURL}stores/2';

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
      .map((data) => Store.fromJSON(data));
}

Future<Store> getCurrentStore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
//  prefs.clear();
  if (prefs.containsKey('current_store')) {
    currentStore.value = Store.fromJSON(json.decode(await prefs.get('current_store')));
  } else {
    //currentStore.value.auth = false;
  }
  currentStore.notifyListeners();
  return currentStore.value;
}

