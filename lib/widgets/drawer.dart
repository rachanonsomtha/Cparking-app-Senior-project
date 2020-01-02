import '../provider/report.dart';
import 'package:flutter/material.dart';
import '../screens/report_overview_screen.dart';
import '../screens/Parkability.dart';
import '../screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'images/logo_cpark.png',
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(
            endIndent: 5,
          ),
          ListTile(
            leading: Icon(Icons.portrait),
            title: Text('Profile'),
            onTap: () {},
          ),
          Divider(
            endIndent: 5,
          ),
          ListTile(
            leading: Icon(Icons.restore_page),
            title: Text('Previous report'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReportOverViewScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
