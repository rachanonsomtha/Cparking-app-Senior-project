import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './report.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:firebase_storage/firebase_storage.dart';

class ReportsProvider with ChangeNotifier {
  List<Report> _reports = [];

  List<Report> _userReports = [];

  List<Report> _reportsLoc = [];

  int _lifeTime;

  String authToken;
  String userId;
  Map<String, String> headers = new HashMap();

  // var _showFavourtiesOnly = false;

  ReportsProvider(
    this.authToken,
    this.userId,
    // this._reports,
  );
  //////
  List<Report> get reports {
    return [..._reports];
  }

  int get reportCount {
    return _reports.length;
  }

//////
  List<Report> get userReports {
    return [..._userReports];
  }

  int get userReportCount {
    return _userReports.length;
  }

/////
  List<Report> get locReports {
    return [..._reportsLoc];
  }

  int get locReportsCount {
    return _reportsLoc.length;
  }

  int get lifeTime {
    return _lifeTime;
  }

  bool isOwnedby(Report report) {
    return report.userName == userId ? true : false;
  }

  void updateProduct(String id, Report newProduct) {
    final prodIndex = _reports.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _reports[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void removeReport(String id) {
    _reports.removeWhere((rep) => rep.id == id);
    _userReports.removeWhere((rep) => rep.id == id);
    _reportsLoc.removeWhere((rep) => rep.id == id);
    notifyListeners();
  }

  Report findById(String id) {
    return _reports.firstWhere((rep) => rep.id == id);
  }

  Future<void> getLifeTime(String name) async {
    final url = 'https://cparking-ecee0.firebaseio.com/avai/$name/1/14/0.json';
    await http.get(url).then((decodeData) {
      var data = json.decode(decodeData.body) as Map<String, dynamic>;
      _lifeTime = int.parse(data['lifeTime']);
    });
  }

  Future<int> getSlope(String day, String minute, String hour, String name,
      double lotCount, int avai) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/avai/$name/$day/$hour.json';
    print(url);
    final response = await http.get(url);
    List<int> yList = [1, 2, 3, 4, 5, 6];
    List<int> meanList = [];
    final decodeData = json.decode(response.body) as Map<String, dynamic>;
    decodeData.forEach((key, value) {
      meanList.add(int.parse(value['mean']));
    });
    double y = 0;
    double xy = 0;
    int count = 0;

    meanList.forEach((number) {
      y += number;
      xy += yList[count] * meanList[count];
      count += 1;
    });
    //Calculation linear regression
    final slope = (xy - (21 * y) / 6) / (91 - (pow(21, 2) / 6));
    // print('eiei equation');
    int temp = (((avai / lotCount) * slope) * 60).roundToDouble().abs().toInt();
    return temp <= 0 ? 60 : temp;
  }

  String setMinute(int time) {
    //Real envi

    String min;
    if (time <= 0) {
      min = '0';
    } else if (time <= 10) {
      min = '10';
    } else if (time <= 20) {
      min = '20';
    } else if (time <= 30) {
      min = '30';
    } else if (time <= 40) {
      min = '40';
    } else if (time <= 50) {
      min = '50';
    }

    return min;
  }

  Future<void> fetchReport() async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);

      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        loadedProducts.add(
          Report(
            id: reportId,
            userName: reportData['userName'],
            imageUrl: reportData['imageUrl'],
            lifeTime: reportData['lifeTime'],
            isPromoted: favData == null ? false : favData[reportId] ?? false,
            score: reportData['score'],
            dateTime: reportData['dateTime'].toString(),
            availability: reportData['availability'],
            loc: reportData['loc'],
            imgName: reportData['imgName'],
          ),
        );
      });
      _reports = loadedProducts;
      notifyListeners();
      // print(_reports);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  bool isExpired(int lifeTime, String dateTime) {
    DateTime expTime = DateTime.parse(dateTime).add(
      Duration(
        minutes: lifeTime,
      ),
    );
    return DateTime.now().isAfter(expTime) ? true : false;
  }

  Future<void> fetchReportFromLocation(String loc) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data
    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);

      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        if (reportData['loc'] == loc &&
            !isExpired(
              reportData['lifeTime'],
              reportData['dateTime'].toString(),
            ))
          loadedProducts.add(
            Report(
              id: reportId,
              userName: reportData['userName'],
              imageUrl: reportData['imageUrl'],
              lifeTime: reportData['lifeTime'],
              isPromoted: favData == null ? false : favData[reportId] ?? false,
              score: reportData['score'],
              dateTime: reportData['dateTime'].toString(),
              availability: reportData['availability'],
              loc: reportData['loc'],
              imgName: reportData['imgName'],
            ),
          );
      });
      _reportsLoc = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchReportFromUserId(List<String> userReports) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    final favUrl =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId.json?auth=$authToken';
    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      if (decodeData == null) {
        return;
      }
      final favResponse = await http.get(favUrl);
      final favData = json.decode(favResponse.body);
      // print(favData);
      final List<Report> loadedProducts = [];
      // print(userReports);
      decodeData.forEach((reportId, reportData) {
        // print(reportId);
        if ((userReports.contains(reportId)))
          loadedProducts.add(
            Report(
              id: reportId,
              userName: reportData['userName'],
              imageUrl: reportData['imageUrl'],
              lifeTime: reportData['lifeTime'],
              isPromoted: favData == null ? false : favData[reportId] ?? false,
              score: reportData['score'],
              dateTime: reportData['dateTime'].toString(),
              availability: reportData['availability'],
              loc: reportData['loc'],
              imgName: reportData['imgName'],
            ),
          );
      });
      _userReports = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> deleteReport(Report report) async {
    String keyName;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reports/${report.loc}/${report.imgName}');
    storageReference.delete().then((_) {
      print('delete succesfully');
    }).catchError((_) {
      print(_);
    });
    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports/${report.id}.json?auth=$authToken';
    try {
      await http.delete(url1, headers: headers).then((_) {
        print('deletion report from user success');
        removeReport(report.id);
        notifyListeners();
      }).then((_) async {
        final url2 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

        final response = await http.get(url2);
        final decodeData = json.decode(response.body) as Map<String, dynamic>;
        decodeData.forEach((reportId, reportData) {
          if (reportData == report.id) {
            keyName = reportId;
          }
        });
      }).then((_) async {
        final url3 =
            'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId/$keyName.json';

        await http.delete(url3, headers: headers).then((_) {
          print("delete from reportFolder complete");
        });
      });
    } catch (error) {
      print(error);
    }
  }

  String calculateMean(double oldMean, int avai, int count) {
    var temp = oldMean + avai;
    var ans = (temp / (count == 0 ? 1 : 2)).round();
    return ans.toString();
  }

  Future<void> addReport(Report report, int currentReportCount) async {
    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    // final add_date =
    //     DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()).toString();
    final add_date = DateTime.now().toString();
    final time = DateTime.now();

    String hour = (time.hour).toString();
    String minute = setMinute(time.minute);
    String day = time.weekday.toString();

    // print(add_date);
    // create products collection in firebase
    try {
      final response = await http.post(
        url1,
        body: json.encode({
          'userName': report.userName,
          'imageUrl': report.imageUrl,
          'lifeTime': report.lifeTime,
          'dateTime': add_date,
          'userName': userId,
          'loc': report.loc,
          // 'isPromote': report.isPromoted,
          'score': 0,
          'availability': report.availability,
          'imgName': (report.imgName).toString(),
        }),
      );

      final url2 =
          'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

      await http.post(
        url2,
        body: json.encode(
          json.decode(response.body)['name'],
        ),
      );

      final urlOldMean =
          'https://cparking-ecee0.firebaseio.com/avai/${report.loc}/$day/$hour/$minute.json';

      double oldMean;
      int count;
      await http.get(urlOldMean).then((value) {
        var data = json.decode(value.body) as Map<String, dynamic>;
        oldMean = double.parse(data['mean']);
        count = int.parse(data['count']);
      });
      print('OldCount: $count');
      count += 1;

      String newMean = calculateMean(oldMean, report.availability, count);
      print('Newcount: $count');

      final url3 =
          'https://cparking-ecee0.firebaseio.com/avai/${report.loc}/$day/$hour/$minute.json';

      await http.patch(
        url3,
        body: json.encode({
          'mean': newMean,
        }),
      );

      final rep = Report(
        id: json.decode(response.body)['name'],
        userName: report.userName,
        lifeTime: report.lifeTime,
        imageUrl: report.imageUrl,
        dateTime: add_date,
        score: report.score,
        loc: report.loc,
        // isPromoted: report.isPromoted,
        availability: report.availability,
        imgName: (report.imgName).toString(),
      );
      _reports.add(rep);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
