import 'package:flutter/foundation.dart';
import 'dart:io';

class Report with ChangeNotifier {
  @required
  final String id;
  @required
  final String userName;
  @required
  final double lifeTime;
  @required
  final String imageUrl;
  @required
  final String dateTime;
  bool isPromoted;
  int score;
  @required
  int availability;

  Report({
    @required this.id,
    @required this.userName,
    @required this.lifeTime,
    @required this.imageUrl,
    @required this.dateTime,
    this.isPromoted = false,
    this.score = 0,
    @required this.availability,
  });

  void _setPromoteValue(bool newValue) {
    isPromoted = newValue;
    notifyListeners();
  }

  // Future<void> increaseScore(String token, String userId) async {
  //   final oldStatus = isPromoted;
  //   isPromoted = !isPromoted;
  //   score += 1;
  //   notifyListeners();
  //   final url =
  // }
}
