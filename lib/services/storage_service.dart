import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/tag_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/services/search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user';
  static const String _tokenKey = 'tokens';
  static const String _tagsKey = 'tags';

  Future<void> saveUser(UserInfo user) async {
    final userJson = jsonEncode(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
  }

  Future<UserInfo> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userString = prefs.getString(_userKey);
      if (userString == null) {
        throw Exception("No user saved");
      }

      final userJson = jsonDecode(userString);
      return UserInfo.fromJson(userJson);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<void> saveTokens(Token token) async {
    final tokenJson = jsonEncode(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, tokenJson);
  }

  Future<Token> getTokens() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final savedTokens = prefs.getString(_tokenKey);
      if (savedTokens == null) {
        throw Exception("No tokens saved");
      }

      final tokenJson = jsonDecode(savedTokens);
      return Token.fromJson(tokenJson);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<void> saveTags(List<TagModel> tags) async {
    final tagsJson = jsonEncode(tags);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tagsKey, tagsJson);
  }

  Future<List<TagModel>> getTags() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final savedTags = prefs.getString(_tagsKey);
      if (savedTags == null) {
        throw Exception("No tags saved");
      }

      List tagsJson = jsonDecode(savedTags);

      return tagsJson.map((tag) {
        return TagModel.fromJson(tag);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final data = prefs.getString(key);
      if (data == null) {
        throw Exception("No data saved");
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future saveStringData(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, data);
  }

  Future<void> loadData() async {
    try {
      final user = await getUser();
      getIt.get<AuthModel>().saveUser(user);

      final tokens = await getTokens();
      getIt.get<AuthModel>().saveTokens(tokens);

      final savedTags = await getTags();
      getIt.get<SearchingService>().setTags(
            savedTags.map((tag) => tag.title).toList(),
          );
    } catch (e) {
      if (kDebugMode) {
        print('Error loading saved data: $e');
      }
    }
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_tagsKey);
  }
}
