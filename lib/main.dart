import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'pages/beranda.dart';
import 'pages/blog.dart';
import 'pages/mulai_jualan.dart';
import 'pages/tentang_kami.dart';
import 'pages/toko.dart';

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
      initialRoute: homeRoute,
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
