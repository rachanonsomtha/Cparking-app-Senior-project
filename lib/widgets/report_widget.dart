import 'package:cparking/provider/report_provider.dart';
import 'package:flutter/material.dart';
import '../provider/report.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../provider/report.dart';

class ReportItem extends StatelessWidget {
  // final report = Provider.of<ReportsProvider>(context, listen: false);

  final _imageUrlController = TextEditingController();

  final String userName;
  final double lifeTime;
  final String dateTime;
  final String imageUrl;
  final int availability;
  final bool isPromoted;
  final int score;

  ReportItem(
    this.userName,
    this.lifeTime,
    this.dateTime,
    this.imageUrl,
    this.availability,
    this.isPromoted,
    this.score,
  );
  @override
  Widget build(BuildContext context) {
    var _editReport = Report(
      id: null,
      userName: userName, // temporary
      lifeTime: 0,
      dateTime: dateTime,
      imageUrl: imageUrl,
      isPromoted: isPromoted,
      availability: availability,
      score: score,
    );

    final authData = Provider.of<Auth>(context, listen: false);
    final report = Provider.of<Report>(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(
                top: 10,
                right: 10,
              ),
              child: FittedBox(
                child: Image.network(
                  imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                trailing: Text(dateTime),
                title: Text(
                  availability.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              mini: true,
              elevation: 0,
              onPressed: () {
                report.scoreManagement(
                  authData.token,
                  authData.userId,
                );
              },
              child: Consumer<Report>(
                builder: (ctx, report, _) => IconButton(
                  splashColor: Colors.white,
                  icon: Icon(
                    report.isPromoted ? Icons.thumb_up : Icons.thumb_down,
                  ),
                  // color: Theme.of(context).accentColor,
                  onPressed: () {
                    report.scoreManagement(
                      authData.token,
                      authData.userId,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
