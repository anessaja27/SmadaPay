import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void _savePin() async {
    String pin = _pinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_registered', true);
    await prefs.setBool('has_pin', true);

    if (pin.length != 4 || confirmPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN harus 4 digit")),
      );
      return;
    }

    if (pin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN tidak cocok, coba lagi!")),
      );
      return;
    }

    // Simpan PIN ke secure storage
    await _storage.write(key: 'user_pin', value: pin);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PIN berhasil dibuat!")),
    );

    // Navigasi ke halaman utama (ganti dengan halaman utama aplikasi)
    Navigator.pushReplacementNamed(context, '/homepage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Buat PIN Keamanan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              keyboardType: TextInputType.number,
              controller: _pinController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            const Text(
              "Konfirmasi PIN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              keyboardType: TextInputType.number,
              controller: _confirmPinController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _savePin,
              child: const Text("Simpan PIN", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
