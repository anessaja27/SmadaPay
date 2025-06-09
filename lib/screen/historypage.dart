import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    String? transactionsJson = await _storage.read(key: 'transactions');

    if (transactionsJson != null) {
      setState(() {
        _transactions =
            List<Map<String, dynamic>>.from(json.decode(transactionsJson));
      });
    }
  }

  String formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat("dd MMM yyyy, HH:mm").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        automaticallyImplyLeading: false,
      ),
      body: _transactions.isEmpty
          ? const Center(child: Text("Belum ada transaksi."))
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];

                // **Tentukan tampilan berdasarkan jenis transaksi**
                String title = "";
                String subtitle = "";
                IconData icon;
                Color iconColor;
                Color cardColor = Colors.white;

                if (transaction['type'] == 'Kirim Saldo') {
                  title = "Kirim Saldo ke ${transaction['phone']}";
                  subtitle =
                      "Rp${transaction['amount']} - ${formatDate(transaction['date'])}";
                  icon = Icons.arrow_upward;
                  iconColor = Colors.red;
                  cardColor = Colors.red[50]!;
                } else if (transaction['type'] == 'Pembayaran') {
                  title = "Pembayaran ke ${transaction['store']}";
                  subtitle =
                      "Rp${transaction['amount']} - ${formatDate(transaction['date'])}";
                  icon = Icons.shopping_cart;
                  iconColor = Colors.blue;
                  cardColor = Colors.blue[50]!;
                } else if (transaction['type'] == 'Topup') {
                  title = "Topup ke ${transaction['myphone']}";
                  subtitle =
                      "Rp${transaction['amount']} - ${formatDate(transaction['date'])}";
                  icon = Icons.arrow_downward;
                  iconColor = Colors.green;
                  cardColor = Colors.green[50]!;
                } else {
                  title = "Transaksi Tidak Diketahui";
                  subtitle = "${transaction['date']}";
                  icon = Icons.error;
                  iconColor = Colors.grey;
                }

                return Card(
                  color: cardColor,
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withOpacity(0.2),
                      child: Icon(icon, color: iconColor),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35)),
          boxShadow: const [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)
          ],
          color: Colors.blue.shade300,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 7.5,
          ),
          child: GNav(
            selectedIndex: 1,
            backgroundColor: Colors.blue.shade300,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue.shade400,
            gap: 8,
            onTabChange: (index) {
              print(index);
            },
            padding: const EdgeInsets.all(15),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  Navigator.pushNamed(context, '/homepage');
                },
              ),
              GButton(
                icon: Icons.history_rounded,
                text: 'History',
                onPressed: () {
                  Navigator.pushNamed(context, '/historypage');
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                onPressed: () {
                  Navigator.pushNamed(context, '/profilepage');
                },
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                onPressed: () {
                  Navigator.pushNamed(context, '/settingspage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
