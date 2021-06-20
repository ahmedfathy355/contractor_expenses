import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:contractor_expenses/Widgets/project_ExpensesItems.dart';

import '../Models/accountItems.dart';
import '../Utility/utils.dart';
import '../Widgets/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:image_picker/image_picker.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({Key key}) : super(key: key);

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {

  StreamSubscription connectivityStream;
  ConnectivityResult  connectivityResult;

  final TextEditingController _textController = TextEditingController();

  List<AccountItems> listAccountItems = <AccountItems>[];

  DateTime date = DateTime.now();

  Future<Null> selectTimePicker(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context : context,
        initialDate: date,
        firstDate:DateTime(2000),
        lastDate:DateTime(2030)
    );
    if(picked != null && picked != date){
      setState((){
        date = picked;
      }
      );
    }
  }

  void listenForAccountItems() async {
    List<AccountItems> _accItems = await getAccountItems();
    print(_accItems);
    if (!listAccountItems.contains(_accItems)) {
      setState(() {
        listAccountItems = _accItems;
      });
    }
    else{

    }
  }

  @override
  void initState() {
    isPingHost();
    listenForAccountItems();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    connectivityStream.cancel();
    this._textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8EC),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      body: Column(
        children: [
            Utils.isConnected == false  ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 2),
                    height: 25,
                    color: Colors.red,
                    child: Center(child: Text("Server Offline , Last Update " + DateTime.now().year.toString() + "-" +DateTime.now().month.toString() + "-"+ (DateTime.now().day-1).toString() ,style: TextStyle(backgroundColor: Colors.red,color: Colors.white),)),
                  ),
                )
              ], ) : Container(),
          moneyAmount(context),
          //SizedBox(height: 10,),
          fromAccountItem(),
          Divider(height: 1,),
          toAccountItem(),
          Divider(height: 1,),
          remarks(),
          SizedBox(height: 10,),
          duoDate(),
          SizedBox(height: 10,),
          imageOrCamera(),
          Divider(height: 1,),
          //makeNotify(),

        //  btn_Add_Dock_bottom()
        ],
      ) ,
    );
  }

  Widget moneyAmount(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB( 40,10,40,10),
      color: Colors.white,
      child: TextField(
        controller: this._textController,
        decoration: InputDecoration(
            hintText: 'المبلغ',
            hintStyle: TextStyle(fontFamily: 'NeoSans',fontSize: 20,fontWeight: FontWeight.w100,color: Colors.grey),
            prefixIcon: IconButton(icon: Icon(Icons.calculate_sharp ,color: Colors.deepOrange,),iconSize: 32,
                onPressed: () {
                  this._showCalculatorDialog(context);
                }
            )
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: TextStyle(fontFamily: 'NeoSans',fontSize: 20 ,color: Color(0xFF364452)),
      ),

    );
  }

  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: this.context) ?? 0.00;
    this._textController.value = this._textController.value.copyWith(
      text: result.toStringAsFixed(2),
    );
  }

  List<String> _items = ['العهدة'];
  AccountItems _fromdropDownValue;

  Widget fromAccountItem(){
    return ListTile(
        dense: true,
        leading: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        tileColor: Colors.white,
        title: Text(
          'اختر بند المصروف',textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
        ),
        // subtitle: Text(
        //   'من البند',
        //   maxLines: 2,
        //   style: Theme.of(context).textTheme.caption,
        // ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ProjectExpensesItems()));
      },
      );


  }
  // Widget fromAccountItem(){
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.fromLTRB( 16,10,16,10),
  //     child: Directionality(
  //       textDirection: TextDirection.rtl,
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton(
  //           focusColor: Colors.lightBlueAccent,
  //           value: _fromdropDownValue,
  //           icon: Icon(Icons.remove_circle_outline  ,color: Colors.grey,),
  //           hint: _fromdropDownValue == null ? Text('من حساب',)  : Text(  _fromdropDownValue.accountItemName, ),
  //           isExpanded: true,
  //           iconSize: 30.0,
  //           style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
  //           //items: _items.map((val) {return DropdownMenuItem<String>(value: val, child: Text(val), );},).toList(),
  //           items: listAccountItems.map((e) => DropdownMenuItem<AccountItems>(value: e , child: Text(e.accountItemName),)).where((element) => element.value.parentId  == 2).toList(),
  //           onChanged: (val) {
  //             setState(
  //                   () {
  //                 _fromdropDownValue = val;
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  //
  // }
  List<String> _accountItems = ['مشروع 1'];
  String _todropDownValue;

  Widget toAccountItem(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB( 16,10,16,10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
              style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
              isExpanded: true,
              value: _todropDownValue,
              onChanged: (value) {
                setState(() {
                  _todropDownValue = value;
                });
              },
              items: _accountItems.map(
                    (val) {
                  return DropdownMenuItem<String> (
                    value: val,
                    child: Text(val),
                  );
                },
              ).toList(),
              icon: Icon(Icons.add_circle_outline  ,color: Colors.grey,),
              iconSize: 30,

              hint: _todropDownValue == null
                  ? Text('الى حساب ',)
                  : Text(
                _todropDownValue,
              ),
            )
        ) ,
      ),
    );

  }

  var _remarksController = TextEditingController(text: "");
  Widget remarks(){
    return Container(
      padding: EdgeInsets.fromLTRB( 16,0,16,0),
      color: Colors.white,
      child: TextFormField(
        textAlign: TextAlign.right,
        controller: _remarksController,
        cursorColor: Theme.of(context).cursorColor,
        // initialValue: '',
        onChanged: (value) {
          setState(() {
            print(value);
          });
        },
        maxLength: 100,
        decoration: InputDecoration(
         // icon: Icon(Icons.favorite),
          labelText: 'البند',
          labelStyle: TextStyle(
            color: Color(0xFF69BD43),
          ),
          //helperText: 'Helper text',
          suffixIcon: _remarksController.text == "" ? Icon( Icons.notes)  : IconButton(
            onPressed: () => _remarksController.clear(),
            icon: Icon(Icons.clear),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF69BD43)),
          ),
        ),
      ),
    );
  }

  Widget duoDate(){
    return Container(
      padding: EdgeInsets.fromLTRB( 50,5,5,5),
      color: Colors.white,
      height: 40,
      child: GestureDetector(
        onTap: () {
          selectTimePicker(context);
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('hh:mm aa').format(DateTime.now()),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: 20,),
            Text(
              '${DateFormat('yyyy-MM-dd').format(date)}',
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 20,),

            Text('تاريخ المعاملة',style: Utils.kTitleStyle,),
          ],
        ),
      ),
    );
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utils.base64String(imgFile.readAsBytesSync());
      Photo photo = Photo(0, imgString);
      AccountImages img =
      AccountImages()..(photo);
      refreshImages();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photoName);
        }).toList(),
      ),
    );
  }
  Widget imageOrCamera(){
    return Container(
      color: Colors.white,
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.add_a_photo_rounded,color: Colors.grey,), onPressed: () {

          },),
          IconButton(icon: Icon(Icons.add_photo_alternate_rounded),color: Colors.grey, onPressed: () {

          },)

        ],
      ),
    );
  }

  Widget btnAdd(){
    return Container(
      color: Colors.white,
      height: 20,
      child: RaisedButton(onPressed: () {
        isPingHost();
        if(Utils.isConnected  )
        {
          Navigator.of(context).pop();
        }else{

        }
      },),
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

