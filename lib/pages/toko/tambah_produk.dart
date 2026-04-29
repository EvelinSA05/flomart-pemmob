import 'package:flutter/material.dart';

class TambahProdukPage extends StatefulWidget {
  const TambahProdukPage({super.key});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _namaController = TextEditingController(text: 'Bunga Sepatu');
  final TextEditingController _stokController = TextEditingController(text: '100');
  final TextEditingController _unitController = TextEditingController(text: 'Buah');
  final TextEditingController _subKategoriController = TextEditingController(text: 'Bunga Hias');
  final TextEditingController _hargaController = TextEditingController(text: 'Rp 20.000');
  final TextEditingController _garansiController = TextEditingController(text: '01');
  final TextEditingController _deskripsiController = TextEditingController(
    text: 'Bunga Sepatu adalah tanaman hias berbunga dengan kelopak besar dan warna cerah yang cocok untuk memperindah taman, halaman rumah, maupun area outdoor. Tanaman ini mudah dirawat, tumbuh baik di iklim tropis, dan membutuhkan sinar matahari langsung agar berbunga optimal. Cocok untuk pemula maupun pecinta tanaman hias.',
  );

  String _selectedKategori = 'Bunga';
  String _selectedJenisTanah = 'Gambut';
  String _selectedIklim = 'Musim Hujan';

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _unitController.dispose();
    _subKategoriController.dispose();
    _hargaController.dispose();
    _garansiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F7F3),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumbs(),
            _buildSubHeader(),
            _buildImageSection(),
            _buildFormSection(),
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
              style: TextStyle(color: Color(0xFF14824C), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble, color: Color(0xFF14824C))),
        IconButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), icon: const Icon(Icons.home, color: Color(0xFF14824C))),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBreadcrumbs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: const [
          Text('Produk Saya', style: TextStyle(color: Colors.grey, fontSize: 12)),
          Icon(Icons.chevron_right, color: Colors.grey, size: 16),
          Text('Tambah Produk', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.list, size: 28),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          const Text('Tambah Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
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
          _buildDrawerItem(Icons.inventory_2_rounded, 'Pesanan & Pengiriman'),
          _buildDrawerItem(Icons.bar_chart_rounded, 'Data'),
          _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan'),
          _buildDrawerItem(Icons.settings, 'Pengaturan'),
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

  Widget _buildImageSection() {
    return Column(
      children: [
        Center(
          child: Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/img/produk/bunga_sepatu.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.none), // Custom dashed border needed
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomPaint(
              painter: DashedRectPainter(color: Colors.grey),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Tambah Gambar Produk', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldRow('Nama Produk', _buildTextField(_namaController)),
          const SizedBox(height: 16),
          _buildFieldRow('Stok', Row(
            children: [
              Expanded(flex: 2, child: _buildTextField(_stokController)),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _buildTextField(_unitController)),
            ],
          )),
          const SizedBox(height: 16),
          _buildFieldRow('Kategori', _buildDropdown(['Bunga', 'Buah', 'Sayur'], _selectedKategori, (val) => setState(() => _selectedKategori = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Sub Kategori', _buildTextField(_subKategoriController)),
          const SizedBox(height: 16),
          _buildFieldRow('Harga', _buildTextField(_hargaController)),
          const SizedBox(height: 16),
          _buildFieldRow('Jenis Tanah', _buildDropdown(['Gambut', 'Lempung', 'Pasir'], _selectedJenisTanah, (val) => setState(() => _selectedJenisTanah = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Iklim Ideal', _buildDropdown(['Musim Hujan', 'Kemarau', 'Semua Musim'], _selectedIklim, (val) => setState(() => _selectedIklim = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Garansi', Row(
            children: [
              Expanded(child: _buildTextField(_garansiController)),
              const SizedBox(width: 12),
              const Text('Bulan', style: TextStyle(fontSize: 16)),
            ],
          )),
          const SizedBox(height: 16),
          const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white.withOpacity(0.5),
            ),
            child: Text(
              _deskripsiController.text,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0BF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, Widget field) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        Expanded(child: field),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      height: 40,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Drawing dashed rectangle
    _drawDashedLine(canvas, Offset(0, 0), Offset(size.width, 0), paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(size.width, 0), Offset(size.width, size.height), paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(size.width, size.height), Offset(0, size.height), paint, dashWidth, dashSpace);
    _drawDashedLine(canvas, Offset(0, size.height), Offset(0, 0), paint, dashWidth, dashSpace);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint, double dashWidth, double dashSpace) {
    double distance = (end - start).distance;
    int count = (distance / (dashWidth + dashSpace)).floor();
    for (int i = 0; i < count; i++) {
      double t1 = i * (dashWidth + dashSpace) / distance;
      double t2 = (i * (dashWidth + dashSpace) + dashWidth) / distance;
      canvas.drawLine(Offset.lerp(start, end, t1)!, Offset.lerp(start, end, t2)!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
