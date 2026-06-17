import 'package:flutter/material.dart';
import '../../services/app_state.dart';
import 'cart_page.dart';
import 'notifikasi.dart';
import '../auth/login.dart';
import '../chat/chat_page.dart';
import '../profile/pesanan_saya.dart';
import '../profile/profile.dart';



class DetailProdukPage extends StatefulWidget {
  const DetailProdukPage({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.tag,
    required this.shortDesc,
    required this.longDesc,
    required this.images,
  });

  final String name;
  final String price;
  final String rating;
  final String imagePath;
  final String tag;
  final String shortDesc;
  final String longDesc;
  final List<String> images;

  static const Color _green = Color(0xFF13824B);
  static const Color _dark = Color(0xFF151515);
  static const Color _yellow = Color(0xFFE2BE00);
  static const Color _bg = Color(0xFFF3F1F1);

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  final List<String> _sizes = ['20g', '50g', '100g'];
  String _selectedSize = '20g';
  int _qty = 1;
  bool _isFavorite = false;
  int _currentReviewPage = 1;

  String _getCalculatedPrice() {
    final basePriceStr = widget.price.replaceAll(RegExp(r'[^0-9]'), '');
    int basePrice = 0;
    if (basePriceStr.isNotEmpty) {
      basePrice = int.parse(basePriceStr);
    }
    
    int calculatedPrice = basePrice;
    if (_selectedSize == '50g') {
      calculatedPrice = (basePrice * 2.5).toInt();
    } else if (_selectedSize == '100g') {
      calculatedPrice = basePrice * 5;
    }
    
    return 'Rp$calculatedPrice';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F1F1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildBreadcrumb(context),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
                    const SizedBox(height: 12),
                    _buildThumbnail(),
                    const SizedBox(height: 20),
                    _buildInfo(),
                    const SizedBox(height: 20),
                    _buildDescription(),
                    const SizedBox(height: 20),
                    _buildReview(),
                    const SizedBox(height: 18),
                    _buildPagination(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 24,
          ),
          const SizedBox(width: 16),
          Image.asset(
            'assets/img/system/logoFlomart.png',
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Text(
              'FLOMART',
              style: TextStyle(
                color: Color(0xFF14824C),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _headerIconButton(
              context,
              'assets/img/system/logoChat.png',
              Icons.chat_bubble_outline,
              onTap: () {
                if (!AppState().isLoggedIn) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: ListenableBuilder(
              listenable: AppState(),
              builder: (context, child) {
                final count = AppState().cartItems.length;
                return _headerIconButton(
                  context,
                  'assets/img/system/logoKeranjang.png',
                  Icons.shopping_cart_outlined,
                  badgeCount: count,
                  onTap: () {
                    if (!AppState().isLoggedIn) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _headerIconButton(
              context,
              'assets/img/system/logoNotif.png',
              Icons.notifications_outlined,
              onTap: () {
                if (!AppState().isLoggedIn) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _headerIconButton(
              context,
              'assets/img/system/logPesanan.png',
              Icons.shopping_bag_outlined,
              onTap: () {
                if (!AppState().isLoggedIn) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                  return;
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PesananSayaPage()));
              },
            ),
          ),
          // Profile icon
          ListenableBuilder(
            listenable: AppState(),
            builder: (context, child) {
              final isLoggedIn = AppState().isLoggedIn;
              return Padding(
                padding: const EdgeInsets.only(right: 2, left: 4),
                child: GestureDetector(
                  onTap: () {
                    if (isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    }
                  },
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: ClipOval(
                      child: Image.asset(
                        isLoggedIn
                            ? 'assets/img/system/pengguna_login.png'
                            : 'assets/img/system/logoProfile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.person_outline,
                          color: Color(0xFFBEBEBE),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _headerIconButton(
    BuildContext context,
    String assetPath,
    IconData fallbackIcon, {
    int badgeCount = 0,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 20,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            assetPath,
            width: 21,
            height: 21,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Icon(
              fallbackIcon,
              color: const Color(0xFF14824C),
              size: 20,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// BREADCRUMB
  Widget _buildBreadcrumb(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Text(
            "Beranda",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, size: 18),
        const SizedBox(width: 6),
        const Text(
          "Detail Produk",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

  /// GAMBAR UTAMA
  Widget _buildImage() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}

  /// THUMBNAIL
  Widget _buildThumbnail() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: List.generate(widget.images.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == widget.images.length - 1 ? 0 : 10),
            child: _thumbItem(widget.images[index]),
          ),
        );
      }),
    ),
  );
}

Widget _thumbItem(String path) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: AssetImage(path),
        fit: BoxFit.cover,
      ),
    ),
  );
}

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFCEEFDE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }


  /// INFO PRODUK
  Widget _buildInfo() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// NAMA PRODUK
        /// NAMA PRODUK DAN FAVORIT (STATE DASAR UAS)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF151515),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// RATING
        Row(
          children: [
            Row(
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  size: 14,
                  color: Color(0xFFE2BE00),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              "50 Reviews",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF13824B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// HARGA
        Text(
          _getCalculatedPrice(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF151515),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          widget.shortDesc,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Color(0xFF151515),
          ),
        ),

        const SizedBox(height: 10),

        /// TAG / KATEGORI
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.tag.split(',').map((e) => _chip(e.trim())).toList(),
        ),


        const Text(
          "Ukuran",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF151515),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            _SizeChip(
              label: '20g',
              isSelected: _selectedSize == '20g',
              onTap: () {
                setState(() {
                  _selectedSize = '20g';
                });
              },
            ),
            const SizedBox(width: 10),
            _SizeChip(
              label: '50g',
              isSelected: _selectedSize == '50g',
              onTap: () {
                setState(() {
                  _selectedSize = '50g';
                });
              },
            ),
            const SizedBox(width: 10),
            _SizeChip(
              label: '100g',
              isSelected: _selectedSize == '100g',
              onTap: () {
                setState(() {
                  _selectedSize = '100g';
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// QTY + BUTTON
        Row(
          children: [
            _QtyButton(
              icon: Icons.remove,
              onTap: () {
                setState(() {
                  if (_qty > 0) _qty--;
                });
              },
            ),
            const SizedBox(width: 6),
            _QtyValue(value: _qty.toString()),
            const SizedBox(width: 6),
            _QtyButton(
              icon: Icons.add,
              onTap: () {
                setState(() {
                  _qty++;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: 95,
              child: _ActionButton(
                label: 'Add Cart',
                background: DetailProdukPage._yellow,
                foreground: Colors.black,
                onTap: () {
                  if (!AppState().isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                    return;
                  }
                  if (_qty > 0) {
                    AppState().addToCart(CartItem(
                      name: widget.name,
                      price: _getCalculatedPrice(),
                      imagePath: widget.imagePath,
                      size: _selectedSize,
                      quantity: _qty,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.name} ditambahkan ke keranjang'),
                        backgroundColor: DetailProdukPage._green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih jumlah terlebih dahulu'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 95,
              child: _ActionButton(
                label: 'Buy Now',
                background: DetailProdukPage._yellow,
                foreground: Colors.black,
                onTap: () {
                  if (!AppState().isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                    return;
                  }
                  if (_qty > 0) {
                    AppState().addToCart(CartItem(
                      name: widget.name,
                      price: _getCalculatedPrice(),
                      imagePath: widget.imagePath,
                      size: _selectedSize,
                      quantity: _qty,
                    ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih jumlah terlebih dahulu'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/img/system/FotoJualan.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Agung Prasetyo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF151515),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Alamat Toko',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _StoreAction(
              imagePath: 'assets/img/system/logoChat.png',
              label: 'Hubungi Toko',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka chat dengan penjual...')),
                );
              },
            ),

            const SizedBox(width: 14),

            _StoreAction(
              imagePath: 'assets/img/system/toko.png',
              label: 'Kunjungi Toko',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka halaman toko penjual...')),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 18),
        const Divider(color: Colors.black12, thickness: 1),
      ],
    ),
  );
}


  /// DESKRIPSI
  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Deskripsi Produk",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              widget.longDesc,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REVIEW
  Widget _buildReview() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Review Produk",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF151515),
            ),
          ),
          SizedBox(height: 16),

          _ReviewItem(
            imagePath: 'assets/img/konten_beranda/review1.jpg',
            name: 'Agung Prasetyo',
            date: '12/04-2025',
            review: 'Bagus sekali aku suka hebat banget !!',
            isFavorite: true,
          ),

          Divider(color: Colors.black26, thickness: 1),

          _ReviewItem(
            imagePath: 'assets/img/konten_beranda/review2.jpg',
            name: 'Agus Bagyo',
            date: '12/04-2025',
            review: 'Bibitnya sampai dengan aman !!',
            isFavorite: false,
          ),

          Divider(color: Colors.black26, thickness: 1),

          _ReviewItem(
            imagePath: 'assets/img/konten_beranda/review3.jpg',
            name: 'Marsha Arianti',
            date: '12/04-2025',
            review: 'Bibitnya datang tidak ada yang mati !!',
            isFavorite: false,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPagination() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_currentReviewPage > 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentReviewPage--;
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 18),
                child: Icon(Icons.chevron_left, size: 20),
              ),
            ),
          
          ...List.generate(3, (index) {
            int page = index + 1;
            bool isActive = _currentReviewPage == page;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentReviewPage = page;
                });
              },
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(right: 18),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE2BE00) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  page.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF151515),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    fontSize: isActive ? 12 : 13,
                  ),
                ),
              ),
            );
          }),
          
          GestureDetector(
            onTap: () {
              setState(() {
                if (_currentReviewPage < 3) _currentReviewPage++;
              });
            },
            child: const Icon(Icons.chevron_right, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 68,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF13824B)
              : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.black12
                : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : const Color(0xFF151515),
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _QtyValue extends StatelessWidget {
  const _QtyValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.background,
    required this.foreground,
    this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

class _StoreAction extends StatelessWidget {
  const _StoreAction({
    required this.imagePath,
    required this.label,
    this.onTap,
  });

  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 74,
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF151515),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatefulWidget {
  const _ReviewItem({
    required this.imagePath,
    required this.name,
    required this.date,
    required this.review,
    required this.isFavorite,
  });

  final String imagePath;
  final String name;
  final String date;
  final String review;
  final bool isFavorite;

  @override
  State<_ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<_ReviewItem> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(widget.imagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF151515),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: List.generate(
                    5,
                    (_) => const Padding(
                      padding: EdgeInsets.only(right: 1),
                      child: Icon(
                        Icons.star,
                        color: Color(0xFFE2BE00),
                        size: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.review,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: Color(0xFF151515),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFE91E63),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
