import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../provider/userData.dart';

class Auth extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  // String _userName;

  UserData _userData;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  UserData get userData {
    // print(userData.userName);
    return _userData;
  }

  int get userReportsCount {
    return _userData.reports.length;
  }

  UserData _tempUserData;

  UserData get tempUserData {
    return _tempUserData;
  }
  // String get userName {
  //   return _userName;
  // }

  Future<void> fetchUserDataFromUserId(String userIds) async {
    print(userId);
    final url =
        'https://cparking-ecee0.firebaseio.com/users/$userIds/profile.json';
    try {
      await http.get(url).then((value) {
        final decodeData = json.decode(value.body) as Map<String, dynamic>;
        decodeData.forEach((userId, userData) {
          // print(userData['profileImageUrl']);
          _tempUserData = UserData(
            userName: userData['userName'],
            id: userId,
            score: userData['score'],
            profileImageUrl: userData['profileImageUrl'].toString(),
            reports: [],
          );
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchUserProfileData() async {
    final url =
        'https://cparking-ecee0.firebaseio.com/users/$userId/profile.json';
    final url1 =
        'https://cparking-ecee0.firebaseio.com/users/$userId/reportsId.json';

    // print(userId);
    try {
      final response = await http.get(url).then((value) {
        final decodeData = json.decode(value.body) as Map<String, dynamic>;
        // if (decodeData == null) {
        //   print('null eiei');
        // }

        decodeData.forEach((userId, userData) {
          _userData = UserData(
            userName: userData['userName'],
            id: userId,
            score: userData['score'],
            profileImageUrl: userData['profileImageUrl'],
            reports: [],
          );

          // print(_userData.id);
          // return _userData;
          // _userName = userData['userName']; // test fetching
        });
      });

      final response1 = await http.get(url1).then((value) {
        final decodeData = json.decode(value.body) as Map<String, dynamic>;

        decodeData.forEach((userId, userData) {
          // print(userData);
          (_userData.reports).add(
            userData.toString(),
          );
        });
        // print(_userData.reports.length);
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUserProfile(UserData newUserData) async {
    final url =
        'https://cparking-ecee0.firebaseio.com/users/$userId/profile.json';
    // print('eiei1');

    try {
      final response = await http.get(url);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;

      decodeData.forEach((id, userData) async {
        final url =
            'https://cparking-ecee0.firebaseio.com/users/$userId/profile/$id.json';
        try {
          await http.patch(
            url,
            body: json.encode({
              'profileImageUrl': newUserData.profileImageUrl,
            }),
          );
        } catch (error) {
          print(error);
        }
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _authenticate(
      String email, String password, String _auth, String userName) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$_auth?key=AIzaSyBmonMa2ytyi8c3aYWtVzgIhE8jCyzTHB8';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            // 'userName': userName,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // _userName = responseData['userName'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']) + 3600,
        ),
      );
      notifyListeners();

      ///Shared perf here...

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
          // 'userName': _userName,
        },
      );
      fetchUserProfileData();
      // print('kuy');
      // print(_userName);

      final url2 =
          'https://cparking-ecee0.firebaseio.com/users/$userId/profile.json';
      try {
        if (userName != null) {
          await http.post(
            url2,
            body: json.encode(
              {
                'userName': userName,
                'score': 0,
                'profileImageUrl': '',
              },
            ),
          );
          // print(_userName);
        }
      } catch (error) {
        print(error);
      }
      prefs.setString('userData', userData);
      // print(_token);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    fetchUserProfileData();
    // _userName = extractedUserData['userName'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password, String userName) async {
    return _authenticate(email, password, 'signUp', userName).then(
      (_) => fetchUserProfileData(),
    );
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword', null).then(
      (_) => fetchUserProfileData(),
    );
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    // _userName = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}
