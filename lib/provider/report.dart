import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  @required
  final String loc;

  Report({
    @required this.id,
    @required this.userName,
    @required this.lifeTime,
    @required this.imageUrl,
    @required this.dateTime,
    this.isPromoted = false,
    this.score = 0,
    @required this.availability,
    @required this.loc,
  });

  void _setNewPromoteValue(bool newValue) {
    isPromoted = newValue;
    notifyListeners();
  }

  Future<void> scoreManagement(
    String authToken,
    String userId,
  ) async {
    bool oldStatus = isPromoted;
    int oldScore = score;
    // print(isPromoted);
    if (oldStatus && oldScore >= 1) {
      oldScore -= 1;
    } else if (!oldStatus) {
      oldScore += 1;
    }
    oldStatus = !oldStatus;
    isPromoted = oldStatus;
    // print(isPromoted);
    score = oldScore;
    notifyListeners();
    final url =
        'https://cparking-ecee0.firebaseio.com/userPromoted/$userId/$id.json?auth=$authToken';
    final scoreUrl =
        'https://cparking-ecee0.firebaseio.com/reports/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isPromoted,
        ),
      );
      if (response.statusCode >= 400) {
        _setNewPromoteValue(oldStatus);
      }
      await http.patch(
        scoreUrl,
        body: json.encode({
          'score': score,
        }),
      );
    } catch (error) {
      _setNewPromoteValue(oldStatus);
    }
  }

  // Future<void> increaseScore(String token, String userId) async {
  //   final oldStatus = isPromoted;
  //   isPromoted = !isPromoted;
  //   score += 1;
  //   notifyListeners();
  //   final url =
  // }
}
