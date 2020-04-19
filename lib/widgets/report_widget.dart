import 'package:cparking/loader/color_loader_3.dart';
import 'package:cparking/provider/report_provider.dart';
import 'package:cparking/screens/report_detail_screen.dart';
import 'package:flutter/material.dart';
import '../provider/report.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../provider/parkingLotProvider.dart';
//rating
import '../widgets/lifeTimeBar.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  bool _isLoading = false;

// calculate displayed lifetime bar
  double ratioCalculate(DateTime submitTime, Duration lifeTime) {
    DateTime expTime = submitTime.add(lifeTime);

    if ((DateTime.now()).isBefore(expTime)) {
      return ((((DateTime.now()).millisecondsSinceEpoch -
                  expTime.millisecondsSinceEpoch) /
              lifeTime.inMilliseconds))
          .abs();
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double rating = 2.5;
    final authData = Provider.of<Auth>(context, listen: false);
    final report = Provider.of<Report>(context);
    DateTime dateTime = DateTime.parse(report.dateTime.toString());

    double remainingTime = ratioCalculate(
      DateTime.parse(report.dateTime),
      new Duration(minutes: report.lifeTime),
    );
    // print(dateTime.minute);
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LifeTimeBar(
              heightz: MediaQuery.of(context).size.height / 8,
              icon: Icon(Icons.timelapse, color: Colors.black87),
              factor: remainingTime,
            ),
            Container(
              width: MediaQuery.of(context).size.height / 8,
              child: GestureDetector(
                onTap: () {
                  Provider.of<Auth>(context)
                      .fetchUserDataFromUserId(report.userName)
                      .then((_) {
                    Navigator.of(context).pushNamed(
                      ReportDetailScreen.routeName,
                      arguments: report.id,
                    );
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.network(
                      report.imageUrl.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 50),
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
                        'Time: ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 12,
                        ),
                      ),
                      // Container(
                      //   width: 100,
                      //   child: SmoothStarRating(
                      //     allowHalfRating: false,
                      //     onRatingChanged: (v) {
                      //       rating = v;
                      //     },
                      //     starCount: 5,
                      //     rating: rating,
                      //     size: 20.0,
                      //     filledIconData: Icons.star,
                      //     halfFilledIconData: Icons.star_half,
                      //     color: Colors.yellow,
                      //     borderColor: Colors.grey,
                      //     spacing: 0.0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                _isLoading
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            top: 10,
                            bottom: 10,
                          ),
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.indigo,
                          ),
                        ),
                      )
                    : Column(
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
                                      child: report.isPromoted &&
                                              _isanimate != 'favorite'
                                          ? FlareActor(
                                              'assets/flare/HearthAnimation.flr',
                                              fit: BoxFit.contain,
                                              animation: _isanimate,
                                            )
                                          : Icon(
                                              FontAwesomeIcons.heart,
                                              size: 32,
                                            ),
                                    ),
                                  ),
                                  onTap: () {
                                    // print(_isanimate);
                                    setState(() {
                                      _isLoading = true;
                                      _isanimate = 'favorite';
                                    });
                                    // print(_isanimate);
                                    report
                                        .scoreManagement(
                                      authData.token,
                                      authData.userId,
                                      report.userName,
                                    )
                                        .then((_) {
                                      setState(() {
                                        _isLoading = false;
                                        _isanimate = 'idle';
                                      });
                                    });
                                    // print('go');
                                  }),
                            ),
                          ),
                          // Text(
                          //   '${report.isPromoted && _isanimate != 'favorite' ? 'Unlike' : 'Like'}',
                          //   style: TextStyle(
                          //     color: Theme.of(context).primaryColorDark,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 12,
                          //   ),
                          // ),
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
