import 'package:cparking/provider/report.dart';
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  // @required
  final String email;
  final String id;
  final String idToken;
  @required
  final String userName;
  final String profileImageUrl;
  @required
  final int score;
  final int verified;
  List<String> reports;

  UserData({
    this.email,
    this.id,
    this.idToken,
    this.userName,
    this.profileImageUrl,
    this.score,
    this.verified = 0,
    this.reports,
  });
}
