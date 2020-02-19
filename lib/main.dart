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
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
            HomeScreen.routeName: (ctx) => HomeScreen(),
            Parkability.routeName: (ctx) => Parkability(),
            UserProfile.routeName: (ctx) => UserProfile(),
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

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.black,
    );
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    void _onIntroEnd(context) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }

    Widget _buildImage(String assetName) {
      return Align(
        child: Image.asset('images/$assetName.jpg', width: 350.0),
        alignment: Alignment.topLeft,
      );
    }

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('img2'),
          footer: RaisedButton(
            onPressed: () {/* Nothing */},
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Click on ",
                style: bodyStyle,
              ),
              Icon(Icons.edit),
              Text(
                " to edit a post",
                style: bodyStyle,
              ),
            ],
          ),
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      next: const Icon(Icons.arrow_forward),
      done: const Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
