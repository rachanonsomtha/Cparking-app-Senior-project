// import 'dart:html';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/report_provider.dart';

//loader animations
import '../provider/report.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../provider/userData.dart';
import '../provider/auth.dart';

import '../loader/color_loader_3.dart';

class ReportDetailScreen extends StatefulWidget {
  static const routeName = '/report-detail';

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

@override
class _ReportDetailScreenState extends State<ReportDetailScreen> {
  double rating = 2.5;
  // bool _isLoading = true;

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

  Widget _buildReportName(Report report) {
    return Container(
      // color: Theme.of(context).accentColor,
      padding: EdgeInsets.only(
        right: 40,
        left: 20,
      ),
      child: Text(
        report.loc,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontSize: 52,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetail(Report report) {
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
                'Parkability : ${report.availability}',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              Text(
                '${report.dateTime}',
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

  Widget _buildContact(UserData userData) {
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
            child: userData.profileImageUrl != null
                ? Container(
                    height: 47,
                    width: 47,
                    child: ClipOval(
                      child: Image.network(
                        userData.profileImageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 47,
                    width: 47,
                    child: ClipOval(
                      child: Image.asset(
                        'images/unknownProfileImg.png',
                        color: Colors.white70,
                      ),
                    ),
                  ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                userData.userName,
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
                  fontSize: 16,
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
    final screenSize = MediaQuery.of(context).size;
    Report loadedReport;
    // UserData reportUserData;
    final reportId = ModalRoute.of(context).settings.arguments as String;
    loadedReport = Provider.of<ReportsProvider>(
      context,
      listen: false,
    ).findById(reportId);
    final reportData = Provider.of<Auth>(context);

    // fetching problems

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
                  _buildReportName(loadedReport),
                  _buildDetail(loadedReport),
                  _buildSeparator(screenSize),
                  _buildContact(reportData.tempUserData),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
