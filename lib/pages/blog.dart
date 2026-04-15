import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  static const Color backgroundColor = Color(0xFFF4F2ED);
  static const Color primaryGreen = Color(0xFF14824C);
  static const Color textColor = Color(0xFF181818);
  static const Color mutedText = Color(0xFF676767);
  static const Color lineColor = Color(0xFFD8D4CA);
  static const Color accentYellow = Color(0xFFE3B91A);
  static const Color chipBorder = Color(0xFFD3D0C8);

  // =========================
  // ASSET HEADER
  // =========================
  static const String headerLogoAsset = 'assets/Frame 4.png';
  static const String headerWhatsappAsset = 'assets/Vector-1.png';
  static const String headerShopAsset = 'assets/Vector (1).png';
  static const String headerNotificationAsset = 'assets/Notification.png';
  static const String headerCartAsset = 'assets/Shop Cart.png';
  static const String headerProfileAsset = 'assets/Ellipse 27.png';

  // =========================
  // ASSET BOTTOM NAV
  // =========================
  static const String navHomeAsset = 'assets/Vector (2).png';
  static const String navStoreAsset = 'assets/Vector (4).png';
  static const String navSellAsset = 'assets/Group.png';
  static const String navBlogAsset = 'assets/Vector (6).png';
  static const String navInfoAsset = 'assets/Vector (9).png';

  static const _heroArticle = _BlogArticle(
    image: 'assets/NEWS.jpg',
    title: 'Peningkatan Aktivitas UMKM',
    date: '12 Desember 2025',
    author: 'Daniel Ang',
    description:
        'UMKM lokal memanfaatkan FLOMART untuk menjual produk tanaman secara online dengan lebih mudah dan aman.',
  );

  static const List<_BlogArticle> _popularArticles = [
    _BlogArticle(
      image:
          'assets/Farmer harvest or inspect farm products quality and fresh vegetables _ Premium Photo.jpg',
      title: 'Peningkatan Aktivitas UMKM oleh FLOMART',
      date: '12 Desember 2025',
      author: 'Titania Ang',
    ),
    _BlogArticle(
      image:
          'assets/Female biotechnologist inspecting potted plants in plant nursery and writing notes into clipboard _ Free Photo.jpg',
      title: 'Strategi UMKM Tanaman Bertahan di Era Digital',
      date: '10 Desember 2025',
      author: 'Evelin Ang',
    ),
    _BlogArticle(
      image: 'assets/25 Urban Garden Ideas_ Green Solutions for Small___.jpg',
      title: 'Peran E-Commerce Hijau dalam Mendukung Petani Lokal',
      date: '05 Desember 2025',
      author: 'Fida Ang',
    ),
  ];

  static const List<_BlogArticle> _categories = [
    _BlogArticle(
      image: 'assets/Five mulches to use.jpg',
      title: 'Pemupukan Alami untuk Tanaman Lebih Sehat',
      date: '06 Desember 2025',
      author: 'Daniel Ang',
    ),
    _BlogArticle(
      image:
          'assets/Vegetable Gardening for Beginners_ A Complete Guide to Growing Your Own Fresh Vegetables.jpg',
      title: 'Tanaman Sayur Cepat Panen untuk Pemula',
      date: '05 Desember 2025',
      author: 'Tian Ang',
    ),
    _BlogArticle(
      image:
          'assets/Female biotechnologist inspecting potted plants in plant nursery and writing notes into clipboard _ Free Photo.jpg',
      title: 'Meningkatnya Minat Berkebun Pasca Pandemi',
      date: '05 Desember 2025',
      author: 'Titania Ang',
    ),
    _BlogArticle(
      image: 'assets/What You Should Know About The New US GMO Labeling Law.jpg',
      title: 'Mengenal Jenis Tanah yang Cocok untuk Tanaman Sayur',
      date: '04 Desember 2025',
      author: 'Evelin Ang',
    ),
    _BlogArticle(
      image: 'assets/tanah.jpg',
      title: 'Tanah Humus vs Tanah Liat: Mana yang Lebih Baik?',
      date: '04 Desember 2025',
      author: 'Fida Ang',
    ),
    _BlogArticle(
      image: 'assets/tanah lagi.jpg',
      title: 'Cara Mengetahui Kualitas Tanah Sebelum Menanam',
      date: '03 Desember 2025',
      author: 'Daniel Ang',
    ),
  ];

  static const List<String> _chips = [
    'All',
    'Lagi Trend',
    'Perawatan',
    'Jenis Tanah',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const Divider(height: 1, thickness: 1, color: lineColor),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Terbaru'),
                      const SizedBox(height: 14),
                      _buildFeaturedArticle(context),
                      const SizedBox(height: 22),
                      _buildSectionTitle('Artikel Populer'),
                      const SizedBox(height: 14),
                      ..._popularArticles.map(
                        (article) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildPopularArticleCard(article),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSearchAndCategorySection(),
                      const SizedBox(height: 14),
                      _buildCategoryGrid(),
                      const SizedBox(height: 18),
                      _buildPagination(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 64,
      titleSpacing: 16,
      title: _assetImage(
        headerLogoAsset,
        height: 24,
        fit: BoxFit.contain,
        fallback: const Text(
          'FLOMART',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerWhatsappAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerShopAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerNotificationAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerCartAsset),
        ),
        Padding(
  padding: const EdgeInsets.only(right: 10, left: 4),
  child: GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 32,
      height: 32,
      child: ClipOval(
        child: _assetImage(
          headerProfileAsset,
          fit: BoxFit.cover,
          fallback: const Icon(
            Icons.person_outline,
            color: Color(0xFFBEBEBE),
            size: 18,
          ),
        ),
      ),
    ),
  ),
),
      ],
    );
  }

  Widget _headerActionAsset(String path) {
    return IconButton(
      onPressed: () {},
      splashRadius: 20,
      icon: _assetImage(
        path,
        width: 21,
        height: 21,
        fit: BoxFit.contain,
        fallback: const Icon(
          Icons.crop_square,
          color: primaryGreen,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: textColor,
        height: 1.1,
      ),
    );
  }

  Widget _buildFeaturedArticle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(1, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _assetImage(
                _heroArticle.image,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.52,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _heroArticle.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _buildArticleMeta(
              _heroArticle,
              dateSize: 11.5,
              authorSize: 11.5,
            ),
            const SizedBox(height: 8),
            Text(
              _heroArticle.description ?? '',
              style: const TextStyle(
                fontSize: 11.5,
                color: mutedText,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Baca Lebih Lanjut',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleMeta(
    _BlogArticle article, {
    double dateSize = 10,
    double authorSize = 10,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        Text(
          article.date,
          style: TextStyle(
            fontSize: dateSize,
            color: textColor,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Container(
          width: 1,
          height: 12,
          color: const Color(0xFF99A399),
        ),
        Text(
          article.author,
          style: TextStyle(
            fontSize: authorSize,
            color: primaryGreen,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularArticleCard(_BlogArticle article) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _assetImage(
                article.image,
                width: 88,
                height: 72,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildArticleMeta(article),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cari Berdasarkan Kategori',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primaryGreen, width: 1.5),
          ),
          child: const TextField(
            style: TextStyle(fontSize: 11.5),
            decoration: InputDecoration(
              hintText: 'Ketik Pencarianmu',
              hintStyle: TextStyle(
                fontSize: 11,
                color: Color(0xFF9AA19A),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: primaryGreen,
                size: 18,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 9),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final bool active = index == 0;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: active ? primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: active ? null : Border.all(color: chipBorder),
                ),
                child: Center(
                  child: Text(
                    _chips[index],
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : textColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        mainAxisExtent: 174,
      ),
      itemBuilder: (context, index) {
        final item = _categories[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x20000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _assetImage(
                    item.image,
                    width: double.infinity,
                    height: 84,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.2,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 9.2,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 1,
                      height: 10,
                      margin: const EdgeInsets.only(right: 5),
                      color: const Color(0xFF99A399),
                    ),
                    Expanded(
                      child: Text(
                        item.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.2,
                          color: primaryGreen,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    const int activePage = 1;
    const List<int> pages = [1, 2, 3];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.chevron_left_rounded, size: 36, color: Colors.black),
        const SizedBox(width: 10),
        ...pages.map((page) {
          final bool active = page == activePage;

          return Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: active ? accentYellow : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$page',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        const Icon(Icons.chevron_right_rounded, size: 36, color: Colors.black),
      ],
    );
  }

  Widget _assetImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? fallback,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: fallback ??
                Container(
                  width: width,
                  height: height,
                  color: const Color(0xFFEAE7E0),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
          ),
        );
      },
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  static const Color _bgColor = Color(0xFFF6F5F2);
  static const Color _green = Color(0xFF14824C);
  static const Color _black = Color(0xFF181818);

  static const String navHomeAsset = 'assets/nav_home.png';
  static const String navStoreAsset = 'assets/nav_toko.png';
  static const String navSellAsset = 'assets/nav_mulai_berjualan.png';
  static const String navBlogAsset = 'assets/nav_blog.png';
  static const String navInfoAsset = 'assets/nav_tentang_kami.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: const BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _BottomAssetNavItem(
            assetPath: navHomeAsset,
            label: 'Beranda',
            active: false,
            fallbackIcon: Icons.home,
          ),
          _BottomAssetNavItem(
            assetPath: navStoreAsset,
            label: 'Toko',
            active: false,
            fallbackIcon: Icons.sell_outlined,
          ),
          _BottomAssetNavItem(
            assetPath: navSellAsset,
            label: 'Mulai\nBerjualan',
            active: false,
            fallbackIcon: Icons.storefront_outlined,
          ),
          _BottomAssetNavItem(
            assetPath: navBlogAsset,
            label: 'Blog',
            active: true,
            fallbackIcon: Icons.article_outlined,
          ),
          _BottomAssetNavItem(
            assetPath: navInfoAsset,
            label: 'Tentang Kami',
            active: false,
            fallbackIcon: Icons.info_outline,
          ),
        ],
      ),
    );
  }
}

class _BottomAssetNavItem extends StatelessWidget {
  const _BottomAssetNavItem({
    required this.assetPath,
    required this.label,
    required this.active,
    required this.fallbackIcon,
  });

  final String assetPath;
  final String label;
  final bool active;
  final IconData fallbackIcon;

  static const Color _green = Color(0xFF14824C);
  static const Color _black = Color(0xFF181818);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Icon(
                fallbackIcon,
                size: 27,
                color: active ? _green : _black,
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.1,
              color: active ? _green : _black,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogArticle {
  const _BlogArticle({
    required this.image,
    required this.title,
    required this.date,
    required this.author,
    this.description,
  });

  final String image;
  final String title;
  final String date;
  final String author;
  final String? description;
}