import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts_arabic/fonts.dart';

import 'Pages/DashBoard.dart';
import 'Pages/Expenses.dart';
import 'Pages/Wallet.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentTab ;
 List<Widget> screens = [
   DashBoard(),
   Expenses(),
   Wallet(),
 ];

 Widget CurrentScreen = DashBoard();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: leadingWidget(),
        leadingWidth: 150,
        actions: [

        ],
      ),

      body: Container(),

    );
  }


  Widget leadingWidget(){
    return Row(
      children: [
        IconButton(icon: Icon(Icons.menu,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        SizedBox(width: 5,),
        IconButton(icon: Icon(Icons.save,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        SizedBox(width: 5,),
        IconButton(icon: Icon(Icons.settings,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
      ],
    );
  }

}


