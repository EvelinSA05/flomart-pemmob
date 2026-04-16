import 'package:flutter/material.dart';

import '../widgets/flomart_bottom_nav.dart';
import '../widgets/flomart_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color _green = Color(0xFF13824B);
  static const Color _dark = Color(0xFF151515);
  static const Color _yellow = Color(0xFFE2BE00);
  static const Color _lightBg = Color(0xFFF4F1F1);
  static const Color _chipGray = Color(0xFFE8E8E8);

  static const List<String> _menus = [
    // 'Beranda',
    // 'Toko',
    // 'Mulai Jualan',
    // 'Blog',
    // 'Tentang Kami',
  ];

  static const List<String> _chips = [
    'Benih Sayuran',
    'Benih Buah',
    'Benih Bunga',
    'Benih Herbal',
  ];

  static const List<_CategoryItem> _categories = [
    _CategoryItem(
      title: 'Benih Sayuran',
      total: '12K + Produk',
      accent: _green,
      imagePath: 'assets/img/produk/buahnaga.webp',
    ),
    _CategoryItem(
      title: 'Benih Buah',
      total: '9K + Produk',
      accent: _yellow,
      imagePath: 'assets/img/produk/anggur_ungu.png',
    ),
    _CategoryItem(
      title: 'Benih Pangan',
      total: '15K + Produk',
      accent: Color(0xFFABB217),
      imagePath: 'assets/img/produk/anggur_hijau.jpg',
    ),
    _CategoryItem(
      title: 'Benih Herbal',
      total: '5K + Produk',
      accent: Color(0xFF7E9C1E),
      imagePath: 'assets/img/produk/bunga_matahari.gif',
    ),
  ];

  static const List<_ProductItem> _recommendedProducts = [
    _ProductItem(
      name: 'Benih Kubis',
      price: 'Rp10.000',
      rating: '4.8',
      imagePath: 'assets/img/produk/buahnaga.webp',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
    _ProductItem(
      name: 'Benih Kelengkeng',
      price: 'Rp18.000',
      rating: '4.9',
      imagePath: 'assets/img/produk/kiwi.jpg',
      tag: 'Benih Buah, Musim Hujan, Gambut',
    ),
    _ProductItem(
      name: 'Benih Sawi Hijau',
      price: 'Rp8.000',
      rating: '4.6',
      imagePath: 'assets/img/produk/jagung.jpg',
      tag: 'Benih Sayur, Musim Hujan, Pasir',
    ),
    _ProductItem(
      name: 'Benih Jagung',
      price: 'Rp25.000',
      rating: '4.8',
      imagePath: 'assets/img/produk/padi.jpg',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
  ];

  static const List<_ProductItem> _bestProducts = [
    _ProductItem(
      name: 'Benih Kubis',
      price: 'Rp10.000',
      rating: '4.8',
      imagePath: 'assets/img/produk/buahnaga.webp',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
    _ProductItem(
      name: 'Benih Sawi Hijau',
      price: 'Rp8.000',
      rating: '4.6',
      imagePath: 'assets/img/produk/jagung.jpg',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
    _ProductItem(
      name: 'Benih Labu',
      price: 'Rp14.000',
      rating: '4.5',
      imagePath: 'assets/img/produk/bunga_matahari.gif',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
    _ProductItem(
      name: 'Benih Tomat',
      price: 'Rp12.000',
      rating: '4.5',
      imagePath: 'assets/img/produk/salak.webp',
      tag: 'Benih Sayur, Musim Hujan, Gambut',
    ),
  ];

  static const List<_BenefitItem> _benefits = [
    _BenefitItem(
      title: 'Benih Tepat Guna',
      description: 'Bibit tanaman sesuai kebutuhan untuk hasil tanam yang baik',
      iconPath: 'assets/img/system/Instagram.png',
    ),
    _BenefitItem(
      title: 'Pengiriman Aman',
      description: 'Pengiriman aman menjaga kualitas tanaman',
      iconPath: 'assets/img/system/logoChat.png',
    ),
    _BenefitItem(
      title: 'Kualitas Terjamin',
      description: 'Produk terjamin berkualitas dan terpercaya',
      iconPath: 'assets/img/system/safety.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FlomartHeader(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 18),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHeroBanner(),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSectionHeader(
              'Belanja Berdasarkan Kategori',
              'Lihat Semua Item',
            ),
          ),
          const SizedBox(height: 10),
          _buildCategoryList(),
          const SizedBox(height: 12),
          _buildPromoRow(),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSectionHeader(
              'Rekomendasi Benih Berkualitas',
              'Lihat Semua',
            ),
          ),
          const SizedBox(height: 10),
          _buildProductList(_recommendedProducts),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Center(
              child: Text(
                'Kita Menyediakan kamu\nBenih Yang Terbaik',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: _dark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildBenefits(),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSectionHeader('Pilihan Benih Terbaik', 'Lihat Semua'),
          ),
          const SizedBox(height: 8),
          _buildChips(),
          const SizedBox(height: 10),
          _buildProductList(_bestProducts),
          const SizedBox(height: 120),
        ],
      ),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.home),
    );
  }

  Widget _buildHeroBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/img/konten_blog/Konten12.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.black.withOpacity(0.18),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 22,
              right: 140,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Belanja Pintar\nuntuk Masa Depan\nyang Lebih Hijau',
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0E6F42),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Temukan produk tanaman ramah lingkungan dari penjual terpercaya dengan proses belanja yang mudah dan aman.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _yellow,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'Belanja',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 10,
              child: Image.asset(
                'assets/img/produk/anggur_ungu.png',
                width: 145,
                height: 195,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _dark,
                height: 1.2,
              ),
            ),
          ),
          Text(
            action,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 16.0;
        const spacing = 10.0;

        final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
        final itemWidth = (availableWidth - (spacing * 2)) / 3;

        return SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: spacing),
            itemBuilder: (context, index) {
              return SizedBox(
                width: itemWidth,
                child: _CategoryCard(item: _categories[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPromoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Expanded(
            child: _PromoCard(
              title: 'Dari Bibit\nBerkualitas, Hasil\nPanen Maksimal',
              imagePath: 'assets/img/produk/anggur_ungu.png',
              accent: _green,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _PromoCard(
              title: 'Bibit Terjamin,\nDikirim Aman,\nTumbuh Optimal',
              imagePath: 'assets/img/produk/kaktus.jpg',
              accent: Color(0xFFB6C000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<_ProductItem> items) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _ProductCard(item: items[index]),
      ),
    );
  }

  Widget _buildBenefits() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _benefits
            .map(
              (item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _BenefitCard(item: item),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_chips.length, (index) {
          final isActive = index == 0;
          return Padding(
            padding: EdgeInsets.only(right: index == _chips.length - 1 ? 0 : 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? _green : _chipGray,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _chips[index],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF555555),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFooterBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 34,
          child: Image.asset(
            'assets/img/system/LogoFlomart.png',
            fit: BoxFit.fitHeight,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Marketplace tanamana\nramah lingkungan\nterpercaya',
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Colors.white.withOpacity(0.94),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Write Email',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB5B5B5)),
                ),
              ),
              Container(
                width: 38,
                height: 34,
                decoration: const BoxDecoration(
                  color: _yellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              link,
              style: TextStyle(
                fontSize: 11,
                height: 1.35,
                color: Colors.white.withOpacity(0.94),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final _CategoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Center(
                child: Image.asset(item.imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
            decoration: BoxDecoration(
              color: item.accent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.total,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.title,
    required this.imagePath,
    required this.accent,
  });

  final String title;
  final String imagePath;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_shipping_outlined, size: 8),
                  SizedBox(width: 3),
                  Text(
                    'Safe Delivery',
                    style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            right: 62,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 8.5,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Image.asset(imagePath, height: 56, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item});

  final _ProductItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(item.imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13824B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 9, color: Color(0xFFF2C94C)),
                      const SizedBox(width: 2),
                      Text(
                        item.rating,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            item.tag,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 6,
              color: Color(0xFF13824B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF151515),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.price,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF151515),
                  ),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2BE00),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.shopping_cart_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.item});

  final _BenefitItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF13824B),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            item.iconPath,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF151515),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.description,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 8,
            height: 1.25,
            color: Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF13824B),
      unselectedItemColor: const Color(0xFF7A7A7A),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      elevation: 10,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded, size: 20),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_rounded, size: 20),
          label: 'Toko',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business_rounded, size: 20),
          label: 'Jual',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_rounded, size: 20),
          label: 'Blog',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outline_rounded, size: 20),
          label: 'Tentang',
        ),
      ],
    );
  }
}

class _FooterSocial extends StatelessWidget {
  const _FooterSocial();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Ikuti Kami',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 14),
        _SocialRow(
          iconPath: 'assets/img/system/Instagram.png',
          label: '@flomart.Id',
        ),
        SizedBox(height: 10),
        _SocialRow(
          iconPath: 'assets/img/system/facebook.png',
          label: 'FLOMART',
        ),
        SizedBox(height: 10),
        _SocialRow(iconPath: 'assets/img/system/X.png', label: '@flowmart_id'),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.iconPath, required this.label});

  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconPath, width: 16, height: 16, fit: BoxFit.contain),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.94),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem {
  const _CategoryItem({
    required this.title,
    required this.total,
    required this.accent,
    required this.imagePath,
  });

  final String title;
  final String total;
  final Color accent;
  final String imagePath;
}

class _ProductItem {
  const _ProductItem({
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.tag,
  });

  final String name;
  final String price;
  final String rating;
  final String imagePath;
  final String tag;
}

class _BenefitItem {
  const _BenefitItem({
    required this.title,
    required this.description,
    required this.iconPath,
  });

  final String title;
  final String description;
  final String iconPath;
}
