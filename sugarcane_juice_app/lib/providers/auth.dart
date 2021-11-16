import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/login/login_screen.dart';
import '/models/http_exception.dart';

const uri = 'http://10.0.2.2:5000/api/auth/login';
Uri url = Uri.parse(uri);
// const uri = 'http://localhost:5000/api/auth/login';

final authProvider =
    StateNotifierProvider<AuthNotifier, String>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<String> {
  AuthNotifier() : super('');

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
      state = responseDate['token'];
      _saveDataOnDevice(token: state);
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

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    state = extractedUserData['token'];
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    state = '';
    await Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routName,
      (route) => false,
    );
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
