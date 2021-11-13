import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/user.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

const userUri = 'http://10.0.2.2:5000/api/users/1';
Uri url = Uri.parse(userUri);
const passUri = 'http://10.0.2.2:5000/api/auth/1/changepassword';
Uri passurl = Uri.parse(passUri);

final userProvider = FutureProvider.autoDispose<User>((ref) async {
  String _token = ref.watch(authProvider).token;
  return UserProvider(authToken: _token).fetchUserDate();
});

final updateUserProvider = Provider.autoDispose<UserProvider>((ref) {
  String _token = ref.watch(authProvider).token;
  return UserProvider(authToken: _token);
});

class UserProvider {
  late String authToken;
  UserProvider({required this.authToken});

  Future<User> fetchUserDate() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final _loadedUser = User.fromJson(json: extractedData);
      return _loadedUser;
    } on FormatException {
      throw HttpException(
        'عفوا لقد انتهت صلاحيتك لستخدام البرنامج \n برجاء اعد تسجيل الدخول',
      );
    } catch (error) {
      throw HttpException(
        'تعذر الاتصال بالسيرفر برجاء التاكد من الاتصال بالشبكة الصحيحة',
      );
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await http.put(
        url,
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
      throw error;
    }
  }

  Future<void> updatePassword({
    required String oldPass,
    required String newPass,
    required String confirmPass,
  }) async {
    try {
      await http.put(
        passurl,
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
      throw error;
    }
  }
}
