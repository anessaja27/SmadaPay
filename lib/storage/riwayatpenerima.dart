import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecipientHistory {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveRecipient(String phoneNumber) async {
    // Ambil data lama
    String? existingData = await _storage.read(key: 'recipient_history');

    List<String> recipientList =
        existingData != null ? List<String>.from(jsonDecode(existingData)) : [];

    // Tambahkan nomor baru (hindari duplikasi)
    if (!recipientList.contains(phoneNumber)) {
      recipientList.add(phoneNumber);
    }

    // Simpan kembali ke storage
    await _storage.write(
        key: 'recipient_history', value: jsonEncode(recipientList));
  }

  static Future<List<String>> getRecipients() async {
    String? existingData = await _storage.read(key: 'recipient_history');
    return existingData != null
        ? List<String>.from(jsonDecode(existingData))
        : [];
  }
}
