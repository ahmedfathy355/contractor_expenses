import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Widgets/DrawerWidget.dart';
import '../Widgets/project_ExpensesItems.dart';
import '../Widgets/other_ExpensesItems.dart';

class TabExpensesItems extends StatefulWidget {
  const TabExpensesItems({Key key}) : super(key: key);

  @override
  _TabExpensesItemsState createState() => _TabExpensesItemsState();
}

class _TabExpensesItemsState extends State<TabExpensesItems> {

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
              key: _key,
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
                      Tab(child: Text('مصاريف المشروعات',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,fontWeight: FontWeight.w100),)),
                      Tab(child: Text('مصاريف عامة',style: TextStyle(fontFamily: 'NeoSans',color: Colors.white,fontWeight: FontWeight.w100),)),
                    ]
                ),
              ),
              body: TabBarView(
                  children:  <Widget>[
                    ProjectExpensesItems(),
                    OtherExpensesItems(),
                  ]
              ),
            );
          }
      ),
    );

  }
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
