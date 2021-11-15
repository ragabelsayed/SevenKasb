import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugarcane_juice_app/models/http_exception.dart';

const uri = 'http://10.0.2.2:5000/api/auth/login';
// const uri = 'http://localhost:5000/api/auth/login';

final authProvider = ChangeNotifierProvider<Auth>((ref) {
  return Auth();
});

class Auth with ChangeNotifier {
  late String _token = '';
  Uri url = Uri.parse(uri);

  String get token {
    return _token;
  }

  Future<void> _authenticate({
    required String name,
    required String passowrd,
    required Uri url,
  }) async {
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

    if (response.statusCode >= 200 && response.statusCode < 400) {
      final responseDate = json.decode(response.body) as Map<String, dynamic>;
      _token = responseDate['token'];
      _saveDataOnDevice(token: _token);
      notifyListeners();
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw HttpException(
        ' الأسم او الباسورد غير صحيح',
      );
    } else {
      throw HttpException(
        'تعذر الاتصال بالسيرفر او تأكد من البيانات',
      );
    }
  }

  Future<void> login({required String name, required String password}) async {
    await _authenticate(name: name, passowrd: password, url: url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      _token = extractedUserData['token'];
      return true;
    }
  }

  Future<void> logOut() async {
    _token = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _saveDataOnDevice({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': token,
    });
    prefs.setString('userData', userData);
  }
}
