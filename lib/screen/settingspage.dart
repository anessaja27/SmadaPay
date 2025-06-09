import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smada_pay_app3/screen/ubahpinpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool("notifications") ?? true;
    });
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text("Pengaturan"),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              title: const Text("Ubah PIN"),
              trailing: const Icon(Icons.lock),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UbahPinPage()),
                );
              },
            ),
            SwitchListTile(
              title: const Text("Notifikasi"),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _updateSetting("notifications", value);
              },
            ),
            ListTile(
              title: const Text("Tentang Aplikasi"),
              trailing: const Icon(Icons.info),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "SmadaPay",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2025 Kelompok 5",
                );
              },
            ),
          ],
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
              selectedIndex: 3,
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
        ));
  }
}
