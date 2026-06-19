import '../../services/app_state.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PengaturanSellerPage extends StatefulWidget {
  const PengaturanSellerPage({super.key});

  @override
  State<PengaturanSellerPage> createState() => _PengaturanSellerPageState();
}

class _PengaturanSellerPageState extends State<PengaturanSellerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool _isFormMode = false;
  bool _isSubTabAsisten = false;
  bool _isLoading = false;

  bool _isAutoReplyStandardEnabled = false;
  bool _isAutoReplyOfflineEnabled = false;
  bool _isEditJamAsisten = false;

  final Map<String, Map<String, dynamic>> _jamAsisten = {
    'Senin': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
    'Selasa': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
    'Rabu': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
    'Kamis': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
    'Jumat': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
    'Sabtu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Minggu': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
    'Libur Nasional': {'isOpen': false, 'start': '00:00', 'end': '00:00'},
  };

  Map<String, String>? _address = null;

  final _namaController = TextEditingController();
  final _tipeController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStoreData();
  }

  Future<void> _fetchStoreData() async {
    String? userId = AppState().userId;
    if (userId == null) return;

    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _address = {
            'nama': data['store_name'] ?? data['name'] ?? AppState().userName ?? 'Admin Flomart',
            'tipe': data['store_type'] ?? 'Toko',
            'telepon': data['store_phone'] ?? AppState().userEmail ?? 'Belum diatur',
            'alamat': data['address'] ?? AppState().userAddress ?? 'Belum ada alamat',
          };
        });
      } else {
        setState(() {
          _address = {
            'nama': AppState().userName ?? 'Admin Flomart',
            'tipe': 'Toko',
            'telepon': AppState().userEmail ?? 'Belum diatur',
            'alamat': AppState().userAddress ?? 'Belum ada alamat',
          };
        });
      }
    } catch (e) {
      print('Error fetching store data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tipeController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _openForm({bool isEdit = false}) {
    if (isEdit && _address != null) {
      _namaController.text = _address!['nama'] ?? '';
      _tipeController.text = _address!['tipe'] ?? '';
      _teleponController.text = _address!['telepon'] ?? '';
      _alamatController.text = _address!['alamat'] ?? '';
    } else {
      _namaController.clear();
      _tipeController.clear();
      _teleponController.clear();
      _alamatController.clear();
    }
    setState(() {
      _isFormMode = true;
    });
  }

  Future<void> _saveForm() async {
    String? userId = AppState().userId;
    if (userId == null) return;
    
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'store_name': _namaController.text,
        'store_type': _tipeController.text,
        'store_phone': _teleponController.text,
        'address': _alamatController.text,
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _address = {
            'nama': _namaController.text,
            'tipe': _tipeController.text,
            'telepon': _teleponController.text,
            'alamat': _alamatController.text,
          };
          _isFormMode = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAddress() async {
    String? userId = AppState().userId;
    if (userId == null) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'store_name': FieldValue.delete(),
        'store_type': FieldValue.delete(),
        'store_phone': FieldValue.delete(),
        'address': FieldValue.delete(),
      }, SetOptions(merge: true));
      
      if (mounted) {
        setState(() {
          _address = null;
        });
      }
    } catch (e) {
      print('Error deleting address: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeader(),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF14824C)))
              : SingleChildScrollView(
                  child: _isSubTabAsisten 
                    ? _buildAsistenChatView()
                    : _isFormMode ? _buildForm() : _buildAddressView(),
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
          const Text('Pengaturan', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
          if (AppState().userRole != 'admin') ...[
            _buildDrawerItem(Icons.bar_chart_rounded, 'Data', onTap: () {
              Navigator.pushReplacementNamed(context, '/data-seller');
            }),
            _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan', onTap: () {
              Navigator.pushReplacementNamed(context, '/keuangan-seller');
            }),
          ],
          _buildDrawerItem(Icons.settings, 'Pengaturan', isSelected: true),
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
    return Container(
      color: const Color(0xFFF8F7F3),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.list, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => setState(() => _isSubTabAsisten = false),
                    child: Text(
                      'Alamat Saya', 
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _isSubTabAsisten ? Colors.grey : Colors.black)
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => setState(() => _isSubTabAsisten = true),
                    child: Text(
                      'Asisten Chat', 
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _isSubTabAsisten ? Colors.black : Colors.grey)
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (AppState().userRole != 'owner')
            ElevatedButton.icon(
              onPressed: () => _openForm(isEdit: false),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Tambah Alamat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0BF00),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alamat Saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text('Atur alamat toko dan alamat pribadi', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        if (_address != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.store, color: Colors.grey),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildAddressRow('Nama', _address!['nama']!, actionText: AppState().userRole == 'owner' ? null : 'Ubah', actionColor: Colors.blue, onActionTap: () => _openForm(isEdit: true)),
                        const SizedBox(height: 16),
                        _buildAddressRow('Kamu/Toko', _address!['tipe']!, actionText: AppState().userRole == 'owner' ? null : 'Hapus', actionColor: Colors.red, onActionTap: _deleteAddress),
                        const SizedBox(height: 16),
                        _buildAddressRow('No. Telepon', _address!['telepon']!),
                        const SizedBox(height: 16),
                        _buildAddressRow('Alamat', _address!['alamat']!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('Belum ada alamat')),
          ),
      ],
    );
  }

  Widget _buildAddressRow(String label, String value, {String? actionText, Color? actionColor, VoidCallback? onActionTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(actionText, style: TextStyle(color: actionColor, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alamat Saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text('Atur alamat toko dan alamat pribadi', style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildFormField('Nama', 'Nama', _namaController),
              const SizedBox(height: 16),
              _buildFormField('Kamu/Toko', 'Rumah/Toko', _tipeController),
              const SizedBox(height: 16),
              _buildFormField('No. Telepon', 'No. Telepon', _teleponController),
              const SizedBox(height: 16),
              _buildFormField('Alamat', 'Alamat Toko', _alamatController, maxLines: 4),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0BF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  minimumSize: const Size(120, 0),
                ),
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
            ),
          ),
        ),
      ],
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
                Text(
                  _isSubTabAsisten ? 'Jam Auto Reply Offline sudah di perbarui' : 'Alamat Toko berhasil di perbarui',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAsistenChatView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asisten Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text('Gunakan fitur asisten chat untuk memberikan layanan yang lebih efisien kepada pembeli', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAutoReplySection(
                icon: Icons.chat_bubble_outline,
                title: 'Standart Auto-Reply',
                description: 'Ketika di aktifkan, pembeli akan menerima balasan otomatis setelah mengirimkanpesanpertama setiap harinya.',
                isEnabled: _isAutoReplyStandardEnabled,
                onChanged: (val) => setState(() => _isAutoReplyStandardEnabled = val),
                messageText: _isAutoReplyStandardEnabled ? 'Halo kak, Selamat datang di Neola Florist ! Ada yang bisa kami bantu?' : 'Setting standart auto-reply untuk chat pelanggan',
              ),
              const SizedBox(height: 24),
              _buildAutoReplySection(
                icon: Icons.chat_bubble_outline,
                title: 'Auto-Reply Offline',
                description: 'Ketika di aktifkan, pesanan yang dikrim oleh pembeli diluar jam operasional akan otomatis dibalas dengan auto-reply offline',
                isEnabled: _isAutoReplyOfflineEnabled,
                onChanged: (val) => setState(() => _isAutoReplyOfflineEnabled = val),
                messageText: _isAutoReplyOfflineEnabled ? 'Hi, pesanmu sudah kami terima. Karena dikirim di luar jam operasional, kami akan membalas saat toko kembali online.' : 'Setting standart auto-reply untuk chat pelanggan',
              ),
              const SizedBox(height: 24),
              const Text('Pengaturan Jam Operasional Toko', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ..._jamAsisten.entries.map((e) => _buildJamItem(e.key, e.value['isOpen'], e.value['start'], e.value['end'])),
                    const SizedBox(height: 16),
                    if (_isEditJamAsisten)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() => _isEditJamAsisten = false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF0BF00),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() => _isEditJamAsisten = false);
                                _showSuccessDialog();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF14824C),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    else if (AppState().userRole != 'owner')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isEditJamAsisten = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0BF00),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Ubah', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoReplySection({
    required IconData icon,
    required String title,
    required String description,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
    required String messageText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(description, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  if (AppState().userRole != 'owner')
                    Switch(
                      value: isEnabled,
                      onChanged: onChanged,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF14824C),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        messageText,
                        style: TextStyle(color: isEnabled ? Colors.black : Colors.grey, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (AppState().userRole != 'owner')
                      const Text('Ubah', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJamItem(String day, bool isOpen, String start, String end) {
    if (_isEditJamAsisten) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _jamAsisten[day]!['isOpen'] = !isOpen;
                  if (!isOpen) {
                    _jamAsisten[day]!['start'] = '08:00';
                    _jamAsisten[day]!['end'] = '20:00';
                  } else {
                    _jamAsisten[day]!['start'] = '00:00';
                    _jamAsisten[day]!['end'] = '00:00';
                  }
                });
              },
              child: Icon(isOpen ? Icons.check_box : Icons.check_box_outline_blank, color: isOpen ? Colors.black : Colors.grey, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(day, style: TextStyle(fontSize: 13, color: isOpen ? Colors.black : Colors.grey, fontWeight: FontWeight.bold))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen ? const Color(0xFFD1F2E2) : const Color(0xFFF2A3A3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$start - $end',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(fontSize: 13, color: isOpen ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
          Text(
            isOpen ? '$start-$end' : 'Tutup',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isOpen ? Colors.black : Colors.black),
          ),
        ],
      ),
    );
  }
}


