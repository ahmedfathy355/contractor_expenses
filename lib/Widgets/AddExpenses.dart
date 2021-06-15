import 'package:contractor_expenses/Widgets/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({Key key}) : super(key: key);

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final TextEditingController _textController = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
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
          moneyAmount(context),
          //SizedBox(height: 10,),
          fromAccountItem(),
          Divider(height: 1,),
          toAccountItem(),
          Divider(height: 1,),
          remarks(),
          Divider(height: 1,),
          duoDate(),
          Divider(height: 1,),
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
            hintStyle: TextStyle(fontFamily: 'NeoSans',fontSize: 16,fontWeight: FontWeight.w100),
            prefixIcon: IconButton(icon: Icon(Icons.calculate_sharp),iconSize: 32,
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
  String _fromdropDownValue;

  Widget fromAccountItem(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB( 16,10,16,10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.remove_circle_outline  ,color: Colors.grey,),
            hint: _fromdropDownValue == null
                ? Text('من حساب',style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,fontWeight: FontWeight.w100),)
                : Text(
              _fromdropDownValue,
              style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
            ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
            items: _items.map(
                  (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                    () {
                      _fromdropDownValue = val;
                },
              );
            },
          ),
        ),
      ),
    );

  }

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
                  ? Text('الى حساب ',style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,fontWeight: FontWeight.w100),)
                  : Text(
                _todropDownValue,
                style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black,fontWeight: FontWeight.w100),
              ),
            )
        ) ,



      ),
    );

  }

  Widget remarks(){
    return Container(
      padding: EdgeInsets.fromLTRB( 16,0,16,0),
      color: Colors.white,
      child: TextFormField(
        cursorColor: Theme.of(context).cursorColor,
        initialValue: '',
        maxLength: 100,

        decoration: InputDecoration(
         // icon: Icon(Icons.favorite),

          labelText: 'البند',
          labelStyle: TextStyle(
            color: Color(0xFF69BD43),
          ),
          //helperText: 'Helper text',
          suffixIcon:  Icon(
            Icons.notes,
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
      padding: EdgeInsets.fromLTRB( 16,5,16,5),
      color: Colors.white,
      height: 40,
      child: Row(
        children: [
          Text('data'),
          GestureDetector(
              child : Container(
                  child: Text('ddd')),
                  onTap: () {
                  selectTimePicker(context);
              }
          ),
          Text(date.toString()),
        ],
      ),
    );
  }

  Widget imageOrCamera(){
    return Container(
      color: Colors.white,
      height: 20,
    );
  }

  Widget btnAdd(){
    return Container(
      color: Colors.white,
      height: 20,
    );
  }


}

