import 'package:contractor_expenses/Models/user.dart';
import 'package:contractor_expenses/Pages/login.dart';
import 'package:flutter/material.dart';
import '../Home.dart';
import '../Models/user.dart' as userModel;


class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {

     new Future.delayed(const Duration(seconds: 2), () async {
       await userModel.getCurrentUser();
       if(currentUser.value.UserID != null){
         Navigator.pushReplacementNamed(context, '/Home');
       }
       else{
         Navigator.pushReplacementNamed(context, '/Login');
       }

     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/app_logo.PNG',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }











}

