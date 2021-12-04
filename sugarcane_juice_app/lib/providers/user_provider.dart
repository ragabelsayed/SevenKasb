import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sugarcane_juice/helper/box.dart';
import '/models/user.dart';
import '/providers/auth.dart';

final _userBox = Boxes.getUserBox();

final userProvider =
    StateNotifierProvider<UserDateNotifier, Map<String, dynamic>>((ref) {
  var _token = ref.watch(authProvider);
  return UserDateNotifier(authToken: _token['token'], userId: _token['userId']);
});

final updateUserProvider = Provider.autoDispose<UserProvider>((ref) {
  var _token = ref.watch(authProvider);
  return UserProvider(authToken: _token['token'], userId: _token['userId']);
});

class UserDateNotifier extends StateNotifier<Map<String, dynamic>> {
  UserDateNotifier({required this.authToken, required this.userId})
      : super({
          'user': _userBox.values.single,
          'isUpdated': false,
          'isError': false,
          'message': '... جارى الاتصال',
        });
  final String authToken;
  final int userId;

  Future<void> fetchUserDate() async {
    Uri _url = Uri.parse('http://10.0.2.2:5000/api/users/$userId');
    final response = await http.get(_url, headers: {
      'Content-Type': 'application/json',
      'charset': 'utf-8',
      'Authorization': 'Bearer $authToken',
    });
    if (response.statusCode >= 200 && response.statusCode < 400) {
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final _loadedUser = User.fromJson(json: extractedData);
      state = {
        'user': _loadedUser,
        'isUpdated': true,
        'isError': false,
        'message': ''
      };
      await _userBox.clear();
      await _userBox.add(_loadedUser);
    } else {
      state = {
        'user': _userBox.values.single,
        'isUpdated': false,
        'isError': true,
        'message': 'تعذر الاتصال بالسيرفر'
      };
    }
  }

  Future<void> updateUser(User user) async {
    Uri _url = Uri.parse('http://10.0.2.2:5000/api/users/$userId');
    try {
      await http.put(
        _url,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'username': user.userName,
          'knownAs': user.knownAs,
          'dateOfBirth': user.dateOfBirth,
          'city': user.city,
          'telephone': user.telephone,
        }),
      );
      state = {
        'user': user,
        'isUpdated': true,
        'isError': false,
        'message': ''
      };
    } catch (error) {
      rethrow;
    }
  }
}

class UserProvider {
  late String authToken;
  late int userId;
  UserProvider({required this.authToken, required this.userId});

  Future<void> updatePassword({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    Uri _passurl =
        Uri.parse('http://10.0.2.2:5000/api/auth/$userId/changepassword');
    try {
      await http.put(
        _passurl,
        headers: {
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'password': oldPass,
          'newPassword': newPass,
          'passwordConfirm': confirmPass
        }),
      );
    } catch (error) {
      rethrow;
    }
  }
}
