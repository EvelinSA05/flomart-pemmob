import 'package:flutter/material.dart';

class KeuanganSellerPage extends StatefulWidget {
  const KeuanganSellerPage({super.key});

  @override
  State<KeuanganSellerPage> createState() => _KeuanganSellerPageState();
}

class _KeuanganSellerPageState extends State<KeuanganSellerPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  final List<Map<String, dynamic>> _belumCairOrders = [
    {
      'product': 'Benih Kubis',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'date': '25/12/2025',
      'status': 'Dikirim',
      'amount': 'Rp 90.000',
      'image': 'assets/img/produk/kubis.jpg',
    },
  ];

  final List<Map<String, dynamic>> _sudahCairOrders = [
    {
      'product': 'Benih Ubi Ungu',
      'brand': 'Vida Verda',
      'season': 'Semua Musim',
      'date': '15/12/2025',
      'status': 'Selesai',
      'amount': 'Rp 60.000',
      'image': 'assets/img/produk/padi.jpg',
    },
    {
      'product': 'Benih Jagung',
      'brand': 'Vida Verda',
      'season': 'Semua Musim',
      'date': '10/12/2025',
      'status': 'Selesai',
      'amount': 'Rp 60.000',
      'image': 'assets/img/produk/jagung.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildInformasiPenghasilan(),
          ),
          SliverToBoxAdapter(
            child: _buildPencairanBank(),
          ),
          const SliverToBoxAdapter(
            child: Divider(thickness: 4, color: Color(0xFFF6F6F6), height: 32),
          ),
          SliverToBoxAdapter(
            child: _buildRincianHeader(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFFF0BF00),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Saldo belum cair'),
                  Tab(text: 'Saldo sudah cair'),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(_belumCairOrders),
                _buildOrderList(_sudahCairOrders),
              ],
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
          const Text('Keuangan', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
          _buildDrawerItem(Icons.grid_view_rounded, 'Produk', onTap: () {
            Navigator.pushReplacementNamed(context, '/produk-saya');
          }),
          _buildDrawerItem(Icons.inventory_2_rounded, 'Pesanan & Pengiriman', onTap: () {
            Navigator.pushReplacementNamed(context, '/pesanan-seller');
          }),
          _buildDrawerItem(Icons.bar_chart_rounded, 'Data', onTap: () {
            Navigator.pushReplacementNamed(context, '/data-seller');
          }),
          _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan', isSelected: true),
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

  Widget _buildInformasiPenghasilan() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.list, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 0), // spacing not needed if we want list icon attached to title? Wait, design has list icon above the title
            ],
          ),
          const SizedBox(height: 16),
          const Text('Informasi Penghasilan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const Text('Saldo Penjualan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          const Text('Rp 3.500.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo belum cair', style: TextStyle(color: Color(0xFF903520), fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const Text('Rp 90.000', style: TextStyle(color: Color(0xFF903520), fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    const Text('Bulan ini', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const Text('Rp 3.000.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              Container(width: 1, height: 100, color: Colors.grey.shade300),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo sudah cair', style: TextStyle(color: Color(0xFF14824C), fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const Text('Rp 120.000', style: TextStyle(color: Color(0xFF14824C), fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    const Text('Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                    const Text('Rp 3.000.0000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPencairanBank() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showBankSelectionDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rekening Bank saya', style: TextStyle(fontSize: 12)),
                      Text('****3468', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    children: const [
                      Text('Pilih Bank Anda', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Pilih bank untuk pencairan saldo penjualan anda', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRincianHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Rincian Penghasilan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Container(
            width: 180,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF14824C)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF14824C),
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ketik Pencarianmu',
                      hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF14824C),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Pesanan', style: TextStyle(color: Colors.white, fontSize: 12))),
                Expanded(flex: 3, child: Text('Perkiraan\nwaktu\npencairan\ndana', style: TextStyle(color: Colors.white, fontSize: 12))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(color: Colors.white, fontSize: 12))),
                Expanded(flex: 2, child: Text('Jumlah Dana\nDilepaskan', style: TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final o = orders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(o['image'], width: 24, height: 24, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width:24, height:24, color:Colors.grey.shade300)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o['product'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                Text(o['brand'], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                Text(o['season'], style: const TextStyle(color: Color(0xFF14824C), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 3, child: Text(o['date'], style: const TextStyle(fontSize: 11))),
                    Expanded(flex: 2, child: Text(o['status'], style: const TextStyle(fontSize: 11))),
                    Expanded(flex: 2, child: Text(o['amount'], style: const TextStyle(fontSize: 11))),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showBankSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pilih Bank anda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF14824C)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 14, left: 16),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF14824C),
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                        ),
                        child: const Icon(Icons.search, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildBankItem('BNI', 'Agung Prasetya', 'BNI ****3468', 'assets/img/bank/bni.png'),
                      _buildBankItem('BCA', 'Agung Prasetya', 'BCA ****5005', 'assets/img/bank/bca.png'),
                      _buildBankItem('Mandiri', 'Agung Prasetya', 'Mandiri ****9090', 'assets/img/bank/mandiri.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankItem(String bankName, String holder, String details, String imagePath) {
    return ListTile(
      onTap: () {
        Navigator.pop(context); // close bank dialog
        _showSuccessDialog();
      },
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(imagePath, width: 40, height: 40, errorBuilder: (_,__,___) => Container(width:40, height:40, color:Colors.grey.shade300, alignment:Alignment.center, child:Text(bankName, style:const TextStyle(fontSize: 10)))),
      title: Text(holder, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      subtitle: Text(details, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF14824C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 24),
                const Text('Berhasil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text(
                  'Saldo berhasil di pindahkan\nke rekening anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
