import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/user.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

// AVD
// const userUri = 'http://10.0.2.2:5000/api/users/1';
// // wifi ip
// // const userUri = 'http://192.168.1.7:5000/api/users/1';
// Uri url = Uri.parse(userUri);
// AVD
// const userUri = 'http://10.0.2.2:5000/api/users/1';
// wifi ip
// const passUri = 'http://10.0.2.2:5000/api/auth/1/changepassword';
// const passUri = 'http://192.168.1.7:5000/api/auth/1/changepassword';
// Uri passurl = Uri.parse(passUri);

final userProvider = FutureProvider.autoDispose<User>((ref) async {
  var _token = ref.watch(authProvider);
  return UserProvider(authToken: _token['token'], userId: _token['userId'])
      .fetchUserDate();
});

final updateUserProvider = Provider.autoDispose<UserProvider>((ref) {
  var _token = ref.watch(authProvider);
  return UserProvider(authToken: _token['token'], userId: _token['userId']);
});

class UserProvider {
  late String authToken;
  late int userId;
  UserProvider({required this.authToken, required this.userId});

  Future<User> fetchUserDate() async {
    Uri _url = Uri.parse('http://10.0.2.2:5000/api/users/$userId');
    try {
      final response = await http.get(_url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final _loadedUser = User.fromJson(json: extractedData);
      return _loadedUser;
    } on FormatException {
      throw true;
      // HttpException(
      //   'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      // );
    } catch (error) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
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
    } catch (error) {
      rethrow;
    }
  }

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
