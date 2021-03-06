import 'package:flutter/material.dart';
import '../Home.dart';
import '../Models/user.dart';
import '../Pages/login.dart';
import '../Utility/Setting/change_password.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.UserID != null ? Navigator.of(context).pushNamed('/Home') : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.UserID != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.UserName,
                      style: Theme.of(context).textTheme.title,
                    ),
                    accountEmail: Text(
                      currentUser.value.Mobile.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      //backgroundColor: Theme.of(context).accentColor,
                      backgroundColor: Colors.grey,
                      //backgroundImage: NetworkImage(currentUser.value.image.thumb),
                      backgroundImage: AssetImage('assets/images/app_logo.PNG'),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EAD6A),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(9),
                        ),
                        SizedBox(width: 30),
                        Text(
                          "guest",
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    ),
                  ),
          ),

          ListTile(
            onTap: () {
              //Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Home(parentScaffoldKey: scaffoldKey,)));
            },
            leading: Icon(
              Icons.home,
              color: const Color(0xFF0EAD6A),
            ),
            title: Text(
              "????????????????",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),


          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: Icon(
              Icons.notifications,
              color: const Color(0xFF0EAD6A),
            ),
            title: Text(
              "??????????????????",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),

//          ListTile(
//            dense: true,
//            title: Text(
//              "application preferences",
//              style: Theme.of(context).textTheme.body1,
//            ),
//            trailing: Icon(
//              Icons.remove,
//              color: Colors.deepPurple,
//            ),
//          ),

          ListTile(
            onTap: () {
              if (currentUser.value.UserID != null) {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => change_password()));
              } else {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Login()));
              }
            },
            leading: Icon(
              Icons.settings,
              color: const Color(0xFF0EAD6A),
            ),
            title: Text(
              "?????????? ???????? ????????????",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),

          ListTile(
            onTap: () {
              if (currentUser.value.UserID != null) {
                logout().then((value) {
                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Login()));
                });
             } else {
               Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Home()));
             }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: const Color(0xFF0EAD6A),
            ),
            title: Text(
              currentUser.value.UserID != null ? "?????????? ????????": "login"  ,
              style: Theme.of(context).textTheme.subhead,
            ),
          ),

        ],
      ),
    );
  }
}
