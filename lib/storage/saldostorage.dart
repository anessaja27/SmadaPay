import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BalanceStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveBalance(int balance) async {
    await _storage.write(key: 'user_balance', value: balance.toString());
  }

  static Future<int> getBalance() async {
    String? balance = await _storage.read(key: 'user_balance');

    if (balance == null) {
      // Jika saldo belum ada, atur saldo awal misalnya Rp100.000
      await saveBalance(0);
      return 0;
    }

    return int.parse(balance);
  }
}
