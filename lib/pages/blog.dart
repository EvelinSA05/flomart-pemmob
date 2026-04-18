import 'package:flutter/material.dart';

import '../widgets/flomart_bottom_nav.dart';
import '../widgets/flomart_header.dart';
import './blog_detail.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();

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
  static const String headerLogoAsset = 'assets/img/system/LogoFlomart.png';
  static const String headerWhatsappAsset = 'assets/img/system/logoChat.png';
  static const String headerShopAsset = 'assets/img/system/logoKeranjang.png';
  static const String headerNotificationAsset =
      'assets/img/system/logoNotif.png';
  static const String headerCartAsset = 'assets/img/system/logPesanan.png';
  static const String headerProfileAsset = 'assets/img/system/logoProfile.png';

  // =========================
  // ASSET BOTTOM NAV
  // =========================
  static const String navHomeAsset = 'assets/img/system/toko.png';
  static const String navStoreAsset = 'assets/img/system/logoKeranjang.png';
  static const String navSellAsset = 'assets/img/system/logoChat.png';
  static const String navBlogAsset = 'assets/img/system/logoNotif.png';
  static const String navInfoAsset = 'assets/img/system/logoProfile.png';

  static const _heroArticle = _BlogArticle(
    image: 'assets/img/konten_blog/fotoMulaiJualan1.png',
    title: 'Peningkatan Aktivitas UMKM',
    date: '12 Desember 2025',
    author: 'Daniel Ang',
    category: 'All',
    description:
        'UMKM lokal memanfaatkan FLOMART untuk menjual produk tanaman secara online dengan lebih mudah dan aman.',
  );

  static const List<_BlogArticle> _popularArticles = [
    _BlogArticle(
      image: 'assets/img/konten_blog/fotoMulaiJualan1.png',
      title: 'Peningkatan Aktivitas UMKM oleh FLOMART',
      date: '12 Desember 2025',
      author: 'Titania Ang',
      category: 'All',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten13.jpg',
      title: 'Strategi UMKM Tanaman Bertahan di Era Digital',
      date: '10 Desember 2025',
      author: 'Evelin Ang',
      category: 'All',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten12.jpg',
      title: 'Peran E-Commerce Hijau dalam Mendukung Petani Lokal',
      date: '05 Desember 2025',
      author: 'Fida Ang',
      category: 'All',
    ),
  ];

  static const List<_BlogArticle> _categories = [
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten6.jpg',
      title: 'Pemupukan Alami untuk Tanaman Lebih Sehat',
      date: '06 Desember 2025',
      author: 'Daniel Ang',
      category: 'Perawatan',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten5.jpg',
      title: 'Tanaman Sayur Cepat Panen untuk Pemula',
      date: '05 Desember 2025',
      author: 'Tian Ang',
      category: 'Perawatan',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten4.jpg',
      title: 'Meningkatnya Minat Berkebun Pasca Pandemi',
      date: '05 Desember 2025',
      author: 'Titania Ang',
      category: 'Lagi Trend',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten3.jpg',
      title: 'Mengenal Jenis Tanah yang Cocok untuk Tanaman Sayur',
      date: '04 Desember 2025',
      author: 'Evelin Ang',
      category: 'Jenis Tanah',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten2.jpg',
      title: 'Tanah Humus vs Tanah Liat: Mana yang Lebih Baik?',
      date: '04 Desember 2025',
      author: 'Fida Ang',
      category: 'Jenis Tanah',
    ),
    _BlogArticle(
      image: 'assets/img/konten_blog/Konten1.jpg',
      title: 'Cara Mengetahui Kualitas Tanah Sebelum Menanam',
      date: '03 Desember 2025',
      author: 'Daniel Ang',
      category: 'Jenis Tanah',
    ),
  ];

  static const List<String> _chips = [
    'All',
    'Lagi Trend',
    'Perawatan',
    'Jenis Tanah',
  ];
}

class _BlogPageState extends State<BlogPage> {
  int _selectedChipIndex = 0;
  int _currentPage = 0;
  static const int _itemsPerPage = 3;

