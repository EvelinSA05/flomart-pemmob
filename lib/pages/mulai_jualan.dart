import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../widgets/flomart_bottom_nav.dart';
import '../widgets/flomart_header.dart';
import 'beranda.dart';
import 'blog.dart';
import 'login.dart';
import 'registrasi.dart';
import 'tentang_kami.dart';
import 'toko.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: sellRoute,
      routes: {
        homeRoute: (_) => const HomePage(),
        shopRoute: (_) => const ShopPage(),
        sellRoute: (_) => const StartSellingPage(),
        blogRoute: (_) => const BlogPage(),
        aboutRoute: (_) => const AboutUsPage(),
      },
    );
  }
}

class StartSellingPage extends StatelessWidget {
  const StartSellingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlomartHeader(),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.sell),

      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            ManfaatSection(),
            DampakUMKMSection(),
            BannerCard(
              title: 'Aktivitas UMKM',
              description:
                  'UMKM lokal memanfaatkan FLOMART untuk menjual produk tanaman secara online dengan lebih mudah dan aman.',
              imagePath: 'assets/img/konten_blog/fotoMulaiJualan1.png',
            ),
            BannerCard(
              title: 'Testimoni Penjual',
              description:
                  '“Sejak jualan di FLOMART, pesanan meningkat dan pengelolaan produk jadi lebih rapi.” Pak Anton, Jawa Timur"',
              imagePath: 'assets/img/konten_blog/fotoMulaiJualan2.png',
            ),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(
            'assets/img/system/BannerBg.png',
          ), // background kamu
          fit: BoxFit.cover,
        ),
      ),

      child: Row(
        children: [
          // 🔹 KIRI (TEXT + BUTTON)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Jual Tanamanmu,\nTumbuhkan Bisnismu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // biar kebaca di banner
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gabung sebagai penjual di FLOMART dan perluas jangkauan bisnismu.',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const regisPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Register'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          elevation: 3,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 KANAN (IMAGE HERO)
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/img/system/FotoJualan.png', // gambar kanan kamu
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class ManfaatSection extends StatelessWidget {
  const ManfaatSection({super.key});

  Widget item(String title, String desc) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title),
        subtitle: Text(desc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Manfaat FLOMART Seller',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          item('Mudah Digunakan', 'Kelola produk dengan cepat'),
          item('Penjual Terverifikasi', 'Meningkatkan kepercayaan'),
          item('Ramah Lingkungan', 'Dukung bisnis hijau'),
        ],
      ),
    );
  }
}

class DampakUMKMSection extends StatelessWidget {
  const DampakUMKMSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Dampak Kami Bagi UMKM',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            'FLOMART membantu UMKM dan penjual tanaman memperluas pasar, meningkatkan penjualan, dan mengelola bisnis secara lebih efisien melalui platform digital yang aman dan berkelanjutan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 30),

          _stat('18%', 'Peningkatan Penjualan', Colors.green),

          const SizedBox(height: 25),

          _stat('180k', 'Produk Terjual', Colors.orange),

          const SizedBox(height: 25),

          _stat('10+', 'Wilayah Terjangkau', Colors.brown),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

class BannerCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const BannerCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 🖼️ GAMBAR
            Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // 🌑 Overlay biar text kebaca
            Container(color: Colors.black.withValues(alpha: 0.4)),

            // 📝 TEXT
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Toko'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Jual'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blog'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
      ],
    );
  }
}
