import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/user.dart';
import '/models/http_exception.dart';
import '/providers/auth.dart';

const userUri = 'http://10.0.2.2:5000/api/users/1';
Uri url = Uri.parse(userUri);

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  String _token = ref.watch(authProvider).token;
  return UserNotifier(authToken: _token);
});

class UserNotifier extends StateNotifier<User> {
  UserNotifier({required this.authToken}) : super(User());
  late String authToken;

  Future<void> fetchUserDate() async {
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'Authorization': 'Bearer $authToken',
      });
      final extractedData =
          await json.decode(response.body) as Map<String, dynamic>;
      final _loadedUser = User.fromJson(json: extractedData);
      state = _loadedUser;
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
}
