import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home.dart';
import './screens/parkability.dart';
import './screens/report_overview_screen.dart';
import './provider/report_provider.dart';
import './screens/splash-screen.dart';

import './screens/auth_screen.dart';
import './provider/auth.dart';
import './provider/parkingLotProvider.dart';

import './screens/user_previous_reports.dart';

// import './screens/user_profile_screen.dart';
import './screens/report_detail_screen.dart';

import './screens/user_profile.dart';

import './screens/view_history_screen.dart';
// import 'package:firebase/firebase.dart';
// import 'package:firebase/firestore.dart' as fs;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ReportsProvider>(
          initialBuilder: (_) => ReportsProvider(
            null,
            null,
          ),
          builder: (_, auth, previousReports) {
            previousReports.authToken = auth.token;
            previousReports.userId = auth.userId;
            previousReports.reports == null ? [] : previousReports.reports;
            return previousReports;
          },
        ),
        ChangeNotifierProvider.value(
          value: ParkingLotProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'C-Parking',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            // backgroundColor: Color.fromRGBO(120, 132, 158, 100),
            //rgba(120, 132, 158, 1)
            accentColor: Colors.white,
            primaryColorDark: Colors.black,
            // primaryColor:   Color(#003c7e),
            fontFamily: 'Raleway',
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // HomeScreen.routeName: (ctx) => HomeScreen(),
            Parkability.routeName: (ctx) => Parkability(),
            UserProfile.routeName: (ctx) => UserProfile(null, null),
            ReportOverViewScreen.routeName: (ctx) => ReportOverViewScreen(),
            UserPreviousReports.routeName: (ctx) => UserPreviousReports(),
            ReportDetailScreen.routeName: (ctx) => ReportDetailScreen(),
            ViewHistoryScreen.routeName: (ctx) => ViewHistoryScreen(),
            // SimpleLineChart.routeName: (ctx) => SimpleLineChart(null),
            // AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _primaryValue = 0x78849E;

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
