import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          // primaryColor: Color(0xFF2EBF70),
          // accentColor: Color(0xFF0EAD6A),
          primaryColor: Color(0xFF73A7A3),
          accentColor: Color(0xFF44848E),
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


