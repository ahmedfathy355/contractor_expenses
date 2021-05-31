import 'package:contractor_expenses/Widgets/AddExpenses.dart';
import 'package:contractor_expenses/Widgets/DailyReport.dart';
import 'package:contractor_expenses/Widgets/Statistics.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>  {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                // Your code goes here.
                // To get index of current tab use tabController.index
              }
            });
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: leadingWidget(),
                leadingWidth: 160,
                actions: [
                ],
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  tabs: <Widget>[
                    Tab(child: Text('الاحصائيات',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,),)),
                    Tab(child: Text('التقارير',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,),)),
                  ]
                ),
              ),
              body: TabBarView(
                children:  <Widget>[
                  Statistics(),
                  DailyReport(),
                ]
              ),
            );
          }
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
        //IconButton(icon: Icon(Icons.settings,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        //
      ],
    );
  }



}

