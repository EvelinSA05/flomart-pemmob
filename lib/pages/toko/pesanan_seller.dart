import 'package:flutter/material.dart';

class PesananSellerPage extends StatefulWidget {
  const PesananSellerPage({super.key});

  @override
  State<PesananSellerPage> createState() => _PesananSellerPageState();
}

class _PesananSellerPageState extends State<PesananSellerPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _subTabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPengiriman = false;
  bool _isCodEnabled = true;
  bool _isEditJamOperasional = false;
  bool _isAllSelected = false;
  Map<String, Map<String, dynamic>> _jamOperasional = {
    'Senin': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Selasa': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Rabu': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Kamis': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Jumat': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Sabtu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Minggu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Libur Nasional': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
  };
  Map<String, bool> _courierStates = {
    'Antareja Regular': true,
    'ID Express': true,
    'JNE Regular': true,
    'JNT Express': true,
  };

  final List<Map<String, dynamic>> _orders = [
    {
      'product': 'Benih Kubis',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'qty': '1x',
      'amount': 'Rp 12.000',
      'courier': 'JNE Regular',
      'status': 'Perlu Dikirim',
      'payment': 'BNI',
      'created': '10/12/2025',
      'deadline': '11/12/2025',
      'image': 'assets/img/produk/kubis.jpg',
    },
    {
      'product': 'Benih Ubi Ungu',
      'brand': 'Vida Verda',
      'season': 'Semua Musim',
      'qty': '2x',
      'amount': 'Rp 16.000',
      'courier': 'JNT Express',
      'status': 'Belum Bayar',
      'payment': 'COD',
      'created': '10/12/2025',
      'deadline': '11/12/2025',
      'image': 'assets/img/produk/padi.jpg',
    },
    {
      'product': 'Benih Kentang',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'qty': '2x',
      'amount': 'Rp 20.000',
      'courier': 'JNE Regular',
      'status': 'Dikirim',
      'payment': 'BRI',
      'created': '10/12/2025',
      'deadline': '11/12/2025',
      'image': 'assets/img/produk/kentang.png',
    },
    {
      'product': 'Benih Wortel',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'qty': '6x',
      'amount': 'Rp 74.000',
      'courier': 'JNE Regular',
      'status': 'Selesai',
      'payment': 'BNI',
      'created': '07/12/2025',
      'deadline': '08/12/2025',
      'image': 'assets/img/produk/Wortel.png',
    },
    {
      'product': 'Benih Bawang',
      'brand': 'Vida Verda',
      'season': 'Musim Hujan',
      'qty': '2x',
      'amount': 'Rp 22.000',
      'courier': 'JNT Express',
      'status': 'Pembatalan',
      'payment': 'COD',
      'created': '05/12/2025',
      'deadline': '06/12/2025',
      'image': 'assets/img/produk/bawaMerah.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 6, vsync: this);
    _subTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _subTabController.dispose();
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
          _buildSubHeaderTabs(),
          _isPengiriman ? _buildPengirimanTabs() : _buildMainTabs(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: _isPengiriman
                ? TabBarView(
                    controller: _subTabController,
                    children: [
                      SingleChildScrollView(child: _buildPengirimanJasaKirimContent()),
                      SingleChildScrollView(child: _buildPengirimanJamOperasionalContent()),
                      SingleChildScrollView(child: _buildPengirimanAturPengirimanContent()),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildOrderTable(),
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
          const Expanded(
            child: Text(
              'Pesanan & Pengiriman', 
              style: TextStyle(color: Colors.black, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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

  Widget _buildSubHeaderTabs() {
    return Container(
      color: const Color(0xFFF8F7F3),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.list, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () => setState(() => _isPengiriman = false),
            child: Text(
              'Pesanan Saya', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: _isPengiriman ? FontWeight.normal : FontWeight.bold, 
                color: _isPengiriman ? Colors.grey : Colors.black
              )
            ),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () => setState(() => _isPengiriman = true),
            child: Text(
              'Pengiriman', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: _isPengiriman ? FontWeight.bold : FontWeight.normal,
                color: _isPengiriman ? Colors.black : Colors.grey
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTabs() {
    return TabBar(
      controller: _mainTabController,
      isScrollable: true,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFFF0BF00),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tabs: const [
        Tab(text: 'Semua'),
        Tab(text: 'Belum Bayar'),
        Tab(text: 'Perlu Dikirim'),
        Tab(text: 'Dikirim'),
        Tab(text: 'Selesai'),
        Tab(text: 'Pembatalan'),
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
          _buildDrawerItem(Icons.inventory_2_rounded, 'Pesanan & Pengiriman', isSelected: true),
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

  Widget _buildOrderTable() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          color: const Color(0xFF14824C),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Checkbox(
                  value: _isAllSelected,
                  onChanged: (val) {
                    setState(() {
                      _isAllSelected = val ?? false;
                      for (var o in _orders) {
                        o['isSelected'] = _isAllSelected;
                      }
                    });
                  },
                  activeColor: Colors.white,
                  checkColor: const Color(0xFF14824C),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              const Expanded(flex: 3, child: Text('Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const Expanded(flex: 2, child: Text('Jumlah\nBayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const Expanded(flex: 2, child: Text('Jasa\nKirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const Expanded(flex: 2, child: Text('Status&\nAksi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              const Expanded(flex: 2, child: Text('Waktu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _orders.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final o = _orders[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    child: Checkbox(
                      value: o['isSelected'] ?? false,
                      onChanged: (val) {
                        setState(() {
                          o['isSelected'] = val ?? false;
                          _isAllSelected = _orders.every((order) => order['isSelected'] == true);
                        });
                      },
                      activeColor: const Color(0xFF14824C),
                      checkColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(o['image'], width: 32, height: 32, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o['product'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                              Text(o['brand'], style: const TextStyle(color: Colors.grey, fontSize: 9)),
                              Text(o['season'], style: const TextStyle(color: Color(0xFF14824C), fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o['qty'], style: const TextStyle(fontSize: 12)),
                        Text(o['amount'], style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Text(o['courier'], style: const TextStyle(fontSize: 11))),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o['status'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        const Text('Rincian', style: TextStyle(color: Color(0xFFF0BF00), fontSize: 10)),
                        Text(o['payment'], style: const TextStyle(color: Color(0xFF14824C), fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Waktu Dibuat', style: TextStyle(color: Colors.grey, fontSize: 8)),
                        Text(o['created'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        const Text('Kirim Sebelum', style: TextStyle(color: Colors.grey, fontSize: 8)),
                        Text(o['deadline'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                      ],
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
  Widget _buildPengirimanTabs() {
    return TabBar(
      controller: _subTabController,
      isScrollable: true,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.black,
      indicatorWeight: 2.0,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tabs: const [
        Tab(text: 'Jasa Kirim'),
        Tab(text: 'Jam Operasional'),
        Tab(text: 'Atur Pengiriman'),
      ],
    );
  }

  Widget _buildPengirimanJasaKirimContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cek pengaturan jasa kirim tokomu dihalaman ini', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('Reguler (Cashless)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Layanan pengiriman dengan durasi pengiriman\n2-7 hari tergantung lokasi tujuan', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                _isCodEnabled = !_isCodEnabled;
              });
            },
            child: Container(
              color: const Color(0xFF14824C),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                    ),
                    child: _isCodEnabled ? const Icon(Icons.check, size: 14, color: Color(0xFF14824C)) : null,
                  ),
                  const SizedBox(width: 12),
                  const Text('COD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildCourierRow('Antareja Regular'),
                const Divider(height: 1),
                _buildCourierRow('ID Express'),
                const Divider(height: 1),
                _buildCourierRow('JNE Regular'),
                const Divider(height: 1),
                _buildCourierRow('JNT Express'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengirimanJamOperasionalContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jam Pickup oleh Kurir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (!_isEditJamOperasional)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditJamOperasional = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0BF00),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(60, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('Ubah', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (!_isEditJamOperasional)
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                  children: [
                    TextSpan(text: 'Atur preferensi jam pickup oleh Kurir untuk semua pengiriman '),
                    TextSpan(text: 'selain instant', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' disini agar Kurir tahu kapan bisa mengambil pesananmu. '),
                    TextSpan(text: 'Selengkapnya', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else
              const Text(
                'Atur jam pickup oleh Kurir agar Kurir mengetahui waktu yang tersedia untuk mengambil pesananamu. Waktu pengambilan pesanan yang sebenarnya dapat berubah sesuai dengan ketersediaan Kurir.',
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
            const SizedBox(height: 24),
            ..._jamOperasional.keys.map((day) => _buildJamOperasionalRow(day)).toList(),
            if (_isEditJamOperasional) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditJamOperasional = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF0BF00)),
                      foregroundColor: const Color(0xFFF0BF00),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('Kembali'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditJamOperasional = false;
                      });
                      _showSuccessDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0BF00),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildJamOperasionalRow(String day) {
    bool isOpen = _jamOperasional[day]!['isOpen'];
    String start = _jamOperasional[day]!['start'];
    String end = _jamOperasional[day]!['end'];

    if (!_isEditJamOperasional) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(day, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            ),
            Text(
              isOpen ? '$start-$end' : 'Tutup',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isOpen,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                    onChanged: (val) {
                      setState(() {
                        _jamOperasional[day]!['isOpen'] = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(day, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFFC3EDD3) : const Color(0xFFF09595),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(start, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFFC3EDD3) : const Color(0xFFF09595),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(end, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
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
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 8),
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
                const Text('Jam Pick Up oleh Kurir berhasil\ndi update', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourierRow(String name) {
    bool isEnabled = _courierStates[name] ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Switch(
            value: isEnabled,
            onChanged: (val) {
              setState(() {
                _courierStates[name] = val;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF14824C),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildPengirimanAturPengirimanContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAturPengirimanRow('No. Pesanan\nProduk', 'No. Pesanan'),
              _buildAturPengirimanRow('Nama Toko', 'Nama Toko'),
              _buildAturPengirimanRow('No. Resi', 'No. Resi'),
              _buildAturPengirimanRow('Jasa Kirim', 'Pilih Jasa Kirim', isDropdown: true),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('5 Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () {
                  _showAturPengirimanSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0BF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Atur Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildOrderTable(),
      ],
    );
  }

  Widget _buildAturPengirimanRow(String label, String hint, {bool isDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isDropdown
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(hint, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    )
                  : TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        contentPadding: const EdgeInsets.only(bottom: 16),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAturPengirimanSuccessDialog() {
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
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: 8),
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
                  'Produk berhasil di atur ke pengriman\nkirim ke ekpedisi sebelum jam kirim',
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
