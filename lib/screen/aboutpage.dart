import 'package:flutter/material.dart';

import 'dart:ui';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade300, // Warna header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 150,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "SmadaPay",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kami dari kelompok 5 yang bertujuan untuk memberikan kemudahan dalam bertransaksi digital yang cepat, aman, dan nyaman.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "📌 Anggota Kelompok",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text("1. Andrasena Nugraha (09)"),
            const Text("2. Faiz Hidayat Zulfikar (17)"),
            const Text("3. Farrel Dwianshah (18)"),
            const Text('4. Febryan Dwi Sahputra (19)'),
            const Text('5. M. Bagas Wicaksono (23)'),
            const Text('6. Taurik Muktio Alhamdani (35)'),
            const SizedBox(height: 20),
            const Text(
              "📞 Kontak Kami",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Row(
              children: [
                Icon(Icons.email, color: Colors.orange),
                SizedBox(width: 10),
                Text("andranugraha2705@gmail.com"),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.phone, color: Colors.orange),
                SizedBox(width: 10),
                Text("+62 813-5946-7083"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
