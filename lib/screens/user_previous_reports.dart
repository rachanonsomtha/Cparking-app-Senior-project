import '../provider/report_provider.dart';
import '../widgets/report_widget.dart';
import 'package:provider/provider.dart';
import '../loader/color_loader_2.dart';
import '../loader/color_loader_3.dart';

import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../provider/auth.dart';

class UserPreviousReports extends StatefulWidget {
  static const routeName = '/UserReport-screen';

  @override
  _UserPreviousReportsState createState() => _UserPreviousReportsState();
}

class _UserPreviousReportsState extends State<UserPreviousReports> {
  bool _isInit = true;

  bool _isLoading = false;
  @override
  void didChangeDependencies() async {
    final userData = Provider.of<Auth>(context);
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Auth>(context).fetchUserProfileData().whenComplete(() async {
        await Provider.of<ReportsProvider>(context)
            .fetchReport()
            .catchError((error) {
          print(error);
        });
        await Provider.of<ReportsProvider>(context)
            .fetchReportFromUserId(userData.userData.reports)
            .catchError((error) {
          print(error);
        }).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    setState(() {
      _isInit = false;
    });

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _fetchReport(BuildContext context) async {
    final userData = Provider.of<Auth>(context);
    await Provider.of<Auth>(context).fetchUserProfileData();
    await Provider.of<ReportsProvider>(context)
        .fetchReportFromUserId(userData.userData.reports)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<ReportsProvider>(context);
    var count = report.userReportCount;
    // print(count);

    return Scaffold(
      // backgroundColor: Color.fromRGBO(67, 66, 114, 100),
      appBar: AppBar(
        title: const Text("Previous Reports"),
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
              : RefreshIndicator(
                  onRefresh: () => _fetchReport(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: report.userReportCount,
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
                        value: report.userReports[index],
                      ),
                    ),
                  ),
                ),
    );
  }
}
