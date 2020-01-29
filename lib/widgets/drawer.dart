import 'package:cparking/screens/user_profile.dart';
import 'package:flutter/material.dart';
// import 'package:step5/routes/Routes.dart';
// import '../screens/report_overview_screen.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';
import '../screens/home.dart';
import '../screens/user_previous_reports.dart';
// import '../screens/user_profile_screen.dart';

class AppDrawer extends StatelessWidget {
  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.of(context).pushNamed('/');
              }),
          Divider(),
          _createDrawerItem(
            icon: Icons.portrait,
            text: 'Profile',
            onTap: () async {
              // navigateToPage(context, '/');
              Provider.of<Auth>(context).fetchUserProfileData();
              Navigator.of(context).pushNamed(UserProfile.routeName);
            },
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.skip_previous,
              text: 'Previous reports',
              onTap: () {
                // navigateToPage(context, ReportOverViewScreen.routeName);
                Provider.of<Auth>(context).fetchUserProfileData();
                Navigator.of(context).pushNamed(UserPreviousReports.routeName);
              }),
          Divider(),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Logout',
            onTap: () => authData.logOut(),
          ),
          ListTile(
            title: Text('V:0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      // margin: EdgeInsets.all(10),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        // color: CompanyColors.blue[500],
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('images/logo_cpark.png'),
        ),
      ),
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text(
            "",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      key: Key(
        text.toString(),
      ),
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _primaryValue = 0xFF001957;

  static const MaterialColor blue = const MaterialColor(
    _primaryValue,
    const <int, Color>{
      50: const Color(0xFFe0e0e0),
      100: const Color(0xFFb3b3b3),
      200: const Color(0xFF808080),
      300: const Color(0xFF4d4d4d),
      400: const Color(0xFF262626),
      500: const Color(_primaryValue),
      600: const Color(0xFF000000),
      700: const Color(0xFF000000),
      800: const Color(0xFF000000),
      900: const Color(0xFF000000),
    },
  );
}
