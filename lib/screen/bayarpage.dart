import 'package:flutter/material.dart';
import 'package:smada_pay_app3/screen/bayartokopage.dart';

class BayarPage extends StatelessWidget {
  final List<Map<String, String>> stores = [
    {"name": "Warung Bu Man", "account": "warung.bu.man"},
    {"name": "Kedai Bang Syen", "account": "kedai.bang.syen"},
    {"name": "Kopsis", "account": "kopsis"},
    {"name": "Kedai Tante", "account": "kedai.tante"},
  ];

  BayarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pilih Toko",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        separatorBuilder: (context, index) =>
            const Divider(), // Garis pemisah antar toko
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(stores[index]["name"]!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text("Akun: ${stores[index]["account"]}"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BayarTokoPage(
                    storeName: stores[index]["name"]!,
                    storeAccount: stores[index]["account"]!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
