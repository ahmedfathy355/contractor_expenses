import 'package:contractor_expenses/Utility/utils.dart';

import '../Widgets/AddExpenses.dart';
import '../Widgets/DailyReport.dart';
import '../Widgets/Statistics.dart';
import 'package:flutter/material.dart';
import '../Widgets/DrawerWidget.dart';

class DashBoard extends StatefulWidget {
  GlobalKey<ScaffoldState> parentScaffoldKey  = GlobalKey<ScaffoldState>();
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>  {


  GlobalKey<NavigatorState> _key = GlobalKey();
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
              key: widget.parentScaffoldKey,
              drawer: DrawerWidget(),
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
                    Tab(child: Text('الاحصائيات',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,fontWeight: FontWeight.w100),)),
                    Tab(child: Text('التقارير',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,fontWeight: FontWeight.w100),)),
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
        IconButton(icon: Icon(Icons.filter_list,color: Colors.white,size: 28,) ,
          onPressed: () {
             widget.parentScaffoldKey.currentState.openDrawer();
          }, ),
        SizedBox(width: 5,),
        IconButton(icon: Icon(Icons.save,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        // SizedBox(width: 5,),
        //IconButton(icon: Icon(Icons.settings,color: Colors.white,size: 28,) ,onPressed: () {  }, ),
        //
      ],
    );
  }



}

