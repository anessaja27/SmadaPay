import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadProfileImage();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File tempFile = File(pickedFile.path);

      // Simpan gambar di direktori aplikasi agar tetap ada setelah restart
      Directory appDir = await getApplicationDocumentsDirectory();
      String fileName = basename(pickedFile.path);
      File savedImage = await tempFile.copy('${appDir.path}/$fileName');

      // Simpan path gambar ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', savedImage.path);

      setState(() {
        _image = savedImage;
      });
    }
  }

  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

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
    ScaffoldMessenger.of(context as BuildContext)
        .showSnackBar(const SnackBar(content: Text("Perubahan disimpan")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Pengguna"),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Nomor Telepon"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _saveProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                foregroundColor: Colors.white, // Ganti warna tombol
                padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32), // Atur ukuran tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Atur sudut tombol
                ),
              ),
              child: const Text(
                "Simpan Perubahan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
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
            selectedIndex: 2,
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
              const GButton(
                icon: Icons.person,
                text: 'Profile',
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
