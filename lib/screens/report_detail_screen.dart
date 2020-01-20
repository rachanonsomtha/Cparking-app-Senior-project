// import 'dart:html';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/report_provider.dart';

//loader animations
import '../loader/color_loader_3.dart';
import '../provider/report.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReportDetailScreen extends StatefulWidget {
  static const routeName = '/report-detail';

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

@override
class _ReportDetailScreenState extends State<ReportDetailScreen> {
  double rating = 2.5;

  Widget _buildReportPicture(Report report) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            report.imageUrl.toString(),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Center(
      child: Container(
        width: screenSize.width / 1.2,
        height: 2.0,
        color: Colors.white70,
        margin: EdgeInsets.only(top: 20.0),
      ),
    );
  }

  Widget _buildReportName() {
    return Container(
      // color: Theme.of(context).accentColor,
      padding: EdgeInsets.only(
        right: 40,
        left: 20,
      ),
      child: Text(
        'Report 02',
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 52,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return Container(
      height: 100,
      padding: EdgeInsets.only(
        top: 30,
        right: 40,
        left: 23,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Parkability : 20 %',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              Text(
                '2019-09-18',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10,
            ),
            // width: 100,
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
    );
  }

  Widget _buildContact(Size screenSize) {
    return Container(
      height: 100,
      padding: EdgeInsets.only(
        top: 30,
        right: 40,
        left: 23,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 17),
            child: Image.asset('images/unknownProfileImg.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'JOHN',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                'GOLD II',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportId = ModalRoute.of(context).settings.arguments as String;
    final screenSize = MediaQuery.of(context).size;
    final loadedReport = Provider.of<ReportsProvider>(
      context,
      listen: false,
    ).findById(reportId); // fetching problems
    // print(loadedReport.id);
    return Scaffold(
      body: Stack(
        // alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _buildReportPicture(loadedReport),
          // SizedBox(
          //   height: 200,
          // ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.height / 2.6,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  _buildReportName(),
                  _buildDetail(),
                  _buildSeparator(screenSize),
                  _buildContact(screenSize),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
