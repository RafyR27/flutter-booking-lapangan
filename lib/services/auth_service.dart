import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);

  bool get isLoggedIn => isLoggedInNotifier.value;

  String userName = 'Rafy Ramadhan';
  String userEmail = 'rafy.ramadhan@example.com';
  String userWhatsApp = '081289123456';

  void login({String? name, String? email, String? phone}) {
    if (name != null) userName = name;
    if (email != null) userEmail = email;
    if (phone != null) userWhatsApp = phone;
    isLoggedInNotifier.value = true;
  }

  void logout() {
    isLoggedInNotifier.value = false;
  }

  void setGuest() {
    isLoggedInNotifier.value = false;
  }
}
