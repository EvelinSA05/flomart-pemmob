import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'blog.dart';
import 'beranda.dart';

 void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseGreen = Color(0xFF178246);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FloMart',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
        colorScheme: ColorScheme.fromSeed(
          seedColor: baseGreen,
          primary: baseGreen,
          surface: const Color(0xFFF8F7F3),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF294233)),
          titleMedium: TextStyle(
            color: Color(0xFF1E2D24),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavPadding = kIsWeb ? 12.0 : 10.0;

    final products = <Product>[
      const Product(
        name: 'Benih Selada',
        price: 'Rp10.000',
        rating: 4.8,
        image: 'assets/Rectangle 315.png',
      ),
      const Product(
        name: 'Benih Cabai',
        price: 'Rp12.000',
        rating: 4.5,
        image: 'assets/Rectangle 315 (1).png',
      ),
      const Product(
        name: 'Benih Strawberry',
        price: 'Rp15.000',
        rating: 4.7,
        image: 'assets/Rectangle 315 (2).png',
      ),
      const Product(
        name: 'Benih Bunga Daisy',
        price: 'Rp18.000',
        rating: 4.3,
        image: 'assets/Rectangle 315 (3).png',
      ),
      const Product(
        name: 'Benih Bunga Rose',
        price: 'Rp18.000',
        rating: 4.7,
        image: 'assets/Rectangle 315 (4).png',
      ),
      const Product(
        name: 'Benih Padi',
        price: 'Rp25.000',
        rating: 5.0,
        image: 'assets/Rectangle 315 (5).png',
      ),
      const Product(
        name: 'Benih Jagung',
        price: 'Rp25.000',
        rating: 4.6,
        image: 'assets/Rectangle 315 (6).png',
      ),
      const Product(
        name: 'Benih Nanas',
        price: 'Rp16.000',
        rating: 4.7,
        image: 'assets/Rectangle 315 (7).png',
      ),
      const Product(
        name: 'Benih Kubis',
        price: 'Rp20.000',
        rating: 4.9,
        image: 'assets/Rectangle 315 (8).png',
      ),
    ];

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(10, 0, 10, bottomNavPadding),
        child: const SafeArea(
          top: false,
          child: _BottomNavSection(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _HeaderSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/Rectangle 14 10.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _FilterAndSearchRow(),
                    const SizedBox(height: 10),
                    const _FilterPanel(),
                    const SizedBox(height: 12),
                    _ProductGrid(products: products),
                    const SizedBox(height: 18),
                    const _PaginationBar(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset('assets/Frame 4.png', height: 34),
                  ),
                ),
                const _HeaderIcon(asset: 'assets/Instagram.png'),
                const SizedBox(width: 10),
                const _HeaderIcon(asset: 'assets/ri_whatsapp-fill.png'),
                const SizedBox(width: 10),
                const _HeaderIcon(asset: 'assets/Notification.png'),
                const SizedBox(width: 10),
                const _HeaderIcon(asset: 'assets/Vector.png'),
                const SizedBox(width: 10),
                const _HeaderIcon(asset: 'assets/Ellipse 27.png', withBadge: true),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFE3DED3)),
            const SizedBox(height: 10),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF25382D),
                fontWeight: FontWeight.w600,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HeaderNavText(
                    label: 'Beranda',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    ),
                  ),
                  const _ActiveTab(label: 'Toko'),
                  const Text('Mulai Jualan'),
                  _HeaderNavText(
                    label: 'Blog',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    ),
                  ),
                  const Text('Tentang Kami'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterAndSearchRow extends StatelessWidget {
  const _FilterAndSearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/flowbite_filter-solid.png', width: 18, height: 18),
        const SizedBox(width: 6),
        const Text(
          'Filters',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF3D5347),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF19804B), width: 1.4),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Image.asset('assets/mdi_search.png', width: 16, height: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Ketik Pencarianmu',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFA2A99D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7B947F), width: 1),
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FilterColumn(
                  title: 'Jenis Benih',
                  items: ['Benih Sayur', 'Benih Buah', 'Benih Pangan', 'Benih Herbal', 'Benih Tanaman Hias'],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FilterColumn(
                  title: 'Jenis Tanah',
                  items: ['Aluvial', 'Andosol', 'Gambut', 'Latosol', 'Pasir', 'Humus'],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FilterColumn(
                  title: 'Kondisi Tanaman',
                  items: ['Musim Hujan', 'Musim Panas', 'Dataran Rendah', 'Dataran Tinggi'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Batas Harga',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: Color(0xFF2E4136),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _PriceField(hint: 'Harga Awal'),
                    const SizedBox(height: 6),
                    const _PriceField(hint: 'Harga Akhir'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 92,
                      height: 30,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF0BF00),
                          foregroundColor: const Color(0xFF3A3214),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _RatingColumn(),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (context, index) => _ProductCard(product: products[index]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9650),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/Star 4.png', width: 10, height: 10),
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
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF4C5F54),
              ),
            ),
            const SizedBox(height: 2),
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
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0BF00),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Image.asset('assets/Shop Cart.png', width: 14, height: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PagePill(label: '1', active: true),
        const SizedBox(width: 16),
        _PagePill(label: '2'),
        const SizedBox(width: 16),
        _PagePill(label: '3'),
        const SizedBox(width: 16),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFF1F2C24)),
      ],
    );
  }
}

