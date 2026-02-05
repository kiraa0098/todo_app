import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _firstNameKey = 'user_first_name';
  static const _lastNameKey = 'user_last_name';
  static const _middleNameKey = 'user_middle_name';
  static const _suffixKey = 'user_suffix';
  static const _birthdayKey = 'user_birthday';
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> saveUserInfo({
    required String id,
    required String firstName,
    required String lastName,
    String? middleName,
    String? suffix,
    String? birthday,
  }) async {
    await _storage.write(key: _userIdKey, value: id);
    await _storage.write(key: _firstNameKey, value: firstName);
    await _storage.write(key: _lastNameKey, value: lastName);
    await _storage.write(key: _middleNameKey, value: middleName ?? '');
    await _storage.write(key: _suffixKey, value: suffix ?? '');
    await _storage.write(key: _birthdayKey, value: birthday ?? '');
  }

  static Future<Map<String, String?>> getUserInfo() async {
    return {
      'id': await _storage.read(key: _userIdKey),
      'firstName': await _storage.read(key: _firstNameKey),
      'lastName': await _storage.read(key: _lastNameKey),
      'middleName': await _storage.read(key: _middleNameKey),
      'suffix': await _storage.read(key: _suffixKey),
      'birthday': await _storage.read(key: _birthdayKey),
    };
  }

  static Future<void> deleteUserInfo() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _firstNameKey);
    await _storage.delete(key: _lastNameKey);
    await _storage.delete(key: _middleNameKey);
    await _storage.delete(key: _suffixKey);
    await _storage.delete(key: _birthdayKey);
  }
}
