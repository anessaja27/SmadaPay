import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> savePin(String pin) async {
    await _storage.write(key: 'user_pin', value: pin);
  }

  static Future<String?> getPin() async {
    return await _storage.read(key: 'user_pin');
  }

  static Future<void> deletePin() async {
    await _storage.delete(key: 'user_pin');
  }
}
