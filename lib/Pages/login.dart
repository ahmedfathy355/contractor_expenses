import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';
import '../Models/user.dart';
import '../Utility/utils.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> loginScaffoldKey = new GlobalKey<ScaffoldState>();

  User cuUser = new User();
  List<User> listUsers = <User>[];
  bool isLoading = false;
  bool showIndicator = false;
  var txtEmpID  ;
  var txtEmpPassword  ;
  bool _rememberMeFlag = true;
  bool _secureText = true;
  final controllerEmpPass = TextEditingController();
  User _selectedUserValue ;

  StreamSubscription connectivityStream;
  ConnectivityResult  connectivityResult;



  void listenForUsers() async {
    List<User> _user = await getUsers();
    print(_user);
    if (!listUsers.contains(_user)) {
      setState(() {
        listUsers = _user;
      });
    }
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loginCurrentUser(_selectedUserValue).then((value) {
        if (value != null && value.UserID != null) {
          loginScaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Welcome " + value.UserName), ));
          Navigator.pushReplacementNamed(context, '/Home');

        } else {
          loginScaffoldKey.currentState.showSnackBar(SnackBar( content: Text("wrong username or password"), ));
        }
      }).catchError((error) => print(error));
    }
  }

  Container dropdownUsers(){
   return Container(
      width: MediaQuery.of(context).size.width - 60,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(10),
          border: Border.all(width: 0.1, style: BorderStyle.solid),
          color: Colors.white
      ),
      child: new DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _selectedUserValue,
          onChanged: (User value) {
            setState(() {
              _selectedUserValue = value;
              cuUser.UserName = value.UserName;
              cuUser.UserID = value.UserID;
            });
          },
          items: _dropListUsers(),
          style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,fontWeight: FontWeight.w100,color: Colors.black),
          icon: Icon(Icons.arrow_drop_down_circle  ,color: Color(0xFF2EBF70),),
          hint: Text("اختر الموظف") ,
        ),
      ) ,
    );
  }

  List<DropdownMenuItem<User>> _dropListUsers(){
    return listUsers.map((e) => DropdownMenuItem<User>(value: e , child: Text(e.UserName),)).where((i) => i.value.IsEmployee== false ).toList();
    //return listUsers.map((e) => DropdownMenuItem<User>(value: e , child: Text(e.UserName),)).toList();
  }

  @override
  void initState() {
    isPingHost();
    listenForUsers();
    super.initState();
  }

  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: loginScaffoldKey,
      backgroundColor: const Color(0xfff2f4f7),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
//          //logo
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/app_logo.PNG'),
                  ),
                ),
                SizedBox(height: 20,),

                Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    listUsers.isEmpty ?
                       Container(
                         child: CircularProgressIndicator(),
                       )
                      :dropdownUsers(),
                      SizedBox(height: 10,),
                      // Password
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 0.1,color: const Color(0xff0d2137))
                        ),
                        child: TextFormField(
                          controller: controllerEmpPass,
                          keyboardType: TextInputType.text,
                          obscureText: _secureText,
                          style:TextStyle(
                            fontFamily: 'NeoSans',
                            //fontFamily: 'Roboto',
                            fontSize: 14,
                            color: const Color(0xff0d2137),
                            fontWeight: FontWeight.w100
                          ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            prefixIcon: Icon(Icons.lock , color: const Color(0xFF2EBF70),) ,
                            hintText: "كلمة المرور" ,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          onFieldSubmitted:(_) => FocusScope.of(context).unfocus(),
                          onSaved: (input) => cuUser.PasswordStored = input,
                          // ignore: missing_return
                          validator: (value){
                            if(value.isEmpty)
                            {return "يرجى إدخال كلمة مرور" ;}
                            else{
                              txtEmpPassword = value ;
                            }
                          },
                        ),
                      ),
                      //remmember
                      Container(
                        margin: new EdgeInsets.only(left: 31.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: Colors.grey,
                              value: _rememberMeFlag,
                              onChanged: (value) => setState(() {
                                _rememberMeFlag = !_rememberMeFlag;
                              }),
                            ),
                            new Text(
                             "Remember me",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: const Color(0xff696969),
                              ),
                            )
                          ],
                        ),
                      ),
                      //button login
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        height: 50,
                        child: new  RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                          ),
                          color:  const Color(0xFF2EBF70),
                          highlightColor: Colors.blueGrey,
                          elevation: 5,
                          onPressed: (){
                            login();
                          },
                          child:  showIndicator ? CircularProgressIndicator() : Text(
                            'دخول',
                            style: TextStyle(
                              fontFamily: 'NeoSans',
                              fontSize: 24,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
//                          Ink(
//                              decoration: const BoxDecoration(
//                                gradient:LinearGradient(
//                                  colors: <Color>[Colors.blue, Colors.purple],
//                                ),
//                                borderRadius: BorderRadius.all(Radius.circular(80.0)),
//                              ),
//                            child:
//                          )

                        ),
                      ),
                      //Forgot password
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                       Container(
                        margin: new EdgeInsets.only(right: 5.0,left: 5),
                        child: FlatButton(
                          onPressed: () {
                            //Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                            child:Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: const Color(0xff696969),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ubuntu-eg.com'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('to reset password contact your administrator'),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



/////////////check conniction

  void listenForConnection() async{
    connectivityStream = Connectivity().onConnectivityChanged.listen((ConnectivityResult new_result) {
      if(new_result == ConnectivityResult.none){
        setState(() {
          Utils.isConnected = false;
        });
      }
      else if (new_result == ConnectivityResult.wifi || new_result == ConnectivityResult.mobile ){
        setState(() {
          Utils.isConnected = true;
        });
      }
      connectivityResult = new_result;
    });
  }

  void isPingHost() async{
    try{
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty)
      {
        setState(() {
          Utils.isConnected = true;
        });
      }
      else{
        setState(() {
          Utils.isConnected = false;
        });
      }
    } on SocketException catch(_){
      setState(() {
        Utils.isConnected = false;
      });
    }
  }

  void checkConnectivity() async{
    try{
      final conn_result = await (Connectivity().checkConnectivity()) ;
      if(conn_result == ConnectivityResult.mobile || conn_result == ConnectivityResult.wifi)
      {
        setState(() {
          Utils.isConnected = true;
        });
      }
      else if(conn_result == ConnectivityResult.none){
        Utils.isConnected = false;
      }
    } on SocketException catch(_){
      Utils.isConnected = false;
    }
  }
}



