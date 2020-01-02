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

  Report({
    this.id,
    this.userName,
    this.lifeTime,
    this.imageUrl,
    this.dateTime,
  });
}
