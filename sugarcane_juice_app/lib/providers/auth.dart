import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugarcane_juice/helper/box.dart';
import 'package:sugarcane_juice/models/user.dart';
import '/screens/login/login_screen.dart';
import '/models/http_exception.dart';

// const uri = 'http://localhost:5000/api/auth/login';
// AVD
const uri = 'http://10.0.2.2:5000/api/auth/login';
// wifi ip address
// const uri = 'http://192.168.1.7:5000/api/auth/login';
// hostName
// const uri = 'http://DESKTOP-Q8JB2O6:5000/api/auth/login';
Uri url = Uri.parse(uri);

final authProvider = StateNotifierProvider<AuthNotifier, Map<String, dynamic>>(
    (ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<Map<String, dynamic>> {
  AuthNotifier() : super({});

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
      state.addAll({
        'token': responseDate['token'],
        'userId': responseDate['user']['id'],
      });
      _saveDataOnDevice(
        token: responseDate['token'],
        userId: responseDate['user']['id'],
      );
      await Boxes.getUserBox().clear();
      await Boxes.getUserBox().add(User.fromJson(json: responseDate['user']));
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw HttpException(
        'الإسم أو كلمة السر غير صحيحة',
      );
    } else {
      throw HttpException(
        'تعذُّر الإتصال بالسيرفر أو تأكَّد من البيانات',
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
    state.addAll({
      'token': extractedUserData['token'],
      'userId': extractedUserData['userId'],
    });
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
    state.clear();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routName,
      (route) => false,
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _saveDataOnDevice({required String token, required int userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({'token': token, 'userId': userId});
    prefs.setString('userData', userData);
  }
}
