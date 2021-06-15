import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Home.dart';
import '../Pages/login.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('ar', ''), // arabic, no country code
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
           primaryColor: Color(0xFF2EBF70),
           accentColor: Color(0xFF0EAD6A),
          //primaryColor: Color(0xFF2B5565),
          //accentColor: Color(0xFF2B5565),
          visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      debugShowCheckedModeBanner: false,
      home: currentUser.value.UserID == null  ? Login() : Home() ,

    );
  }
}


