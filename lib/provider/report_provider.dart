import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './report.dart';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;

class ReportsProvider with ChangeNotifier {
  List<Report> _reports = [];

  List<Report> _userReports = [];

  String authToken;
  String userId;
  // var _showFavourtiesOnly = false;

  ReportsProvider(
    this.authToken,
    this.userId,
    // this._reports,
  );
  List<Report> get reports {
    //getters
    // if (_showFavourtiesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    return [..._reports];
  }

  int get reportCount {
    return _reports.length;
  }

  List<Report> get userReports {
    return [..._userReports];
  }

  int get userReportCount {
    return _userReports.length;
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

  void deleteProduct(String id, bool isFav) {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (isFav == false) {
      _reports.removeWhere((prod) => prod.id == id);
    }
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
          ),
        );
      });
      _reports = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
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
            ),
          );
      });
      _reports = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchReportFromUserId() async {
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
        if (reportData['userName'] == userId)
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
            ),
          );
      });
      _userReports = loadedProducts;
      notifyListeners();
      // print(loadedProducts);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addReport(Report report) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';
    final userUrl =
        'https://cparking-ecee0.firebaseio.com/$userId/reports.json?auth=$authToken';

    final add_date =
        DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()).toString();
    // print(add_date);
    // create products collection in firebase
    try {
      final response = await http.post(
        url,
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
        }),
      );

      await http.post(
        userUrl,
        body: json.encode({
          'id': json.decode(response.body)['name'],
        }),
      );
      // print(json.decode(response.body));
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
      );
      _reports.add(rep);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