class _BottomNavSection extends StatelessWidget {
  const _BottomNavSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            asset: 'assets/Vector (2).png',
            label: 'Beranda',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
          ),
          const _BottomNavItem(
            asset: 'assets/Vector (3).png',
            label: 'Toko',
            active: true,
          ),
          const _BottomNavItem(
            asset: 'assets/healthicons_market-stall.png',
            label: 'Mulai Berjualan',
          ),
          _BottomNavItem(
            asset: 'assets/Vector (4).png',
            label: 'Blog',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
          ),
          const _BottomNavItem(
            asset: 'assets/Vector (5).png',
            label: 'Tentang Kami',
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.asset, this.withBadge = false});

  final String asset;
  final bool withBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(asset, width: 18, height: 18),
        if (withBadge)
          Positioned(
            top: -2,
            right: -1,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFF0BF00),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF222C24),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 22,
          height: 2,
          color: const Color(0xFFF0BF00),
        ),
      ],
    );
  }
}

class _HeaderNavText extends StatelessWidget {
  const _HeaderNavText({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: Text(label));
  }
}

class _FilterColumn extends StatelessWidget {
  const _FilterColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: Color(0xFF2E4136),
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF6E8B79)),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF5E7265),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD6D1C7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        hint,
        style: const TextStyle(
          fontSize: 8,
          color: Color(0xFFA7AA9D),
        ),
      ),
    );
  }
}

class _RatingColumn extends StatelessWidget {
  const _RatingColumn();

  @override
  Widget build(BuildContext context) {
    const ratings = [5.0, 4.5, 4.0, 3.0, 1.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Penilaian',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: Color(0xFF2E4136),
          ),
        ),
        const SizedBox(height: 8),
        ...ratings.map(
          (rating) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF6E8B79)),
                  ),
                ),
                const SizedBox(width: 6),
                ...List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.star_rounded,
                      size: 10,
                      color: index < rating.floor()
                          ? const Color(0xFFF0BF00)
                          : const Color(0xFFD9D6CF),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF5E7265),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PagePill extends StatelessWidget {
  const _PagePill({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF0BF00) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: active ? const Color(0xFF2B2A26) : const Color(0xFF24322A),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.asset,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String asset;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF148242) : const Color(0xFF1E2D24);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: active
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF178246),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(asset),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.asset(asset, color: const Color(0xFF178246)),
                  ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 58,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: color,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  const Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.image,
  });

  final String name;
  final String price;
  final double rating;
  final String image;
}
