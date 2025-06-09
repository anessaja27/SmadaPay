import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isChecking = false;

  Future<void> _checkPin() async {
    setState(() => _isChecking = true);

    String? savedPin = await _storage.read(key: 'user_pin');
    String enteredPin = _pinController.text.trim();

    if (enteredPin == savedPin) {
      Navigator.pushReplacementNamed(context, '/homepage');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN salah, coba lagi!")),
      );
    }

    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Masukkan PIN")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Masukkan PIN Anda",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              keyboardType: TextInputType.number,
              controller: _pinController,
              onChanged: (value) {},
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isChecking ? null : _checkPin,
              child: _isChecking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Masuk", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
