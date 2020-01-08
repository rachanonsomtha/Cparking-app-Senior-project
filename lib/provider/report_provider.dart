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

  String authToken;
  String userId;
  // var _showFavourtiesOnly = false;

  List<Report> get reports {
    //getters
    // if (_showFavourtiesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    return [..._reports];
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



  int get reportCount {
    return _reports.length;
  }

  void updateProduct(String id, Report newProduct) {
    final prodIndex = _reports.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _reports[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  void deleteProduct(String id, bool isFav) {
    // final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (isFav == false) {
      _reports.removeWhere((prod) => prod.id == id);
    }
    notifyListeners();
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

    //fetch and decode data

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      final List<Report> loadedProducts = [];
      decodeData.forEach((reportId, reportData) {
        loadedProducts.add(Report(
            id: reportId,
            userName: reportData['userName'],
            imageUrl: reportData['imageUrl'],
            lifeTime: reportData['lifeTime'],
            dateTime: reportData['dateTime'],
            availability: reportData['avai']));
      });
      _reports = loadedProducts;
      notifyListeners();
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addReport(Report report) async {
    final url = 'https://cparking-ecee0.firebaseio.com/reports.json?auth=$authToken';
    final add_date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
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
          'isPromote': report.isPromoted,
          'score': 0,
          'availability': report.availability,
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
        isPromoted: report.isPromoted,
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
