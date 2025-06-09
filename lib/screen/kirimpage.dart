import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import 'dart:convert';

import 'package:smada_pay_app3/storage/saldostorage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> savePin(String pin) async {
    await _storage.write(key: 'user_pin', value: pin);
  }

  static Future<String?> getPin() async {
    return await _storage.read(key: 'user_pin');
  }

  static Future<void> saveRecipient(String phoneNumber) async {
    String? existingData = await _storage.read(key: 'recipient_history');
    List<String> recipientList =
        existingData != null ? List<String>.from(jsonDecode(existingData)) : [];

    if (!recipientList.contains(phoneNumber)) {
      recipientList.add(phoneNumber);
    }

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

class KirimPage extends StatefulWidget {
  const KirimPage({super.key});

  @override
  State<KirimPage> createState() => _KirimPageState();
}

class _KirimPageState extends State<KirimPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final List<int> _denominations = [5000, 10000, 20000, 50000, 100000];

  void _selectAmount(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  void _saveTransaction(String phoneNumber, int amount) async {
    // Ambil data transaksi yang sudah tersimpan
    String? transactionsJson = await _storage.read(key: 'transactions');
    List<Map<String, dynamic>> transactions = [];

    if (transactionsJson != null) {
      transactions =
          List<Map<String, dynamic>>.from(json.decode(transactionsJson));
    }

    // Tambahkan transaksi baru
    transactions.add({
      'type': 'Kirim Saldo',
      'phone': phoneNumber,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    });

    // Simpan kembali ke storage
    await _storage.write(key: 'transactions', value: json.encode(transactions));
  }

  List<String> _recipientHistory = [];

  @override
  void initState() {
    super.initState();
    _loadRecipients();
  }

  void _loadRecipients() async {
    List<String> recipients = await SecureStorage.getRecipients();
    setState(() {
      _recipientHistory = recipients;
    });
  }

  void _confirmTransaction() {
    String phoneNumber = _phoneController.text.trim();
    String amount = _amountController.text.trim();

    if (phoneNumber.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Mohon isi semua data")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Transaksi"),
          content: Text("Anda akan mengirim Rp$amount ke $phoneNumber"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _verifyPin(phoneNumber, amount);
              },
              child: const Text("Lanjutkan"),
            ),
          ],
        );
      },
    );
  }

  void _verifyPin(String phoneNumber, String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController pinController = TextEditingController();

        return AlertDialog(
          title: const Text("Masukkan PIN"),
          content: PinCodeTextField(
            appContext: context,
            length: 4,
            obscureText: true,
            keyboardType: TextInputType.number,
            controller: pinController,
            onChanged: (value) {},
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? savedPin = await SecureStorage.getPin();
                if (pinController.text == savedPin) {
                  Navigator.pop(context);
                  _sendMoney(phoneNumber, amount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("❌ PIN salah!")),
                  );
                }
              },
              child: const Text("Verifikasi"),
            ),
          ],
        );
      },
    );
  }

  void _sendMoney(String phoneNumber, String amount) async {
    int currentBalance = await BalanceStorage.getBalance();
    int transferAmount = int.parse(amount);

    if (transferAmount > currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Saldo tidak cukup!")),
      );
      return;
    }

    int newBalance = currentBalance - transferAmount;
    await BalanceStorage.saveBalance(newBalance); // Perbarui saldo di storage
    _updateBalance(); // Perbarui tampilan di halaman utama

    _saveTransaction(phoneNumber, transferAmount);

    await SecureStorage.saveRecipient(phoneNumber);
    _loadRecipients();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("✅ Saldo Rp$amount berhasil dikirim ke $phoneNumber!")),
    );
  }

  void _updateBalance() async {
    setState(() {
// Update saldo yang ditampilkan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kirim Saldo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nomor Penerima"),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(hintText: "Contoh: 08123456789"),
            ),
            const SizedBox(height: 20),
            const Text("Jumlah Saldo"),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: "Masukkan jumlah saldo"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Pilih Pecahan Saldo:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _denominations.map((amount) {
                return ElevatedButton(
                  onPressed: () => _selectAmount(amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Rp.$amount",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _confirmTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 105, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  textAlign: TextAlign.center,
                  "Kirim Sekarang",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("📌 Riwayat Penerima"),
            Expanded(
              child: ListView.separated(
                itemCount: _recipientHistory.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_recipientHistory[index]),
                    onTap: () {
                      _phoneController.text = _recipientHistory[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
