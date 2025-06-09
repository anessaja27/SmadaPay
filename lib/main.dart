import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smada_pay_app3/screen/aboutpage.dart';
import 'package:smada_pay_app3/screen/bayarpage.dart';
import 'package:smada_pay_app3/screen/historypage.dart';
import 'package:smada_pay_app3/screen/homepage.dart';
import 'package:smada_pay_app3/screen/kirimpage.dart';
import 'package:smada_pay_app3/screen/loginpage.dart';
import 'package:smada_pay_app3/screen/profilepage.dart';
import 'package:smada_pay_app3/screen/registerpage.dart';
import 'package:smada_pay_app3/screen/settingspage.dart';
import 'package:smada_pay_app3/screen/signuppage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smada_pay_app3/screen/ubahpinpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Status bar transparan
      statusBarIconBrightness: Brightness
          .dark, // Ikon status bar gelap (cocok untuk background terang)
      systemNavigationBarColor: Colors.white, // Warna navigation bar
      systemNavigationBarIconBrightness:
          Brightness.dark, // Ikon navigation bar gelap
    ),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isRegistered = prefs.getBool('is_registered') ?? false;
  bool hasPin = prefs.getBool('has_pin') ?? false;

  runApp(MyApp(isRegistered: isRegistered, hasPin: hasPin));
}

class MyApp extends StatelessWidget {
  final bool isRegistered;
  final bool hasPin;

  MyApp({required this.isRegistered, required this.hasPin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmadaPay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      home: isRegistered
          ? (hasPin
              ? LoginPage()
              : HomePage()) // Jika sudah daftar, cek apakah punya PIN
          : SignupPage(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/profilepage': (context) => const ProfilePage(),
        '/settingspage': (context) => const SettingsPage(),
        '/kirimpage': (context) => const KirimPage(),
        '/registerpage': (context) => const RegisterPage(),
        '/bayarpage': (context) => BayarPage(),
        '/aboutpage': (context) => const AboutPage(),
        '/historypage': (context) => const HistoryPage(),
        '/signuppage': (context) => const SignupPage(),
        '/loginpage': (context) => const LoginPage(),
        '/ubahpinpage': (context) => const UbahPinPage()
      },
    );
  }
}
