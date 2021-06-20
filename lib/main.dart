import 'package:contractor_expenses/Pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'route_generator.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyApp createState() => _MyApp();
}


class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
  }
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
           primaryColor: Color(0xFF2EBF70),
           accentColor: Color(0xFF0EAD6A),
          //primaryColor: Color(0xFF2B5565),
          //accentColor: Color(0xFF2B5565),
          visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/Splash',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}


