import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'Pages/DashBoard.dart';
import 'Pages/Expenses.dart';
import 'Pages/Settings.dart';
import 'Pages/Wallet.dart';
import 'Models/route_argument.dart';
import 'Widgets/AddExpenses.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  final RouteArgument routeArgument;
  Home({Key key, this.routeArgument }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    initializeSetting();
    tz.initializeTimeZones();
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

  Widget currentScreen = DashBoard();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: ScaleTransition(
          scale: _controller,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _controller.forward().then((value) => _controller.reverse());
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenses() ));
              displayNotification('New Expenses Added', DateTime.parse('2021-05-19 00:29:00.090427+0500'));
            },
          ),
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
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width/5,
                      onPressed: () {
                        setState(() {
                          currentScreen = DashBoard();
                          _currentTab = 0;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home,color: _currentTab == 0 ?  Color(0xFF69BD43) : Colors.grey,size: 28,),
                        Text('الرئيسية' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,fontWeight: FontWeight.w100,
                            color: _currentTab == 0 ?  Color(0xFF69BD43) : Colors.grey
                        ),)
                      ],
                    ),
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width/5,
                      onPressed: () {
                        setState(() {
                          currentScreen = Expenses();
                          _currentTab = 1;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payments,color: _currentTab == 1 ?  Color(0xFF69BD43) : Colors.grey,size: 28,),
                        Text('المصروفات' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,fontWeight: FontWeight.w100,
                            color: _currentTab == 1 ?  Color(0xFF69BD43) : Colors.grey
                        ),)
                      ],
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
                          currentScreen = Wallet();
                          _currentTab = 2;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet,color: _currentTab == 2 ?  Color(0xFF69BD43) : Colors.grey,size: 28,),
                        Text('المحفظة' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,fontWeight: FontWeight.w100,
                            color: _currentTab == 2 ?  Color(0xFF69BD43) : Colors.grey
                        ),)
                      ],
                    ),
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width/5,
                      onPressed: () {
                        setState(() {
                          currentScreen = Settings();
                          _currentTab = 3;
                        });
                      },child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt,color: _currentTab == 3 ?  Color(0xFF69BD43) : Colors.grey,size: 32,),
                        Text('الاعدادات' ,style: TextStyle(fontFamily: 'NeoSans',fontSize: 12,fontWeight: FontWeight.w100,
                            color: _currentTab == 3 ?  Color(0xFF69BD43) : Colors.grey
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
      ),
    );
  }
  DateTime currentBackPressTime;
  Future<bool> _onWillPop() async {

    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      //Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
    //
    // // This dialog will exit your app on saying yes
    // return (await showDialog(
    //   context: context,
    //   builder: (context) => new AlertDialog(
    //     title: new Text('Are you sure?'),
    //     content: new Text('Do you want to exit an App'),
    //     actions: <Widget>[
    //       new FlatButton(
    //         onPressed: () => Navigator.of(context).pop(false),
    //         child: new Text('No'),
    //       ),
    //       new FlatButton(
    //         onPressed: () => Navigator.of(context).pop(true),
    //         child: new Text('Yes'),
    //       ),
    //     ],
    //   ),
    // )) ??
    //     false;
  }

Future<void> displayNotification(String match, DateTime dateTime) async {

  notificationsPlugin.show(
      0,
      match,
      'Review Today Records',
      NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name', 'channel description'),
        iOS:  IOSNotificationDetails(
            presentAlert: false,  // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentBadge: false,  // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            presentSound: false,  // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
            sound: '',  // Specifics the file path to play (only from iOS 10 onwards)
            badgeNumber: 1, // The application's icon badge number

            subtitle: 'مصاريف المقاولات', //Secondary description  (only from iOS 10 onwards)
            //threadIdentifier: String? (only from iOS 10 onwards)
        ),
      ),
      payload: 'item x');
}
}

void initializeSetting() async {
  var initializeAndroid = AndroidInitializationSettings('logo');
  var initializeSetting = InitializationSettings(android: initializeAndroid);
  await notificationsPlugin.initialize(initializeSetting);
}


