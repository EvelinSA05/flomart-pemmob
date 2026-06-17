import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase_seeder.dart';
import 'services/app_state.dart';

import 'app_routes.dart';
import 'pages/beranda/beranda.dart';
import 'pages/blog/blog.dart';
import 'pages/jualan/mulai_jualan.dart';
import 'pages/info/tentang_kami.dart';
import 'pages/toko/toko.dart';
import 'pages/toko/dashboard_seller.dart';
import 'pages/toko/produk_saya.dart';
import 'pages/toko/tambah_produk.dart';
import 'pages/toko/pesanan_seller.dart';
import 'pages/toko/data_seller.dart';
import 'pages/toko/keuangan_seller.dart';
import 'pages/toko/pengaturan_seller.dart';
import 'pages/toko/chat_list_seller.dart';
import 'pages/toko/chat_detail_seller.dart';
import 'pages/auth/login.dart';
import 'pages/auth/registrasi.dart';
import 'pages/beranda/beranda_sesudah_login.dart';
import 'pages/profile/profile.dart';
import 'pages/profile/pesanan_saya.dart';
import 'pages/beranda/cart_page.dart';
import 'pages/beranda/notifikasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Seed 20 produk dummy ke Firestore jika masih kosong (Sesuai kriteria UAS)
  await FirebaseSeeder.seedProducts();
  
  // Load login session
  await AppState().loadLoginInfo();
  
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flomart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: _getInitialRoute(),
      routes: {
        homeRoute: (_) => const HomePage(),
        shopRoute: (_) => const ShopPage(),
        sellRoute: (_) => const StartSellingPage(),
        blogRoute: (_) => const BlogPage(),
        aboutRoute: (_) => const AboutUsPage(),
        dashboardSellerRoute: (_) => const DashboardSellerPage(),
        produkSayaRoute: (_) => const ProdukSayaPage(),
        tambahProdukRoute: (_) => const TambahProdukPage(),
        pesananSellerRoute: (_) => const PesananSellerPage(),
        dataSellerRoute: (_) => const DataSellerPage(),
        keuanganSellerRoute: (_) => const KeuanganSellerPage(),
        pengaturanSellerRoute: (_) => const PengaturanSellerPage(),
        chatListSellerRoute: (_) => const ChatListSellerPage(),
        loginRoute: (_) => const LoginPage(),
        registerRoute: (_) => const regisPage(),
        homeAfterLoginRoute: (_) => const BerandaSesudahLogin(),
        profileRoute: (_) => const ProfilePage(),
        pesananSayaRoute: (_) => const PesananSayaPage(),
        cartRoute: (_) => const CartPage(),
        notificationRoute: (_) => const NotificationPage(),
      },
    );
  }

  String _getInitialRoute() {
    if (AppState().isLoggedIn) {
      if (AppState().userRole == 'admin' || AppState().userRole == 'owner') {
        return dashboardSellerRoute;
      }
      return homeAfterLoginRoute;
    }
    return homeRoute;
  }
}
