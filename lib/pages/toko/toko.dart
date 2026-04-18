import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../models/product_model.dart';
import '../../widgets/flomart_bottom_nav.dart';
import '../../widgets/flomart_header.dart';
import '../blog/blog.dart';
import '../beranda/beranda.dart';
import 'detail_produk.dart';
import '../jualan/mulai_jualan.dart';
import '../info/tentang_kami.dart';

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
      initialRoute: shopRoute,
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

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static const int _itemsPerPage = 3;
  int _currentPage = 0;

  final List<Product> _products = const [
    Product(
      name: 'Benih Selada',
      price: 'Rp10.000',
      rating: 4.8,
      image: 'assets/img/produk/Wheat_Seeds.jpg',
    ),
    Product(
      name: 'Benih Cabai',
      price: 'Rp12.000',
      rating: 4.5,
      image: 'assets/img/produk/cabe.jpg',
    ),
    Product(
      name: 'Benih Strawberry',
      price: 'Rp15.000',
      rating: 4.7,
      image: 'assets/img/produk/strawberry.png',
    ),
    Product(
      name: 'Benih Bunga Daisy',
      price: 'Rp18.000',
      rating: 4.3,
      image: 'assets/img/produk/bunga_miracle.jpg',
    ),
    Product(
      name: 'Benih Bunga Rose',
      price: 'Rp18.000',
      rating: 4.7,
      image: 'assets/img/produk/bunga_kamboja.jpg',
    ),
    Product(
      name: 'Benih Padi',
      price: 'Rp25.000',
      rating: 5.0,
      image: 'assets/img/produk/padi.jpg',
    ),
    Product(
      name: 'Benih Jagung',
      price: 'Rp25.000',
      rating: 4.6,
      image: 'assets/img/produk/jagung.jpg',
    ),
    Product(
      name: 'Benih Nanas',
      price: 'Rp16.000',
      rating: 4.7,
      image: 'assets/img/produk/nanas_box.png',
    ),
    Product(
      name: 'Benih Kubis',
      price: 'Rp20.000',
      rating: 4.9,
      image: 'assets/img/produk/kiwi.jpg',
    ),
    Product(
      name: 'Benih Tomat',
      price: 'Rp15.000',
      rating: 4.6,
      image: 'assets/img/produk/tomat.png',
    ),
  ];

  int get _pageCount => (_products.length / _itemsPerPage).ceil();

  List<Product> get _pagedProducts {
    final start = _currentPage * _itemsPerPage;
    return _products.skip(start).take(_itemsPerPage).toList();
  }

  void _setPage(int page) {
    setState(() {
      _currentPage = page.clamp(0, _pageCount - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlomartHeader(),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.shop),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/img/konten_blog/Konten14.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _FilterAndSearchRow(),
                    const SizedBox(height: 10),
                    const _FilterPanel(),
                    const SizedBox(height: 12),
                    _ProductGrid(products: _pagedProducts),
                    const SizedBox(height: 18),
                    _PaginationBar(
                      currentPage: _currentPage,
                      pageCount: _pageCount,
                      onPageChanged: _setPage,
                    ),
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

class _FilterAndSearchRow extends StatelessWidget {
  const _FilterAndSearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.filter_list, size: 18, color: Color(0xFF3D5347)),
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
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF19804B), width: 1.4),
            ),
            child: TextField(
              style: const TextStyle(fontSize: 12, color: Color(0xFF3D5347)),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF3D5347),
                ),
                hintText: 'Ketik Pencarianmu',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFA2A99D)),
                border: InputBorder.none,
              ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FilterColumn(
                  title: 'Jenis Benih',
                  items: [
                    'Benih Sayur',
                    'Benih Buah',
                    'Benih Pangan',
                    'Benih Herbal',
                    'Benih Tanaman Hias',
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterColumn(
                  title: 'Jenis Tanah',
                  items: [
                    'Aluvial',
                    'Andosol',
                    'Gambut',
                    'Latosol',
                    'Pasir',
                    'Humus',
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterColumn(
                  title: 'Kondisi Tanaman',
                  items: [
                    'Musim Hujan',
                    'Musim Panas',
                    'Dataran Rendah',
                    'Dataran Tinggi',
                  ],
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
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: _RatingColumn()),
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
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
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
                style: const TextStyle(fontSize: 9, color: Color(0xFF4C5F54)),
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
                      child: Image.asset(
                        'assets/img/system/logoKeranjangPutih.png',
                        width: 14,
                        height: 14,
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

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
  });

  final int currentPage;
  final int pageCount;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < pageCount; index++) ...[
          _PagePill(
            label: '${index + 1}',
            active: currentPage == index,
            onTap: () => onPageChanged(index),
          ),
          if (index < pageCount - 1) const SizedBox(width: 16),
        ],
        const SizedBox(width: 16),
        GestureDetector(
          onTap: currentPage < pageCount - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
          child: Icon(
            Icons.chevron_right_rounded,
            color: currentPage < pageCount - 1
                ? const Color(0xFF1F2C24)
                : const Color(0xFFB8B8B8),
          ),
        ),
      ],
    );
  }
}

class _FilterColumn extends StatefulWidget {
  const _FilterColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  State<_FilterColumn> createState() => _FilterColumnState();
}

class _FilterColumnState extends State<_FilterColumn> {
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: Color(0xFF2E4136),
          ),
        ),
        const SizedBox(height: 8),
        ...widget.items.map(
          (item) {
            final selected = _selectedItems.contains(item);
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedItems.remove(item);
                    } else {
                      _selectedItems.add(item);
                    }
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF14824C) : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: selected ? const Color(0xFF14824C) : const Color(0xFF6E8B79),
                          width: 1.4,
                        ),
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 9,
                          color: selected ? const Color(0xFF14824C) : const Color(0xFF5E7265),
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
    return SizedBox(
      width: 92,
      height: 30,
      child: TextField(
        style: const TextStyle(fontSize: 10, color: Color(0xFF3D5347)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 10, color: Color(0xFFA7AA9D)),
          filled: true,
          fillColor: const Color(0xFFF6F3EF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFD6D1C7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFD6D1C7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF19804B)),
          ),
        ),
        keyboardType: TextInputType.number,
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
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
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
                const SizedBox(width: 6),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 9, color: Color(0xFF5E7265)),
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
  const _PagePill({
    required this.label,
    this.active = false,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF0BF00) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: active ? const Color(0xFFF0BF00) : const Color(0xFF24322A),
            width: 1.3,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF2B2A26) : const Color(0xFF24322A),
          ),
        ),
      ),
    );
  }
}
