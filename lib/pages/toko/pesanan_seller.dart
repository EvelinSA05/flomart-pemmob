import '../profile/detail_pesanan.dart';
import '../../services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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
  final Map<String, Map<String, dynamic>> _jamOperasional = {
    'Senin': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Selasa': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Rabu': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Kamis': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Jumat': {'isOpen': true, 'start': '13:00', 'end': '20:00'},
    'Sabtu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Minggu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Libur Nasional': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
  };
  final Map<String, bool> _courierStates = {
    'Antareja Regular': true,
    'ID Express': true,
    'JNE Regular': true,
    'JNT Express': true,
  };

  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 6, vsync: this);
    _mainTabController.addListener(_applyFilters);
    _subTabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance.collection('orders').get();
      
      List<Map<String, dynamic>> tempOrders = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        
        List<dynamic> items = data['items'] ?? [];
        String itemName = 'Unknown Item';
        String imagePath = 'assets/img/produk/15.png';
        String qty = '1x';
        
        List<Map<String, dynamic>> parsedItems = [];
        if (items.isNotEmpty) {
          for (var item in items) {
            if (item is Map) {
              parsedItems.add(Map<String, dynamic>.from(item));
            } else if (item is String) {
              try {
                parsedItems.add(Map<String, dynamic>.from(json.decode(item)));
              } catch(e) {}
            }
          }
          if (items[0] is Map) {
             itemName = items[0]['nama_produk'] ?? itemName;
             qty = '${items[0]['qty'] ?? 1}x';
             if (items[0]['gambar'] != null) imagePath = items[0]['gambar'];
          } else if (items[0] is String) {
             try {
                final decoded = json.decode(items[0]);
                itemName = decoded['nama_produk'] ?? itemName;
                qty = '${decoded['qty'] ?? 1}x';
                if (decoded['gambar'] != null) imagePath = decoded['gambar'];
             } catch(e) {}
          }
        }

        double totalDouble = double.tryParse(data['total_harga'].toString()) ?? 0;
        String totalFormatted = 'Rp ${totalDouble.toInt()}';
        
        DateTime createdAt = DateTime.now();
        if (data['created_at'] != null) {
          createdAt = (data['created_at'] as Timestamp).toDate();
        }
        
        DateTime deadline = createdAt.add(const Duration(days: 1)); // Default deadline 1 day
        
        tempOrders.add({
          'id': doc.id,
          'product': itemName,
          'brand': 'Pesanan', 
          'season': 'Flomart',
          'qty': qty,
          'amount': totalFormatted,
          'courier': data['jasa_kirim'] ?? 'JNE Regular',
          'status': data['status'] ?? 'Belum Bayar',
          'payment': data['metode_pembayaran'] ?? 'Transfer',
          'created': DateFormat('dd/MM/yyyy').format(createdAt),
          'deadline': DateFormat('dd/MM/yyyy').format(deadline),
          'image': imagePath,
          'bukti_pembayaran': data['bukti_pembayaran'],
          'alasan_pengembalian': data['alasan_pengembalian'],
          'bukti_pengembalian': data['bukti_pengembalian'],
          'isSelected': false,
          'orderItems': parsedItems,
          '_rawDate': createdAt, // Keep raw date for sorting
        });
      }
      
      // Sort locally by descending date so newest orders are at top
      tempOrders.sort((a, b) => (b['_rawDate'] as DateTime).compareTo(a['_rawDate'] as DateTime));
      
      setState(() {
        _allOrders = tempOrders;
        _isLoading = false;
        _applyFilters();
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    int index = _mainTabController.index;
    setState(() {
      if (index == 0) {
        _orders = List.from(_allOrders);
      } else {
        String filterStatus = '';
        if (index == 1) {
          filterStatus = 'Belum Bayar';
        } else if (index == 2) filterStatus = 'Perlu Dikirim';
        else if (index == 3) filterStatus = 'Dikirim';
        else if (index == 4) filterStatus = 'Selesai';
        else if (index == 5) filterStatus = 'Pembatalan';
        
        _orders = _allOrders.where((o) {
          String s = o['status']?.toString().toLowerCase() ?? '';
          if (index == 2 && s == 'menunggu konfirmasi') return true;
          if (index == 5 && (s == 'menunggu pengembalian' || s == 'pengembalian ditolak' || s == 'pengembalian disetujui')) return true;
          return s == filterStatus.toLowerCase();
        }).toList();
      }
    });
  }

  void _showOrderActionDialog(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        String nextStatus = '';
        String actionText = '';
        String currentStatus = order['status'].toString().toLowerCase();
        
        if (currentStatus == 'menunggu konfirmasi') {
          nextStatus = 'dikirim';
          if (order['payment'].toString().toLowerCase() == 'cod') {
            actionText = 'Proses Pesanan COD';
          } else {
            actionText = 'Konfirmasi Pembayaran';
          }
        } else if (currentStatus == 'perlu dikirim') {
          nextStatus = 'dikirim';
          actionText = 'Kirim Pesanan';
        } else if (currentStatus == 'dikirim') {
          nextStatus = 'selesai';
          actionText = 'Selesaikan Pesanan';
        } else if (currentStatus == 'menunggu pengembalian') {
          actionText = 'Proses Pengembalian';
        } else {
          actionText = 'Tidak ada aksi (Status: ${order['status']})';
        }

        return AlertDialog(
          title: const Text('Detail & Update Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Pesanan: ${order['id']}'),
              const SizedBox(height: 8),
              if (order['payment'].toString().toLowerCase() != 'cod') ...[
                if (order['bukti_pembayaran'] != null && order['bukti_pembayaran'].toString().isNotEmpty) ...[
                  const Text('Bukti Transfer:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showBuktiDialog(order['bukti_pembayaran']);
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Lihat Bukti Bayar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  const Text('Bukti Transfer:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Belum ada bukti bayar yang diupload.', style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 12)),
                  const SizedBox(height: 16),
                ],
              ] else ...[
                const Text('Metode Pembayaran: COD (Cash on Delivery)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF14824C))),
                const SizedBox(height: 4),
                const Text('Tidak perlu bukti transfer, pembayaran dilakukan saat barang sampai.', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                const SizedBox(height: 16),
              ],
              if (order['alasan_pengembalian'] != null && order['alasan_pengembalian'].toString().isNotEmpty) ...[
                const Text('Pengajuan Pengembalian:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 4),
                Text('Alasan: ${order['alasan_pengembalian']}', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                if (order['bukti_pengembalian'] != null && order['bukti_pengembalian'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showBuktiDialog(order['bukti_pengembalian']);
                      },
                      icon: const Icon(Icons.broken_image),
                      label: const Text('Lihat Bukti Pengembalian'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
              Text('Status saat ini: ${order['status']}', style: const TextStyle(fontWeight: FontWeight.w500)),
              if (nextStatus.isNotEmpty && currentStatus != 'menunggu pengembalian') ...[
                const SizedBox(height: 8),
                Text('Apakah Anda ingin mengubah status menjadi "$nextStatus"?', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ] else if (currentStatus == 'menunggu pengembalian') ...[
                const SizedBox(height: 8),
                const Text('Tentukan apakah pengajuan ini akan disetujui atau ditolak.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(color: Colors.grey)),
            ),
            if (currentStatus == 'menunggu pengembalian') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order['id'], 'pengembalian ditolak');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Tolak', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order['id'], 'pengembalian disetujui');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Setujui', style: TextStyle(color: Colors.white)),
              ),
            ] else if (nextStatus.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(order['id'], nextStatus);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14824C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(actionText, style: const TextStyle(color: Colors.white)),
              ),
            ]
          ],
        );
      },
    );
  }

  void _showBuktiDialog(dynamic rawUrl) {
    String imageUrl = rawUrl?.toString() ?? '';
    if (imageUrl.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: buildProductImage(imageUrl,
                    fit: BoxFit.contain,
                    
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateOrderStatus(String id, String newStatus) async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('orders').doc(id).update({
        'status': newStatus.toLowerCase(),
      });
      
      int targetIndex = _mainTabController.index;
      String statusLower = newStatus.toLowerCase();
      if (statusLower == 'belum bayar') targetIndex = 1;
      else if (statusLower == 'perlu dikirim') targetIndex = 2;
      else if (statusLower == 'dikirim') targetIndex = 3;
      else if (statusLower == 'selesai') targetIndex = 4;
      else if (statusLower.contains('pengembalian')) targetIndex = 5;

      if (_mainTabController.index != targetIndex) {
        _mainTabController.animateTo(targetIndex);
      }

      await _fetchOrders(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status berhasil diubah menjadi $newStatus', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green));
    } catch (e) {
      print('Error update status: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah status', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
    }
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
            errorBuilder: (_, _, _) => const Text(
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

  Widget _buildOrderTable() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF14824C))),
      );
    }
    
    if (_orders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Tidak ada pesanan.')),
      );
    }

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
                    flex: 5,
                    child: Column(
                      children: [
                        if (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty)
                          ...(o['orderItems'] as List).map((item) {
                            final String itemName = item['nama_produk'] ?? 'Unknown Item';
                            final String qty = '${item['qty'] ?? 1}x';
                            final String itemPrice = item['harga'] != null ? 'Rp${item['harga'].toString().replaceAll('.0', '')}' : 'Rp 0';
                            final String imagePath = item['gambar'] ?? 'assets/img/produk/dummy.png';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
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
                                          child: imagePath.startsWith('http')
                                            ? Image.network(imagePath, width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,_,_) => Image.asset('assets/img/produk/15.png', width: 32, height: 32, fit: BoxFit.cover))
                                            : Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,_,_) => Image.asset('assets/img/produk/15.png', width: 32, height: 32, fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
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
                                        Text(qty, style: const TextStyle(fontSize: 12)),
                                        Text(itemPrice, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: o['image'].toString().startsWith('http') 
                                        ? Image.network(o['image'], width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,_,_) => Image.asset('assets/img/produk/15.png', width: 32, height: 32, fit: BoxFit.cover))
                                        : Image.asset(o['image'], width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,_,_) => Image.asset('assets/img/produk/15.png', width: 32, height: 32, fit: BoxFit.cover)),
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
                            ],
                          ),
                        // Overall total row
                        if (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Container()),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Total Pesanan:', style: TextStyle(fontSize: 9, color: Colors.grey)),
                                      Text(o['amount'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF14824C))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        const SizedBox(height: 4),
                        Builder(
                          builder: (context) {
                            String s = o['status']?.toString().toLowerCase() ?? '';
                            String btnText = 'Lihat Detail';
                            if (s == 'menunggu konfirmasi') {
                              if (o['payment'].toString().toLowerCase() == 'cod') {
                                btnText = 'Proses Pesanan COD';
                              } else {
                                btnText = 'Cek Bukti & Konfirmasi';
                              }
                            } else if (s == 'perlu dikirim') btnText = 'Kirim Pesanan';
                            else if (s == 'dikirim') btnText = 'Selesaikan Pesanan';
                            else if (s == 'menunggu pengembalian') btnText = 'Proses Pengembalian';
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (AppState().userRole != 'owner')
                                  SizedBox(
                                    height: 24,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (s == 'menunggu konfirmasi' || s == 'perlu dikirim' || s == 'dikirim' || s == 'menunggu pengembalian') {
                                          _showOrderActionDialog(o);
                                        } else {
                                          if (s == 'selesai' || s == 'pembatalan' || s.contains('ditolak') || s.contains('disetujui')) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => DetailPesananPage(
                                                title: 'Detail Pesanan',
                                                orderId: o['id'] ?? '',
                                                image: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['gambar'] ?? o['orderItems'][0]['image'] ?? 'assets/img/produk/15.png') : 'assets/img/produk/15.png',
                                                itemName: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['nama_produk'] ?? o['orderItems'][0]['name'] ?? 'Item') : 'Item',
                                                qty: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['qty']?.toString() ?? '1') : '1',
                                                price: o['amount'] ?? '',
                                                total: o['amount'] ?? '',
                                                status: o['status'] ?? '',
                                                showSuccessDialog: false,
                                                orderItems: ((o['orderItems'] ?? []) as List).map((i) => OrderItem(
                                                  name: i['nama_produk'] ?? i['name'] ?? '',
                                                  image: i['gambar'] ?? i['image'] ?? 'assets/img/produk/15.png',
                                                  size: i['size'] ?? 'Reguler',
                                                  quantity: int.tryParse(i['qty']?.toString() ?? '1') ?? 1,
                                                  price: double.tryParse((i['harga'] ?? i['price'])?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0.0,
                                                )).toList(),
                                                subtotal: double.tryParse((o['amount'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0,
                                                ongkir: 0.0,
                                                paymentMethod: o['payment'] ?? '',
                                                shippingMethod: o['courier'] ?? 'Reguler',
                                                recipientName: 'Pembeli',
                                              )),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Text(btnText, style: const TextStyle(fontSize: 10, color: Color(0xFFF0BF00), fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                if (AppState().userRole == 'owner')
                                  SizedBox(
                                    height: 24,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DetailPesananPage(
                                            title: 'Detail Pesanan',
                                            orderId: o['id'] ?? '',
                                            image: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['gambar'] ?? o['orderItems'][0]['image'] ?? 'assets/img/produk/15.png') : 'assets/img/produk/15.png',
                                            itemName: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['nama_produk'] ?? o['orderItems'][0]['name'] ?? 'Item') : 'Item',
                                            qty: (o['orderItems'] != null && (o['orderItems'] as List).isNotEmpty) ? (o['orderItems'][0]['qty']?.toString() ?? '1') : '1',
                                            price: o['amount'] ?? '',
                                            total: o['amount'] ?? '',
                                            status: o['status'] ?? '',
                                            showSuccessDialog: false,
                                            orderItems: ((o['orderItems'] ?? []) as List).map((i) => OrderItem(
                                              name: i['nama_produk'] ?? i['name'] ?? '',
                                              image: i['gambar'] ?? i['image'] ?? 'assets/img/produk/15.png',
                                              size: i['size'] ?? 'Reguler',
                                              quantity: int.tryParse(i['qty']?.toString() ?? '1') ?? 1,
                                              price: double.tryParse((i['harga'] ?? i['price'])?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0.0,
                                            )).toList(),
                                            subtotal: double.tryParse((o['amount'] ?? '').toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0,
                                            ongkir: 0.0,
                                            paymentMethod: o['payment'] ?? '',
                                            shippingMethod: o['courier'] ?? 'Reguler',
                                            recipientName: 'Pembeli',
                                          )),
                                        );
                                      },
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      child: const Text('Lihat Detail', style: TextStyle(fontSize: 10, color: Color(0xFFF0BF00), fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 4),
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
            ..._jamOperasional.keys.map((day) => _buildJamOperasionalRow(day)),
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
            activeThumbColor: Colors.white,
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









