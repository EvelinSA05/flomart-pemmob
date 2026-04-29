import 'package:flutter/material.dart';

class ProdukSayaPage extends StatefulWidget {
  const ProdukSayaPage({super.key});

  @override
  State<ProdukSayaPage> createState() => _ProdukSayaPageState();
}

class _ProdukSayaPageState extends State<ProdukSayaPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final List<Map<String, dynamic>> _myProducts = [
    {
      'name': 'Bibit Ubi Ungu',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'price': 'Rp12.000',
      'stock': 100,
      'sales': 0,
      'analysis': '10x Dikunjungi\nProduk Masih Banyak',
      'image': 'assets/img/produk/padi.jpg',
    },
    {
      'name': 'Bibit Kentang',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'price': 'Rp15.000',
      'stock': 150,
      'sales': 0,
      'analysis': '5x Dikunjungi\nProduk Masih Banyak',
      'image': 'assets/img/produk/kentang.png',
    },
    {
      'name': 'Bibit Kubis',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'price': 'Rp10.000',
      'stock': 200,
      'sales': 100,
      'analysis': '100x Dikunjungi\nPerlu dikirim\nProduk Masih Banyak',
      'image': 'assets/img/produk/kubis.jpg',
    },
    {
      'name': 'Bibit Labu',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'price': 'Rp18.000',
      'stock': 300,
      'sales': 0,
      'analysis': '20x Dikunjungi\nProduk Masih Banyak',
      'image': 'assets/img/produk/labu.png',
    },
    {
      'name': 'Bibit Mawar',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'price': 'Rp20.000',
      'stock': 0,
      'sales': 50,
      'analysis': '50x Dikunjungi\nStok Habis\nProduk Masih Banyak',
      'image': 'assets/img/produk/mawar.jpg',
    },
    {
      'name': 'Pupuk Organik',
      'brand': 'Vida Verda',
      'season': 'Semua Musim',
      'price': 'Rp8.000',
      'stock': 120,
      'sales': 0,
      'analysis': '29x Dikunjungi\nProduk Perlu di restok',
      'image': 'assets/img/produk/pupukOrganik.jpg',
    },
    {
      'name': 'Pupuk Kering',
      'brand': 'Vida Verda',
      'season': 'Semua Musim',
      'price': 'Rp8.500',
      'stock': 10,
      'sales': 30,
      'analysis': '30x Dikunjungi\nStok Menipis\nProduk Perlu di restok',
      'image': 'assets/img/produk/organik_kompos.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildSubHeader(),
          _buildTabBar(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterSection(),
                  _buildSummarySection(),
                  _buildProductTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/img/system/LogoFlomart.png',
            height: 24,
            errorBuilder: (_, __, ___) => const Text(
              'FLOMART',
              style: TextStyle(color: Color(0xFF14824C), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          const Text('Produk', style: TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/chat-list-seller'),
          icon: const Icon(Icons.chat_bubble, color: Color(0xFF14824C)),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.home, color: Color(0xFF14824C)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              alignment: Alignment.centerLeft,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.list, size: 32, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          _buildDrawerItem(Icons.store, 'Toko', onTap: () {
            Navigator.pushReplacementNamed(context, '/dashboard-seller');
          }),
          _buildDrawerItem(Icons.grid_view_rounded, 'Produk', isSelected: true),
          _buildDrawerItem(Icons.inventory_2_rounded, 'Pesanan & Pengiriman', onTap: () {
            Navigator.pushReplacementNamed(context, '/pesanan-seller');
          }),
          _buildDrawerItem(Icons.bar_chart_rounded, 'Data', onTap: () {
            Navigator.pushReplacementNamed(context, '/data-seller');
          }),
          _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan', onTap: () {
            Navigator.pushReplacementNamed(context, '/keuangan-seller');
          }),
          _buildDrawerItem(Icons.settings, 'Pengaturan', onTap: () {
            Navigator.pushReplacementNamed(context, '/pengaturan-seller');
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isSelected = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.black : Colors.grey,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.list, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              const Text('Produk Saya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/tambah-produk');
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Produk'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0BF00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFFF0BF00),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: const [
        Tab(text: 'Semua'),
        Tab(text: 'Habis'),
        Tab(text: 'Perlu Tindakan'),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama produk',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Kategori',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0BF00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text('7 Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 12),
          _buildChip('Perlu Dikirimkan'),
          const SizedBox(width: 8),
          _buildChip('Stok Menipis'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildProductTable() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          color: const Color(0xFF14824C),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: const [
              SizedBox(width: 40), // For checkbox space
              Expanded(flex: 3, child: Text('Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Harga', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(flex: 1, child: Text('Stok', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Perfoma', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('Analisis Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _myProducts.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final p = _myProducts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 40,
                    child: Checkbox(value: false, onChanged: null),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(p['image'], width: 40, height: 40, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                              Text(p['brand'], style: const TextStyle(color: Colors.grey, fontSize: 9)),
                              Text(p['season'], style: const TextStyle(color: Color(0xFF14824C), fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(p['price'], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12))),
                  Expanded(flex: 1, child: Text(p['stock'].toString(), style: const TextStyle(fontSize: 12))),
                  Expanded(flex: 2, child: Text('Penjualan ${p['sales']}', style: const TextStyle(fontSize: 12))),
                  Expanded(
                    flex: 2,
                    child: Text(
                      p['analysis'],
                      style: TextStyle(
                        fontSize: 9,
                        color: _getAnalysisColor(p['analysis']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getAnalysisColor(String text) {
    if (text.contains('Stok Habis') || text.contains('Stok Menipis')) {
      return Colors.red;
    }
    if (text.contains('Perlu dikirim')) {
      return const Color(0xFFF0BF00);
    }
    return Colors.green;
  }
}
