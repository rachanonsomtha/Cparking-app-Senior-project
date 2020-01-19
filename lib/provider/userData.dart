import 'package:cparking/provider/report.dart';
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  @required
  final String id;
  @required
  final String userName;
  final String profileImageUrl;
  @required
  final int score;
  List<String> reports;

  UserData({
    this.id,
    this.userName,
    this.profileImageUrl,
    this.score,
    this.reports,
  });
}
