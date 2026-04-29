import 'package:flutter/material.dart';

class DashboardSellerPage extends StatefulWidget {
  const DashboardSellerPage({super.key});

  @override
  State<DashboardSellerPage> createState() => _DashboardSellerPageState();
}

class _DashboardSellerPageState extends State<DashboardSellerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController _namaTokoController = TextEditingController(text: 'Neola Florist');
  final TextEditingController _whatsappController = TextEditingController(text: '083183066357');
  final TextEditingController _deskripsiTokoController = TextEditingController(text: 'Toko jual beli tanaman dan lengkap');
  
  bool _isSaved = false;

  @override
  void dispose() {
    _namaTokoController.dispose();
    _whatsappController.dispose();
    _deskripsiTokoController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_isSaved) {
      _showSuccessDialog();
    } else {
      setState(() {
        _isSaved = true;
      });
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF14824C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Berhasil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Data Toko Berhasil di Perbarui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeader(),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            _buildTabSection(),
            const SizedBox(height: 16),
            _buildBannerAndProfile(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            _buildFormSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 32),
          ],
        ),
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
              style: TextStyle(
                color: Color(0xFF14824C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Toko',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/chat-list-seller'),
          icon: const Icon(Icons.chat_bubble, color: Color(0xFF14824C)),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Color(0xFF14824C))),
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
          _buildDrawerItem(Icons.store, 'Toko', isSelected: true),
          _buildDrawerItem(Icons.grid_view_rounded, 'Produk', onTap: () {
            Navigator.pushNamed(context, '/produk-saya');
          }),
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
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.list, color: Colors.black, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Toko',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Lihat status toko dan update profile toko anda',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Informasi Utama',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 110,
            height: 3,
            color: const Color(0xFFF0BF00),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAndProfile() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Banner Background
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF5EB),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/img/konten_blog/fotoMulaiJualan1.png',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.green.shade100),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _isSaved ? 'Neola Florist' : 'Belum Ada Toko',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _isSaved ? 'Aktif 12 Menit yang lalu' : 'Tidak Aktif',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFF0BF00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Profile Avatar
            Positioned(
              bottom: 0,
              left: 32,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF14824C), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/img/system/petani.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 48, color: Color(0xFFEEEEEE)),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'Ubah',
                          style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistika Toko',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                _buildStatRow('Rate Bintang dari Pembeli', '0', const Color(0xFF14824C)),
                const Divider(height: 1, thickness: 1),
                _buildStatRow('Produk', '0000', const Color(0xFFF0BF00)),
                const Divider(height: 1, thickness: 1),
                _buildStatRow('Tingkat Pembatalan/Pengembalian', '0%', const Color(0xFF912F2F)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Nama Toko', 'Nama Toko', _namaTokoController),
          const SizedBox(height: 20),
          _buildTextField('No. WhatsApp', 'No.WhatsApp', _whatsappController),
          const SizedBox(height: 20),
          const Text(
            'Deskripsi Gambar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Foto toko akan dipajang pada halaman\nprofile toko anda',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          _buildImageUploadPlaceholder(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deskripsi Toko',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '${_deskripsiTokoController.text.length}/100',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _deskripsiTokoController,
            maxLines: 4,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Deskripsi Toko',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/img/konten_blog/fotoMulaiJualan1.png',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.add, size: 32, color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 48,
        child: ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0BF00),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
          ),
          child: Text(
            _isSaved ? 'Ubah' : 'Simpan',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
