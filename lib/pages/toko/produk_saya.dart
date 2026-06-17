import '../../services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukSayaPage extends StatefulWidget {
  const ProdukSayaPage({super.key});

  @override
  State<ProdukSayaPage> createState() => _ProdukSayaPageState();
}

class _ProdukSayaPageState extends State<ProdukSayaPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _myProducts = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _applyFilters();
    });
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      
      setState(() {
        _allProducts = snapshot.docs.map<Map<String, dynamic>>((doc) {
          final data = doc.data();
          
          int stok = 25; // Default stok jika tidak ada
          if (data.containsKey('stok')) {
             stok = int.tryParse(data['stok'].toString()) ?? 25;
          }

          String imageUrl = data['image'] ?? 'assets/img/produk/15.png';

          return {
            'id_produk': data['id'] ?? doc.id,
            'name': data['name'] ?? 'Nama Produk',
            'brand': data['category'] ?? 'Kategori',
            'season': 'Semua Musim',
            'price': 'Rp${(double.tryParse(data['price'].toString()) ?? 0).toInt()}',
            'stock': stok,
            'sales': 0,
            'analysis': stok == 0 ? 'Stok Habis' : (stok <= 5 ? 'Stok Menipis' : 'Produk Masih Banyak'),
            'image': imageUrl,
          };
        }).toList();
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    String search = _searchController.text.toLowerCase();
    String kategori = _kategoriController.text.toLowerCase();
    int tabIndex = _tabController.index;

    setState(() {
      _myProducts = _allProducts.where((product) {
        bool matchSearch = product['name'].toString().toLowerCase().contains(search);
        bool matchKategori = kategori.isEmpty || product['brand'].toString().toLowerCase().contains(kategori);
        
        bool matchTab = true;
        if (tabIndex == 1) { // Habis
          matchTab = (product['stock'] as int) == 0;
        } else if (tabIndex == 2) { // Perlu Tindakan
          matchTab = (product['stock'] as int) > 0 && (product['stock'] as int) <= 5;
        }

        return matchSearch && matchKategori && matchTab;
      }).toList();
    });
  }

  Future<void> _deleteProduct(String id) async {
    try {
      // Cari produk berdasarkan field 'id' karena document id-nya bisa berbeda
      final snapshot = await FirebaseFirestore.instance.collection('products').where('id', isEqualTo: id).get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
        _fetchProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk tidak ditemukan', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      }
    } catch (e) {
      print('Error delete: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus produk', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
    }
  }

  void _confirmDeleteProduct(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _kategoriController.dispose();
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
            errorBuilder: (_, _, _) => const Text(
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
          if (AppState().userRole != 'admin') ...[
            if (AppState().userRole != 'admin') ...[
            _buildDrawerItem(Icons.bar_chart_rounded, 'Data', onTap: () {
              Navigator.pushReplacementNamed(context, '/data-seller');
            }),
            _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan', onTap: () {
              Navigator.pushReplacementNamed(context, '/keuangan-seller');
            }),
          ],
          ],
          _buildDrawerItem(Icons.settings, 'Pengaturan', onTap: () {
            Navigator.pushReplacementNamed(context, '/pengaturan-seller');
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout, 'Keluar', onTap: () {
            AppState().logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          })],
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
          if (AppState().userRole != 'owner')
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.pushNamed(context, '/tambah-produk');
                _fetchProducts();
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
                  controller: _searchController,
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
                  controller: _kategoriController,
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
            onPressed: _applyFilters,
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
          Text('${_myProducts.length} Produk', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF14824C))),
      );
    }

    if (_myProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Tidak ada produk.')),
      );
    }

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
              SizedBox(width: 32),
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
                          child: p['image'].startsWith('http') 
                            ? Image.network(p['image'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_,_,_) => Image.asset('assets/img/produk/15.png', width: 40, height: 40, fit: BoxFit.cover))
                            : Image.asset(p['image'], width: 40, height: 40, fit: BoxFit.cover),
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
                  if (AppState().userRole != 'owner')
                    SizedBox(
                      width: 32,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (p['id_produk'] != null) {
                            _confirmDeleteProduct(p['id_produk'].toString());
                          }
                        },
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



