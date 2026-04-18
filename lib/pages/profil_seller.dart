import 'package:flutter/material.dart';

import '../models/product_model.dart';
import 'detail_produk.dart';

class ProfilSellerPage extends StatefulWidget {
  const ProfilSellerPage({super.key});

  @override
  State<ProfilSellerPage> createState() => _ProfilSellerPageState();
}

class _ProfilSellerPageState extends State<ProfilSellerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Product> _products = const [
    Product(
      name: 'Benih Kubis',
      price: 'Rp10.000',
      rating: 4.8,
      image: 'assets/img/produk/kiwi.jpg',
    ),
    Product(
      name: 'Benih Strawberry',
      price: 'Rp15.000',
      rating: 4.6,
      image: 'assets/img/produk/strawberry.png',
    ),
    Product(
      name: 'Benih Bawang Merah',
      price: 'Rp8.000',
      rating: 4.5,
      image: 'assets/img/produk/cabe.jpg', // dummy
    ),
    Product(
      name: 'Benih Sawi Hijau',
      price: 'Rp12.000',
      rating: 4.5,
      image: 'assets/img/produk/Wheat_Seeds.jpg', // dummy
    ),
    Product(
      name: 'Benih Terong',
      price: 'Rp15.000',
      rating: 4.6,
      image: 'assets/img/produk/jagung.jpg', // dummy
    ),
    Product(
      name: 'Benih Rosemary',
      price: 'Rp10.000',
      rating: 4.8,
      image: 'assets/img/produk/bunga_miracle.jpg', // dummy
    ),
    Product(
      name: 'Benih Ubi Ungu',
      price: 'Rp10.000',
      rating: 4.7,
      image: 'assets/img/produk/padi.jpg', // dummy
    ),
    Product(
      name: 'Benih Kentang',
      price: 'Rp12.000',
      rating: 4.9,
      image: 'assets/img/produk/nanas_box.png', // dummy
    ),
    Product(
      name: 'Benih Anggur Ungu',
      price: 'Rp18.000',
      rating: 4.8,
      image: 'assets/img/produk/strawberry.png', // dummy
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/img/system/logoFlomart.png',
              height: 24,
              errorBuilder: (_, __, ___) => const Text(
                'FLOMART',
                style: TextStyle(
                  color: Color(0xFF14824C),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Profile (Background + Info + Tabs)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Image/Color
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/system/BannerBg.png'),
                    fit: BoxFit.cover,
                  ),
                  color: Color(0xFFEAF5EB), // fallback color
                ),
              ),
              // Search Bar overlay
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF14824C)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari di Toko ini',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              // Profile Info
              Positioned(
                top: 70,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF14824C), width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/img/system/fotocewe_kelola.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kaka Petani',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '5.0 | 100RB Pengikut',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Positioned(
                top: 140,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF14824C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text(
                          'Ikuti',
                          style: TextStyle(
                            color: Color(0xFF14824C),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat, color: Color(0xFF14824C), size: 16),
                        label: const Text(
                          'Hubungi Toko',
                          style: TextStyle(
                            color: Color(0xFF14824C),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF14824C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFF0BF00),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: 'Halaman Utama'),
                Tab(text: 'Bibit'),
                Tab(text: 'Pupuk'),
                Tab(text: 'Tanaman'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: Container(
              color: const Color(0xFFF8F7F3),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHalamanUtama(),
                  const Center(child: Text('Bibit')),
                  const Center(child: Text('Pupuk')),
                  const Center(child: Text('Tanaman')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHalamanUtama() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/konten_blog/Konten14.png'), // placeholder
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(color: Colors.black.withOpacity(0.2)),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'BELI',
                        style: TextStyle(
                          color: Color(0xFF14824C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    right: 16,
                    child: Text(
                      'PENAWARAN\nTERBATAS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Section Title
          const Text(
            'KAMU MUNGKIN SUKA',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          
          // Products Grid
          GridView.builder(
            itemCount: _products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) => _ProductCard(product: _products[index]),
          ),
          
          const SizedBox(height: 24),
          
          // Pagination Indicator (Static placeholder matching design)
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF0BF00),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Reusing the Product Card design from toko.dart
class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A192F22),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3EF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.cover, // Changed to cover for uniform grid items
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFEAE7E0),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6, // Moved to right based on some designs, but let's check
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9650),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 10,
                              color: Color(0xFFF0BF00),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xFF4C5F54), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF534A30),
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0BF00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/img/system/logoKeranjangPutih.png',
                        width: 12,
                        height: 12,
                        errorBuilder: (_, __, ___) => const Icon(Icons.shopping_cart, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
