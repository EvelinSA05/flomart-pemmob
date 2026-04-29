import 'package:flutter/material.dart';
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

void main() {
  runApp(const MyApp());
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
      initialRoute: dashboardSellerRoute,
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
        chatDetailSellerRoute: (_) => const ChatDetailSellerPage(),
      },
    );
  }
}
