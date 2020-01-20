import 'package:cparking/screens/report_detail_screen.dart';

import '../provider/report_provider.dart';
import '../widgets/report_widget.dart';
import 'package:provider/provider.dart';
import '../loader/color_loader_2.dart';
import '../loader/color_loader_3.dart';

import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class ReportOverViewScreen extends StatefulWidget {
  static const routeName = '/report-screen';

  @override
  _ReportOverViewScreenState createState() => _ReportOverViewScreenState();
}

class _ReportOverViewScreenState extends State<ReportOverViewScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    final name = ModalRoute.of(context).settings.arguments as String;
    print(name);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ReportsProvider>(context)
          .fetchReportFromLocation(name)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<ReportsProvider>(context);
    final name = ModalRoute.of(context).settings.arguments as String;

    var count = report.reportCount;

    return Scaffold(
      // backgroundColor: Color.fromRGBO(67, 66, 114, 100),
      appBar: AppBar(
        title: Text(
          'Reports from : $name',
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // drawer: AppDrawer(),
      body: count == 0 && !_isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).copyWith().size.height / 2,
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FlareActor(
                          'assets/flare/Wi-Fi-Not-Connected.flr',
                          fit: BoxFit.contain,
                          animation: 'go',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'There\'s no report now',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).accentColor,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            )
          : _isLoading
              ? Center(
                  child: ColorLoader3(),
                )
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: report.locReportsCount,
                    itemBuilder: (_, index) => ChangeNotifierProvider.value(
                      child: Column(
                        children: <Widget>[
                          ReportItem(
                              // report.reports[index].userName,
                              // report.reports[index].lifeTime,
                              // report.reports[index].dateTime.toString(),
                              // report.reports[index].imageUrl,
                              // report.reports[index].availability,
                              // report.reports[index].isPromoted,
                              // report.reports[index].score,
                              ),
                        ],
                      ),
                      value: report.locReports[index],
                    ),
                  ),
                ),
    );
  }
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _primaryValue = 0x829Fd9;

  static const MaterialColor blue = const MaterialColor(
    _primaryValue,
    const <int, Color>{
      50: const Color(0xFFe0e0e0),
      100: const Color(0xFFb3b3b3),
      200: const Color(0xFF808080),
      300: const Color(0xFF4d4d4d),
      400: const Color(0xFF262626),
      500: const Color.fromRGBO(130, 159, 217, 100),
      600: const Color(0xFF000000),
      700: const Color(0xFF000000),
      800: const Color(0xFF000000),
      900: const Color(0xFF000000),
    },
  );
}
