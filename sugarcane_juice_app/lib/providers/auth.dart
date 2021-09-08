import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const uri = 'http://10.0.2.2:5000/api/auth/login';
// const uri = 'http://localhost:5000/api/auth/login';

final authProvider = ChangeNotifierProvider<Auth>((ref) {
  return Auth();
});

class Auth with ChangeNotifier {
  late String _token = '';
  // DateTime _expiryDate;
  // String _userId;
  // Timer _authTimer;
  // const Auth._();
  Uri url = Uri.parse(uri);
  // static Uri url = Uri.http('10.0.2.2:5000', '/api/auth/login');

  bool get isAuth {
    if (_token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String get token {
    return _token;
  }
  //  String get token {
  //   if (_expiryDate != null &&
  //       _expiryDate.isAfter(DateTime.now()) &&
  //       _token != null) {
  //     return _token;
  //   }
  //   return null;
  // }

  Future<void> _authenticate({
    required String name,
    required String passowrd,
    required Uri url,
  }) async {
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
        },
        body: json.encode(
          {
            'username': name,
            'password': passowrd,
          },
        ),
      );

      final responseDate = json.decode(response.body) as Map<String, dynamic>;
      _token = responseDate['token'];

      notifyListeners();
      _saveDataOnDevice(token: _token);
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token': _token,
      // });
      // prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(
      {String name = 'khaled', String password = 'password'}) async {
    return _authenticate(name: name, passowrd: password, url: url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    _token = extractedUserData['token'];
    notifyListeners();
    return true;
  }

  // static void logIn({
  //   String name = 'khaled',
  //   String passowrd = 'password',
  // }) async {
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'charset': 'utf-8',
  //       },
  //       body: json.encode(
  //         {
  //           'username': name,
  //           'password': passowrd,
  //         },
  //       ),
  //     );

  //     final responseDate = json.decode(response.body) as Map<String, dynamic>;
  //     // print(extractedData);
  //   } catch (error) {
  //     print('Errorrrrrrr');

  //     throw error;
  //   }
  // }

  void _saveDataOnDevice({
    // String name = 'khaled',
    // String passowrd = 'khaled',
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': token,
    });
    prefs.setString('userData', userData);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setStringList('userData', [name, passowrd]);
  }
}
