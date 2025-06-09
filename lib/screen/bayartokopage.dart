import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smada_pay_app3/storage/saldostorage.dart';

import 'dart:convert';

class BayarTokoPage extends StatefulWidget {
  final String storeName;
  final String storeAccount;

  const BayarTokoPage(
      {super.key, required this.storeName, required this.storeAccount});

  @override
  State<BayarTokoPage> createState() => _BayarTokoPageState();
}

class _BayarTokoPageState extends State<BayarTokoPage> {
  final TextEditingController _amountController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  int _currentBalance = 0;
  List<int> presetAmounts = [5000, 10000, 20000, 50000, 100000];

  @override
  void initState() {
    super.initState();
    _updateBalance();
  }

  void _updateBalance() async {
    int updatedBalance = await BalanceStorage.getBalance();
    setState(() {
      _currentBalance = updatedBalance;
    });
  }

  void _selectAmount(int amount) {
    _amountController.text = amount.toString();
  }

  void _confirmPayment() async {
    int payAmount = int.tryParse(_amountController.text) ?? 0;
    if (payAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Masukkan jumlah yang valid!")),
      );
      return;
    }

    if (payAmount > _currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Saldo tidak cukup!")),
      );
      return;
    }

    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Text(
            "Apakah Anda yakin ingin membayar Rp$payAmount ke ${widget.storeName}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Lanjut")),
        ],
      ),
    );

    if (confirm == true) {
      _verifyPin(payAmount); // **Panggil fungsi input PIN**
    }
  }

  void _verifyPin(int payAmount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController pinController = TextEditingController();

        return AlertDialog(
          title: const Text("Masukkan PIN"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: true,
                keyboardType: TextInputType.number,
                controller: pinController,
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
                String? savedPin = await _storage.read(key: "user_pin");
                if (pinController.text == savedPin) {
                  Navigator.pop(context);
                  _processPayment(payAmount);
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

  void _saveTransaction(String storeName, int amount) async {
    // Ambil data transaksi yang sudah tersimpan
    String? transactionsJson = await _storage.read(key: 'transactions');
    List<Map<String, dynamic>> transactions = [];

    if (transactionsJson != null) {
      transactions =
          List<Map<String, dynamic>>.from(json.decode(transactionsJson));
    }

    // Tambahkan transaksi baru
    transactions.add({
      'type': 'Pembayaran',
      'store': storeName,
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
    });

    // Simpan kembali ke storage
    await _storage.write(key: 'transactions', value: json.encode(transactions));
  }

  void _processPayment(int payAmount) async {
    int newBalance = _currentBalance - payAmount;
    await BalanceStorage.saveBalance(newBalance);
    _updateBalance();

    _saveTransaction(widget.storeName, payAmount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text("✅ Berhasil membayar Rp$payAmount ke ${widget.storeName}!")),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(
        context, true); // Kembali ke halaman utama dengan hasil 'true'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bayar ke ${widget.storeName}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Akun Toko: ${widget.storeAccount}",
                style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            // **Pilihan Pecahan**
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // **Input Jumlah Manual**
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jumlah Pembayaran"),
            ),

            const SizedBox(height: 20),

            // **Tombol Bayar**
            Center(
              child: ElevatedButton(
                onPressed: _confirmPayment,
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
                    "Bayar Sekarang",
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
