import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smada_pay_app3/storage/saldostorage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smada_pay_app3/storage/storage.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<int> presetAmounts = [5000, 10000, 20000, 50000, 100000];

  void _selectAmount(int amount) {
    _amountController.text = amount.toString();
  }

  void _confirmTopUp() async {
    int topUpAmount = int.tryParse(_amountController.text) ?? 0;

    if (topUpAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Masukkan jumlah yang valid!")),
      );
      return;
    }

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Top-Up"),
        content: Text(
            "Apakah Anda yakin ingin mengisi saldo sebesar Rp$topUpAmount?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Batal")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Lanjut")),
        ],
      ),
    );

    if (confirm == true) {
      _authenticatePin(topUpAmount);
    }
  }

  void _authenticatePin(int topUpAmount) async {
    String? savedPin = await _storage.read(key: "user_pin");
    if (savedPin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ PIN belum diset. Silakan registrasi dulu.")),
      );
      return;
    }

    bool? pinCorrect = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Masukkan PIN"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              keyboardType: TextInputType.number,
              controller: _pinController,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              String? savedPin = await SecureStorage.getPin();
              if (_pinController.text == savedPin) {
                Navigator.pop(context);
                _processTopUp(topUpAmount);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❌ PIN salah!")),
                );
              }
            },
            child: const Text("Verifikasi"),
          ),
        ],
      ),
    );

    if (pinCorrect == true) {
      _processTopUp(topUpAmount);
    }
  }

  void _saveTransaction(int topUpAmount) async {
    // Ambil data transaksi yang sudah tersimpan
    String? transactionsJson = await _storage.read(key: 'transactions');
    List<Map<String, dynamic>> transactions = [];

    if (transactionsJson != null) {
      transactions =
          List<Map<String, dynamic>>.from(json.decode(transactionsJson));
    }

    // Tambahkan transaksi baru
    transactions.add({
      'type': 'Topup',
      'myphone': '081359467083',
      'amount': topUpAmount,
      'date': DateTime.now().toIso8601String(),
    });

    // Simpan kembali ke storage
    await _storage.write(key: 'transactions', value: json.encode(transactions));
  }

  void _processTopUp(int topUpAmount) async {
    int currentBalance = await BalanceStorage.getBalance();
    int newBalance = currentBalance + topUpAmount;
    await BalanceStorage.saveBalance(newBalance);

    _saveTransaction(topUpAmount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Top-Up Rp$topUpAmount berhasil!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top-Up Saldo")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pilih Nominal Top-Up:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: presetAmounts.map((amount) {
                return ElevatedButton(
                  onPressed: () => _selectAmount(amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Rp$amount",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Jumlah Top-Up"),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _confirmTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                    textAlign: TextAlign.center,
                    "Top-Up Sekarang",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
