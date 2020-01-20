// import 'dart:html';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/report_provider.dart';

//loader animations
import '../loader/color_loader_3.dart';

class ReportDetailScreen extends StatefulWidget {
  static const routeName = '/report-detail';

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

@override
class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final reportId = ModalRoute.of(context).settings.arguments as String;
    final loadedReport = Provider.of<ReportsProvider>(
      context,
      listen: false,
    ).findById(reportId); // fetching problems
    // print(loadedReport.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              child: Image.network(
                loadedReport.imageUrl.toString(),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: ColorLoader3(),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Report: ${loadedReport.id}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedReport.dateTime,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
