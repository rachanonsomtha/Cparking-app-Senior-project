import 'package:cparking/loader/color_loader_3.dart';
import 'package:cparking/provider/report_provider.dart';
import 'package:cparking/screens/report_detail_screen.dart';
import 'package:flutter/material.dart';
import '../provider/report.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../provider/report.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';
//rating
import '../rating/starRating.dart';

class ReportItem extends StatefulWidget {
  // final report = Provider.of<ReportsProvider>(context, listen: false);

  // ReportItem(
  //   this.userName,
  //   this.lifeTime,
  //   this.dateTime,
  //   this.imageUrl,
  //   this.availability,
  //   this.isPromoted,
  //   this.score,
  // );
  @override
  _ReportItemState createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  String _isanimate = 'go';
  @override
  Widget build(BuildContext context) {
    // print('eiei');
    double rating = 2.5;
    final authData = Provider.of<Auth>(context, listen: false);
    final report = Provider.of<Report>(context);
    DateTime dateTime = DateTime.parse(report.dateTime.toString());

    // print(dateTime.minute);
    return Card(
      //rgb(67,66,114)
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 100,
              margin: EdgeInsets.only(
                top: 10,
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ReportDetailScreen.routeName,
                    arguments: report.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  child: Image.network(
                    report.imageUrl.toString(),
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: ColorLoader3(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Availability: ${report.availability}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Time: ${dateTime.hour}:${dateTime.minute}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        width: 100,
                        child: SmoothStarRating(
                          allowHalfRating: false,
                          onRatingChanged: (v) {
                            rating = v;
                          },
                          starCount: 5,
                          rating: rating,
                          size: 20.0,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          color: Colors.yellow,
                          borderColor: Colors.grey,
                          spacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Spacer(flex: 1,),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      heroTag: UniqueKey(),
                      elevation: 0,
                      onPressed: () {},
                      child: Consumer<Report>(
                        builder: (ctx, report, _) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: report.isPromoted
                                    ? Icon(
                                        Icons.thumb_down,
                                      )
                                    : FlareActor(
                                        'assets/flare/HearthAnimation.flr',
                                        fit: BoxFit.contain,
                                        animation: _isanimate,
                                      ),
                              ),
                            ),
                            onTap: () {
                              // print(_isanimate);
                              setState(() {
                                _isanimate = 'favorite';
                              });
                              // print(_isanimate);
                              report
                                  .scoreManagement(
                                authData.token,
                                authData.userId,
                              )
                                  .then((_) {
                                setState(() {
                                  _isanimate = 'idle';
                                });
                              });
                              // print('go');
                            }),
                      ),
                    ),
                    Text(
                      '${report.isPromoted ? 'Unlike' : 'Like'}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
