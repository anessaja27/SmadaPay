// ignore_for_file: sort_child_properties_last
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smada_pay_app3/screen/aboutpage.dart';
import 'package:smada_pay_app3/screen/bayarpage.dart';
import 'package:smada_pay_app3/screen/kirimpage.dart';
import 'package:smada_pay_app3/screen/topuppage.dart';
import 'package:smada_pay_app3/storage/saldostorage.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "Pengguna";

  int _currentBalance = 0;

  final List<Map<String, String>> newsList = [
    {
      "title":
          "Penerimaan Rapor Semester Ganjil SMAN 2 Probolinggo Tahun 2024 Berlangsung Tertib dan Bermakna",
      "image": "assets/images/berita1.jpg", // Ganti dengan URL gambar berita
      "url":
          "https://www.sman2-pbl.sch.id/berita/detail/penerimaan-rapor-semester-ganjil-sman-2-probolinggo-tahun-2024-berlangsung-tertib-dan-bermakna",
    },
    {
      "title":
          "Penutupan Meriah Kegiatan CLASSMEDA SMAN 2 Probolinggo Tahun 2024",
      "image": "assets/images/berita2.jpg",
      "url":
          "https://www.sman2-pbl.sch.id/berita/detail/penutupan-meriah-kegiatan-classmeda-sman-2-probolinggo--tahun-2024",
    },
    {
      "title":
          "Kegiatan Bimbingan Teknis Strategi Peningkatan Kualitas Pembelajaran",
      "image": "assets/images/berita3.jpg",
      "url":
          "https://www.sman2-pbl.sch.id/berita/detail/kegiatan-bimbingan-teknis-strategi-peningkatan-kualitas-pembelajaran-",
    },
    {
      "title": "Prestasi Non Akademik Peserta Didik SMAN 2 Probolinggo",
      "image": "assets/images/berita4.jpg",
      "url":
          "https://www.sman2-pbl.sch.id/berita/detail/prestasi-non-akademik-peserta-didik-sman-2-probolingg0",
    },
  ];

  // Fungsi untuk membuka URL berita
  void _openNews(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Tidak bisa membuka URL: $url");
    }
  }

  @override
  void initState() {
    super.initState();
    _updateBalance();
    _loadUserProfile();
  }

  void _updateBalance() async {
    int updatedBalance = await BalanceStorage.getBalance();
    setState(() {
      _currentBalance = updatedBalance;
    });
  }

  void _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 45,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Halo,",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Stack(
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            Positioned(
                              top: 0.0,
                              right: 0.0,
                              child: Icon(
                                Icons.brightness_1,
                                size: 8.0,
                                color: Colors.redAccent,
                              ),
                            )
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 125,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ]),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const Text(
                        "Saldo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp.$_currentBalance",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const KirimPage()),
                                );

                                setState(() {
                                  _updateBalance();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.send_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Kirim',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BayarPage()),
                                );

                                setState(() {
                                  _updateBalance();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.payment,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Bayar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TopupPage()),
                                );

                                setState(() {
                                  _updateBalance();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add_box_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Top-up',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 65,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AboutPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.people_alt_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'About Us',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Agar teks rata kiri
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2)),
                            ]),
                        child: const Text(
                          "Berita Terkini di SMAN 2 Probolinggo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];

                      return GestureDetector(
                        onTap: () => _openNews(news["url"]!),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  news["image"]!,
                                  width: 100, // Atur lebar thumbnail
                                  height:
                                      100, // Sesuaikan dengan tinggi ListTile
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  news["title"]!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
            selectedIndex: 0,
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
              const GButton(
                icon: Icons.home,
                text: 'Home',
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