  void _openArticleDetail(_BlogArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlogDetailPage(
          title: article.title,
          image: article.image,
          author: article.author,
          date: article.date,
          summary:
              article.description ??
              'Artikel ini membahas tips praktis seputar pertanian dan UMKM hijau bersama FLOMART.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BlogPage.backgroundColor,
      appBar: const FlomartHeader(),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.blog),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const Divider(height: 1, thickness: 1, color: BlogPage.lineColor),
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
                      ...BlogPage._popularArticles.map(
                        (article) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildPopularArticleCard(article),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSearchAndCategorySection(
                        _selectedChipIndex,
                        (index) => setState(() {
                          _selectedChipIndex = index;
                          _currentPage = 0;
                        }),
                      ),
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


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: BlogPage.textColor,
        height: 1.1,
      ),
    );
  }

  Widget _buildFeaturedArticle(BuildContext context) {
    return GestureDetector(
      onTap: () => _openArticleDetail(BlogPage._heroArticle),
      child: Container(
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
                BlogPage._heroArticle.image,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.52,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              BlogPage._heroArticle.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: BlogPage.textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _buildArticleMeta(BlogPage._heroArticle, dateSize: 11.5, authorSize: 11.5),
            const SizedBox(height: 8),
            Text(
              BlogPage._heroArticle.description ?? '',
              style: const TextStyle(
                fontSize: 11.5,
                color: BlogPage.mutedText,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Baca Lebih Lanjut',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: BlogPage.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    ));
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
            color: BlogPage.textColor,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Container(width: 1, height: 12, color: const Color(0xFF99A399)),
        Text(
          article.author,
          style: TextStyle(
            fontSize: authorSize,
            color: BlogPage.primaryGreen,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularArticleCard(_BlogArticle article) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openArticleDetail(article),
      child: Container(
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
                child: _assetImage(article.image, width: 88, height: 72),
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
                        color: BlogPage.textColor,
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
      ),
    );
  }

  Widget _buildCategoryArticleCard(_BlogArticle item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openArticleDetail(item),
      child: Container(
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
                    color: BlogPage.textColor,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.date,
                style: const TextStyle(
                  fontSize: 9.2,
                  color: BlogPage.textColor,
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
                        color: BlogPage.primaryGreen,
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
      ),
    );
  }

  Widget _buildSearchAndCategorySection(
    int selectedIndex,
    ValueChanged<int> onChipTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cari Berdasarkan Kategori',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: BlogPage.textColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: BlogPage.primaryGreen, width: 1.5),
          ),
          child: const TextField(
            style: TextStyle(fontSize: 11.5),
            decoration: InputDecoration(
              hintText: 'Ketik Pencarianmu',
              hintStyle: TextStyle(fontSize: 11, color: Color(0xFF9AA19A)),
              prefixIcon: Icon(Icons.search, color: BlogPage.primaryGreen, size: 18),
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
            itemCount: BlogPage._chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final bool active = index == selectedIndex;

              return GestureDetector(
                onTap: () => onChipTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: active ? BlogPage.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: active ? null : Border.all(color: BlogPage.chipBorder),
                  ),
                  child: Center(
                    child: Text(
                      BlogPage._chips[index],
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : BlogPage.textColor,
                      ),
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

  List<_BlogArticle> _filteredCategoryItems() {
    if (_selectedChipIndex == 0) {
      return BlogPage._categories;
    }

    final selectedCategory = BlogPage._chips[_selectedChipIndex];
    return BlogPage._categories
        .where((article) => article.category == selectedCategory)
        .toList();
  }

  List<_BlogArticle> _pagedCategoryItems() {
    final filtered = _filteredCategoryItems();
    final start = _currentPage * _itemsPerPage;
    return filtered.skip(start).take(_itemsPerPage).toList();
  }

  int get _pageCount {
    final filtered = _filteredCategoryItems();
    final pageCount = (filtered.length / _itemsPerPage).ceil();
    return pageCount < 1 ? 1 : pageCount;
  }

  Widget _buildCategoryGrid() {
    final filteredCategories = _pagedCategoryItems();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        mainAxisExtent: 174,
      ),
      itemBuilder: (context, index) {
        final item = filteredCategories[index];
        return _buildCategoryArticleCard(item);
      },
    );
  }

  Widget _buildPagination() {
    final pageCount = _pageCount;
    final pages = List<int>.generate(pageCount, (index) => index + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _currentPage > 0
              ? () => setState(() {
                    _currentPage -= 1;
                  })
              : null,
          child: Icon(
            Icons.chevron_left_rounded,
            size: 36,
            color: _currentPage > 0 ? Colors.black : Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 10),
        ...pages.map((page) {
          final bool active = page - 1 == _currentPage;

          return GestureDetector(
            onTap: () => setState(() {
              _currentPage = page - 1;
            }),
            child: Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: active ? BlogPage.accentYellow : Colors.transparent,
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
            ),
          );
        }),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _currentPage < pageCount - 1
              ? () => setState(() {
                    _currentPage += 1;
                  })
              : null,
          child: Icon(
            Icons.chevron_right_rounded,
            size: 36,
            color: _currentPage < pageCount - 1 ? Colors.black : Colors.grey.shade400,
          ),
        ),
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
            child:
                fallback ??
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

  static const String navHomeAsset = 'assets/img/system/toko.png';
  static const String navStoreAsset = 'assets/img/system/logoKeranjang.png';
  static const String navSellAsset = 'assets/img/system/logoChat.png';
  static const String navBlogAsset = 'assets/img/system/logoNotif.png';
  static const String navInfoAsset = 'assets/img/system/logoProfile.png';

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
    required this.category,
    this.description,
  });

  final String image;
  final String title;
  final String date;
  final String author;
  final String category;
  final String? description;
}
