import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nearby_assist/model/user_info.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthModel extends ChangeNotifier {
  AuthStatus _isLoggedIn = AuthStatus.unauthenticated;
  UserInfo? _userInfo;
  AccessToken? _accessToken;

  void setAccessToken(AccessToken? token) {
    _accessToken = token;
    notifyListeners();
  }

  AccessToken? getAccessToken() {
    return _accessToken;
  }

  AuthStatus getLoginStatus() {
    return _isLoggedIn;
  }

  void login(UserInfo user) {
    _userInfo = UserInfo(
      userId: user.userId,
      name: user.name,
      email: user.email,
      imageUrl: user.imageUrl,
    );

    _isLoggedIn = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _userInfo = null;
    _isLoggedIn = AuthStatus.unauthenticated;
    _accessToken = null;

    notifyListeners();
  }

  UserInfo? getUser() {
    return _userInfo;
  }

  int? getUserId() {
    return _userInfo?.userId;
  }
}
