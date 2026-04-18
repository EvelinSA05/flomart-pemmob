import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../widgets/flomart_bottom_nav.dart';
import '../widgets/flomart_header.dart';
import 'profil_seller.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;
  final List<String> _sizes = ['20g', '50g', '100g'];
  final List<String> _detailImages = [
    'assets/img/konten_blog/Konten12.jpg',
    'assets/img/konten_blog/Konten13.jpg',
    'assets/img/konten_blog/Konten3.jpg',
  ];

  void _changeQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tags = widget.product.tags.isNotEmpty
        ? widget.product.tags
        : ['Gambut', 'Benih Sayur', 'Baik Musim Hujan'];

    return Scaffold(
      appBar: const FlomartHeader(),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.shop),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text('Toko', style: TextStyle(color: Color(0xFF7D7D7D))),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, size: 16, color: Color(0xFF7D7D7D)),
                  SizedBox(width: 6),
                  Text(
                    'Detail Produk',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 240,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _detailImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        _detailImages[index],
                        width: 90,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFF0BF00),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.product.rating.toStringAsFixed(1)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '50 Reviews',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7D7D7D)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.product.price,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E4136),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F3E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E4136),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Ukuran',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_sizes.length, (index) {
                  final selected = index == _selectedSizeIndex;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == _sizes.length - 1 ? 0 : 10,
                    ),
                    child: ChoiceChip(
                      label: Text(
                        _sizes[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF3D5347),
                        ),
                      ),
                      selected: selected,
                      selectedColor: const Color(0xFF14824C),
                      backgroundColor: const Color(0xFFF1F1EC),
                      onSelected: (_) =>
                          setState(() => _selectedSizeIndex = index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF19804B)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => _changeQuantity(-1),
                          icon: const Icon(Icons.remove, size: 18),
                          color: const Color(0xFF19804B),
                          splashRadius: 18,
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          onPressed: () => _changeQuantity(1),
                          icon: const Icon(Icons.add, size: 18),
                          color: const Color(0xFF19804B),
                          splashRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF0BF00),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      child: const Text('Add Cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF14824C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilSellerPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x12000000),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFEFF5EC),
                      child: Icon(Icons.person, color: Color(0xFF14824C)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Agung Prasetyo',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Alamat Toko',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7D7D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chat, color: Color(0xFF14824C)),
                      splashRadius: 24,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilSellerPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.storefront,
                        color: Color(0xFF14824C),
                      ),
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
              const Text(
                'Deskripsi Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.description.isNotEmpty
                    ? widget.product.description
                    : 'Benih ${widget.product.name} merupakan benih sayuran berkualitas premium yang dirancang untuk menghasilkan tanaman kubis dengan pertumbuhan yang optimal dan seragam. Cocok ditanam pada musim hujan dan menghasilkan kubis segar serta padat.',
                style: const TextStyle(height: 1.6, color: Color(0xFF4E5A49)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Review Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              ..._buildReviewCards(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _PageIndicator(active: true, label: '1'),
                  SizedBox(width: 10),
                  _PageIndicator(label: '2'),
                  SizedBox(width: 10),
                  _PageIndicator(label: '3'),
                  SizedBox(width: 10),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Color(0xFF1F2C24),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildReviewCards() {
    final reviews = [
      _ProductReview(
        name: 'Agung Prasetyo',
        message: 'Bagus sekali aku suka hebat banget !!',
      ),
      _ProductReview(
        name: 'Agus Bagyo',
        message: 'Bibitnya sampai dengan aman !!',
      ),
      _ProductReview(
        name: 'Marsha Arianti',
        message: 'Bibitnya datang tidak ada yang mati !!',
      ),
    ];
    return reviews
        .map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: review,
          ),
        )
        .toList();
  }
}

class _ProductReview extends StatefulWidget {
  const _ProductReview({required this.name, required this.message});

  final String name;
  final String message;

  @override
  State<_ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<_ProductReview> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFEFF5EC),
                child: Icon(Icons.person, color: Color(0xFF14824C)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.star, size: 14, color: Color(0xFFF0BF00)),
                        SizedBox(width: 2),
                        Icon(Icons.star, size: 14, color: Color(0xFFF0BF00)),
                        SizedBox(width: 2),
                        Icon(Icons.star, size: 14, color: Color(0xFFF0BF00)),
                        SizedBox(width: 2),
                        Icon(Icons.star, size: 14, color: Color(0xFFF0BF00)),
                        SizedBox(width: 2),
                        Icon(Icons.star, size: 14, color: Color(0xFFF0BF00)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '12/04/2025',
                style: TextStyle(fontSize: 10, color: Color(0xFF7D7D7D)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.message,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4E5A49)),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE3E1D8)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _liked = !_liked;
                });
              },
              icon: Icon(
                _liked ? Icons.favorite : Icons.favorite_border,
                color: _liked ? const Color(0xFFE63946) : const Color(0xFFD22B5D),
              ),
              splashRadius: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF0BF00) : const Color(0xFFE8E4D4),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : const Color(0xFF7D7D7D),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
