import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './report.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:firebase_storage/firebase_storage.dart';

class ReportsProvider with ChangeNotifier {
  List<Report> _reports = [];

  List<Report> _userReports = [];

  List<Report> _reportsLoc = [];

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

  bool isOwnedby(Report report) {
    return report.userName == userId ? true : false;
  }

  // effect all pages scenarios
  // void showFavouritesOnly() {
  //   _showFavourtiesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavourtiesOnly = false;
  //   notifyListeners();
  // }
  // Product findById(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  ///update products
  ///

  void updateProduct(String id, Report newProduct) {
    final prodIndex = _reports.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _reports[prodIndex] = newProduct;
      notifyListeners();
    }
    // print('...');
  }

  void removeReport(String id) {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    _reports.removeWhere((rep) => rep.id == id);
    _userReports.removeWhere((rep) => rep.id == id);
    _reportsLoc.removeWhere((rep) => rep.id == id);
    notifyListeners();
  }

  Report findById(String id) {
    return _reports.firstWhere((rep) => rep.id == id);
  }

  // Future<void> fetchAndGetProducts() async {
  //   const url = 'https://myshop-c8a90.firebaseio.com/products.json';
  //   try {
  //     final response = await http.get(url);
  //     final decodeData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Report> loadedProducts = [];
  //     decodeData.forEach((prodId, prodData) {
  //       loadedProducts.add(Report(
  //         id: prodId,
  //         title: prodData['title'],
  //         description: prodData['description'],
  //         price: prodData['price'],
  //         isFavorite: prodData['isFavourite'],
  //         imageUrl: prodData['imageUrl'],
  //       ));
  //     });
  //     _items = loadedProducts;
  //     notifyListeners();
  //     print(json.decode(response.body));
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  int setHour(int time) {
    //Real envi

    int row;
    if (time >= 7) {
      row = 7;
      if (time >= 8) {
        row = 8;
        if (time >= 9) {
          row = 9;
          if (time >= 10) {
            row = 10;
            if (time >= 11) {
              row = 11;
              if (time >= 12) {
                row = 12;
                if (time >= 13) {
                  row = 13;
                  if (time >= 14) {
                    row = 14;
                    if (time >= 15) {
                      row = 15;
                      if (time >= 16) {
                        row = 16;
                        if (time >= 17) {
                          row = 17;
                          if (time == 18) {
                            row = 18;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return row;
  }

  String setMinute(int time) {
    //Real envi

    String min;
    if (time <= 30) {
      min = '0';
    }
    if (time >= 31) {
      min = '30';
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
        if (reportData['loc'] == loc)
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

  String calculateMean(
    double oldMean,
    int avai,
  ) {
    var temp = oldMean + avai;
    print("Avai: $avai");
    var ans = (temp / 2).round();
    return (ans.toString());
  }

  Future<void> addReport(Report report, int currentReportCount) async {
    final url1 =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';

    // final addDate =
    //     DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()).toString();
    final addDate = DateTime.now().toString();
    final time = DateTime.now();

    String hour = (time.hour).toString();
    String minute = setMinute(time.minute);

    // print(addDate);
    // create products collection in firebase
    try {
      final response = await http.post(
        url1,
        body: json.encode({
          'userName': report.userName,
          'imageUrl': report.imageUrl,
          'lifeTime': report.lifeTime,
          'dateTime': addDate,
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
          'https://cparking-ecee0.firebaseio.com/avai/${report.loc}/14/0.json';
      double oldMean;
      final response3 = await http.get(urlOldMean);
      final decodeData3 = json.decode(response3.body) as Map<String, dynamic>;

      oldMean = double.parse(decodeData3['mean']);
      // .then((_) async {
      String newMean = calculateMean(
        oldMean,
        report.availability,
      );
      final url3 =
<<<<<<< HEAD
          'https://cparking-ecee0.firebaseio.com/avai/${report.loc}/14/0.json';
      count += 1;
=======
          'https://cparking-ecee0.firebaseio.com/avai/${report.loc}/$hour/$minute.json';

>>>>>>> parent of 5d40ea5... 5/2/63
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
        dateTime: addDate,
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
