import 'package:contractor_expenses/Widgets/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/flutter_calculator.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({Key key}) : super(key: key);

  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final TextEditingController _textController = TextEditingController(text: '0.00');


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
          txt_MoneyAmount(context),
          SizedBox(height: 10,),
          FromAccountItem(),
          Divider(height: 1,),
          ToAccountItem(),
          SizedBox(height: 10,),
          DuoDate(),
          SizedBox(height: 10,),
          ImageOrCamera(),
          SizedBox(height: 100,),
          btn_Add()
        ],
      ) ,
    );
  }


  Widget txt_MoneyAmount(BuildContext context){
    return Container(
      padding: EdgeInsets.all( 40),
      color: Colors.white,
      child: TextField(
        controller: this._textController,
        decoration: InputDecoration(
            hintText: 'المبلغ',
            hintStyle: TextStyle(fontFamily: 'NeoSans',fontSize: 16),
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

  List<String> _Items = ['العهدة'];
  String _FromdropDownValue;

  Widget FromAccountItem(){
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: Icon(Icons.remove_circle_outline  ,color: Colors.grey,),
            hint: _FromdropDownValue == null
                ? Text('من حساب',style: TextStyle(fontFamily: 'NeoSans',fontSize: 16),)
                : Text(
              _FromdropDownValue,
              style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black),
            ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black),
            items: _Items.map(
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
                      _FromdropDownValue = val;
                },
              );
            },
          ),
        ),
      ),
    );

  }

  List<String> _AccountItems = ['مشروع 1'];
  String _TodropDownValue;

  Widget ToAccountItem(){
    return Container(
      color: Colors.white,
      padding: new EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DropdownButtonHideUnderline(
            child: DropdownButton(
              style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black),
              isExpanded: true,
              value: _TodropDownValue,
              onChanged: (value) {
                setState(() {
                  _TodropDownValue = value;
                });
              },
              items: _AccountItems.map(
                    (val) {
                  return DropdownMenuItem<String> (
                    value: val,
                    child: Text(val),
                  );
                },
              ).toList(),
              icon: Icon(Icons.add_circle_outline  ,color: Colors.grey,),
              iconSize: 30,

              hint: _TodropDownValue == null
                  ? Text('الى حساب ',style: TextStyle(fontFamily: 'NeoSans',fontSize: 16),)
                  : Text(
                _TodropDownValue,
                style: TextStyle(fontFamily: 'NeoSans',fontSize: 16,color: Colors.black),
              ),
            )
        ) ,



      ),
    );

  }
  Widget DuoDate(){
    return Container(
      color: Colors.white,
      height: 20,
    );
  }
  Widget ImageOrCamera(){
    return Container(
      color: Colors.white,
      height: 20,
    );
  }
  Widget btn_Add(){
    return Container(
      color: Colors.white,
      height: 20,
    );
  }
}

