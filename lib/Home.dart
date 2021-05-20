import 'dart:convert';
import 'package:contractor_expenses/Pages/Settings.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts_arabic/fonts.dart';

import 'Pages/DashBoard.dart';
import 'Pages/Expenses.dart';
import 'Pages/Wallet.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 1,
      upperBound: 1.3
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  int _currentTab =0;
  List<Widget> screens = [
    DashBoard(),
    Expenses(),
    Wallet(),
  ];

  Widget CurrentScreen = DashBoard();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: leadingWidget(),
        leadingWidth: 160,
        actions: [

        ],
      ),

      body: PageStorage(
        bucket: bucket,
        child: CurrentScreen,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _controller.forward().then((value) => _controller.reverse());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 1,
        child: Container(
          height: 60,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ScaleTransition(
                    scale: _controller,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width/5,
                      onPressed: () {
                        setState(() {
                          CurrentScreen = DashBoard();
                          _currentTab = 0;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home,color: _currentTab == 0 ?  Color(0xFF2EBF70) : Colors.grey,size: 28,),
                        Text('الرئيسية' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,
                            color: _currentTab == 0 ?  Color(0xFF2EBF70) : Colors.grey
                        ),)
                      ],
                    ),
                    ),
                  ),
                  ScaleTransition(
                    scale: _controller,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width/5,
                      onPressed: () {
                        setState(() {
                          CurrentScreen = Expenses();
                          _currentTab = 1;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments,color: _currentTab == 1 ?  Color(0xFF2EBF70) : Colors.grey,size: 28,),
                        Text('المصروفات' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,
                            color: _currentTab == 1 ?  Color(0xFF2EBF70) : Colors.grey
                        ),)
                      ],
                    ),
                    ),
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width/5,
                    onPressed: () {
                      setState(() {
                        CurrentScreen = Wallet();
                        _currentTab = 2;
                        _controller.forward().then((value) => _controller.reverse());
                      });
                    },child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet,color: _currentTab == 2 ?  Color(0xFF2EBF70) : Colors.grey,size: 28,),
                      Text('المحفظة' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,
                          color: _currentTab == 2 ?  Color(0xFF2EBF70) : Colors.grey
                      ),)
                    ],
                  ),
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width/5,
                    onPressed: () {
                      setState(() {
                        CurrentScreen = Settings();
                        _currentTab = 3;
                        _controller.forward().then((value) => _controller.reverse());
                      });
                    },child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt,color: _currentTab == 3 ?  Color(0xFF2EBF70) : Colors.grey,size: 32,),
                      Text('الاعدادات' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,
                          color: _currentTab == 3 ?  Color(0xFF2EBF70) : Colors.grey
                      ),)
                    ],
                  ),
                  )

                ],
              ),
            ],
          )


        ),
      ),
    );
  }


  Widget leadingWidget(){
    return Row(
      children: [
        IconButton(icon: Icon(Icons.filter_list,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        SizedBox(width: 5,),
        IconButton(icon: Icon(Icons.save,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        // SizedBox(width: 5,),
        // IconButton(icon: Icon(Icons.settings,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        //
      ],
    );
  }

}


