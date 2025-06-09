import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smada_pay_app3/screen/registerpage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Memuat data profil yang tersimpan
  void _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
    });
  }

  // Simpan data profil
  void _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_phone', _phoneController.text);
    await prefs.setString('user_email', _emailController.text);

    await prefs.setBool('is_registered', true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Profil berhasil dibuat!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const RegisterPage()), // Pindah ke HomePage
    ); // Kembali ke halaman sebelumnya
  }

  // Ambil foto profil dari galeri
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Akun/Profil"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // Input Nama
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Pengguna"),
            ),

            const SizedBox(height: 10),

            // Input Nomor Telepon
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Nomor Telepon"),
            ),

            const SizedBox(height: 10),

            // Input Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveProfileData,
              child: const Text("Simpan Profil dan Buat Pin"),
            ),
          ],
        ),
      ),
    );
  }
}
