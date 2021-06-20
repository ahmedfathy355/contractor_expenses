import 'package:contractor_expenses/Models/accountItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DrawerWidget.dart';
import '../Widgets/SearchBarWidget.dart';
class ProjectExpensesItems extends StatefulWidget {
  const ProjectExpensesItems({Key key}) : super(key: key);

  @override
  _ProjectExpensesItemsState createState() => _ProjectExpensesItemsState();
}

class _ProjectExpensesItemsState extends State<ProjectExpensesItems> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<AccountItems> _projectAccountItems =  <AccountItems>[];
  List<AccountItems> selectedProjectAccountItem =  <AccountItems>[];


  @override
  void initState() {
    loadAccountItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          //onPressed: () => Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: _con.market.id, heroTag: 'menu_tab')),
        ),
        title: Text(
         'اختر بند',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: SearchBarWidget(),
            // ),
            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.bookmark_outline,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     '',
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle: Text(
            //     'S.of(context).clickOnTheProductToGetMoreDetailsAboutIt',
            //     maxLines: 2,
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),
            //ProductsCarouselWidget(heroTag: 'menu_trending_product', productsList: _con.trendingProducts),
            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.subject,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     'S.of(context).products',
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle: Text(
            //     'S.of(context).clickOnTheProductToGetMoreDetailsAboutIt',
            //     maxLines: 2,
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),
            _projectAccountItems.isEmpty
                ? SizedBox(height: 90)
                : Container(
              height: 90,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(_projectAccountItems.length, (index) {
                  var _items = _projectAccountItems.elementAt(index);
                  var _selected = this.selectedProjectAccountItem.contains(_items.id);
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: RawChip(
                      elevation: 0,
                      label: Text(_items.accountItemName),
                      labelStyle: _selected
                          ? Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor))
                          : Theme.of(context).textTheme.bodyText2,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                      selectedColor: Theme.of(context).accentColor,
                      selected: _selected,
                      //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                      showCheckmark: false,
                      avatar: (_items.id == 0)
                          ? null
                          : Image.asset(
                        'assets/images/wallet_32.png',
                        fit: BoxFit.cover,
                      ),
                      onSelected: (bool value) {
                        setState(() {
                          if (_items.id == 0) {
                            this.selectedProjectAccountItem = _projectAccountItems;
                          } else {
                            this.selectedProjectAccountItem.removeWhere((element) => element == '0');
                          }
                          if (value) {
                            this.selectedProjectAccountItem.add(_items);
                          } else {
                            this.selectedProjectAccountItem.removeWhere((element) => element == _items.id);
                          }
                          //_con.selectCategory(this.selectedProjectAccountItem);
                        });
                      },
                    ),
                  );
                }),
              ),
            ),

          ],
        ),
      ),

    );
  }

  void loadAccountItems() async {
    List<AccountItems> _accountItems = await getAccountItems();
    if(_accountItems.length > 0){
      setState(() {
        _projectAccountItems = _accountItems;
      });
    }
  }
}
