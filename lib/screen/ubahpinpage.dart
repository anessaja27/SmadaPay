import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class UbahPinPage extends StatefulWidget {
  const UbahPinPage({super.key});

  @override
  State<UbahPinPage> createState() => _UbahPinPageState();
}

class _UbahPinPageState extends State<UbahPinPage> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  void _changePin() async {
    String? savedPin = await _storage.read(key: "user_pin");
    String oldPin = _oldPinController.text;
    String newPin = _newPinController.text;
    String confirmPin = _confirmPinController.text;

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Semua kolom harus diisi!")),
      );
      return;
    }

    if (savedPin != oldPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ PIN lama salah!")),
      );
      return;
    }

    if (newPin.length != 4 || confirmPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ PIN harus terdiri dari 4 angka!")),
      );
      return;
    }

    if (newPin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ PIN baru tidak cocok!")),
      );
      return;
    }

    await _storage.write(key: "user_pin", value: newPin);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ PIN berhasil diubah!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ubah PIN")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Masukkan PIN Lama", style: TextStyle(fontSize: 16)),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _oldPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                selectedColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Text("Masukkan PIN Baru", style: TextStyle(fontSize: 16)),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                selectedColor: Colors.greenAccent,
              ),
            ),
            SizedBox(height: 20),
            Text("Konfirmasi PIN Baru", style: TextStyle(fontSize: 16)),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.green,
                inactiveColor: Colors.grey,
                selectedColor: Colors.greenAccent,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _changePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Simpan PIN Baru",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
