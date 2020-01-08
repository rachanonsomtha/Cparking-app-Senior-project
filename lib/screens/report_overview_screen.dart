import '../provider/report_provider.dart';
import '../widgets/report_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import 'package:flutter/material.dart';

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
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ReportsProvider>(context).fetchReport().then((_) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigoAccent,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: report.reportCount,
                itemBuilder: (_, index) => Column(
                  children: <Widget>[
                    ReportItem(
                      report.reports[index].userName,
                      report.reports[index].lifeTime,
                      report.reports[index].dateTime.toString(),
                      report.reports[index].imageUrl,
                      report.reports[index].availability,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
