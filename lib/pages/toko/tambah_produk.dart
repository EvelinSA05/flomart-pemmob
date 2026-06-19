import '../../services/app_state.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class TambahProdukPage extends StatefulWidget {
  final Map<String, dynamic>? productData;
  const TambahProdukPage({super.key, this.productData});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      _namaController.text = widget.productData!['name'] ?? '';
      _hargaController.text = widget.productData!['price']?.toString() ?? '';
      _deskripsiController.text = widget.productData!['desc'] ?? '';
      _stokController.text = widget.productData!['stok']?.toString() ?? '';
      _unitController.text = widget.productData!['satuan_stok'] ?? 'Buah';
      _subKategoriController.text = widget.productData!['sub_kategori'] ?? '';
      _garansiController.text = widget.productData!['garansi']?.toString() ?? '';
      _ratingController.text = widget.productData!['rating']?.toString() ?? '0.0';
      
      String tanah = widget.productData!['jenis_tanah'] ?? 'Gambut';
      if (['Aluvial', 'Andosol', 'Gambut', 'Latosol', 'Pasir', 'Humus'].contains(tanah)) _selectedJenisTanah = tanah;
      
      String iklim = widget.productData!['iklim_ideal'] ?? 'Musim Hujan';
      if (['Musim Hujan', 'Musim Panas', 'Dataran Rendah', 'Dataran Tinggi'].contains(iklim)) _selectedIklim = iklim;
      
      String cat = widget.productData!['category'] ?? '';
      if (cat.contains('Bunga') || cat.contains('Tanaman Hias')) _selectedKategori = 'Tanaman Hias';
      else if (cat.contains('Buah')) _selectedKategori = 'Buah';
      else if (cat.contains('Sayur') || cat.contains('Sayuran')) _selectedKategori = 'Sayur';
      else if (cat.contains('Pangan')) _selectedKategori = 'Pangan';
      else if (cat.contains('Herbal')) _selectedKategori = 'Herbal';
    }
  }

  Future<void> _simpanProduk() async {
    String nama = _namaController.text.trim();
    String hargaRaw = _hargaController.text.trim();
    String deskripsi = _deskripsiController.text.trim();

    // Validasi 1: Nama produk tidak boleh kosong
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama produk tidak boleh kosong!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi 2: Harga tidak boleh kosong
    if (hargaRaw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga tidak boleh kosong!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    String harga = hargaRaw.replaceAll(RegExp(r'[^0-9]'), '');
    double priceValue = double.tryParse(harga) ?? 0.0;

    String categoryName = 'Benih Sayur';
    if (_selectedKategori == 'Tanaman Hias') {
      categoryName = 'Benih Tanaman Hias';
    } else if (_selectedKategori == 'Buah') categoryName = 'Benih Buah';
    else if (_selectedKategori == 'Sayur') categoryName = 'Benih Sayur';
    else if (_selectedKategori == 'Pangan') categoryName = 'Benih Pangan';
    else if (_selectedKategori == 'Herbal') categoryName = 'Benih Herbal';

    try {
      String message = '';
      String? base64Image;
      if (_imageBytes != null) {
        base64Image = 'data:image/png;base64,' + base64Encode(_imageBytes!);
      }
      
      if (widget.productData != null) {
        Map<String, dynamic> updateData = {
          'name': nama,
          'price': priceValue,
          'category': categoryName,
          'desc': deskripsi,
          'stok': int.tryParse(_stokController.text.trim()) ?? 0,
          'satuan_stok': _unitController.text.trim(),
          'sub_kategori': _subKategoriController.text.trim(),
          'jenis_tanah': _selectedJenisTanah,
          'iklim_ideal': _selectedIklim,
          'garansi': _garansiController.text.trim(),
          'rating': double.tryParse(_ratingController.text.trim()) ?? 0.0,
        };
        if (base64Image != null) updateData['image'] = base64Image;
        
        await FirebaseFirestore.instance.collection('products').doc(widget.productData!['id']).update(updateData);
        message = 'Produk berhasil diperbarui!';
      } else {
        final docRef = FirebaseFirestore.instance.collection('products').doc();
        await docRef.set({
          'id': docRef.id,
          'name': nama,
          'price': priceValue,
          'rating': double.tryParse(_ratingController.text.trim()) ?? 0.0,
          'category': categoryName,
          'image': base64Image ?? 'assets/img/produk/15.png',
          'desc': deskripsi,
          'stok': int.tryParse(_stokController.text.trim()) ?? 0,
          'satuan_stok': _unitController.text.trim(),
          'sub_kategori': _subKategoriController.text.trim(),
          'jenis_tanah': _selectedJenisTanah,
          'iklim_ideal': _selectedIklim,
          'garansi': _garansiController.text.trim(),
        });
        message = 'Produk berhasil ditambahkan ke Firebase!';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          )
        );
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, '/produk-saya');
        }
      }
    } catch (e) {
      print('Error saving to Firebase: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat menyimpan data', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _subKategoriController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _garansiController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 400, imageQuality: 50);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  String _selectedKategori = 'Sayur';
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
    _ratingController.dispose();
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
            errorBuilder: (_, _, _) => const Text(
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
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/produk-saya');
              }
            },
            child: const Text('Produk Saya', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
          Text(widget.productData != null ? 'Ubah Produk' : 'Tambah Produk', style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/produk-saya');
              }
            },
            icon: const Icon(Icons.arrow_back_ios, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Text(widget.productData != null ? 'Ubah Produk' : 'Tambah Produk', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
          if (AppState().userRole != 'admin') ...[
            _buildDrawerItem(Icons.bar_chart_rounded, 'Data'),
            _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Keuangan'),
          ],
          _buildDrawerItem(Icons.settings, 'Pengaturan'),
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

  Widget _buildImageSection() {
    bool hasImageBytes = _imageBytes != null;
    String? existingImage = widget.productData?['image'];
    bool hasExistingImage = existingImage != null && existingImage.isNotEmpty;
    bool isNetworkImage = hasExistingImage && existingImage.startsWith('http');

    ImageProvider? imageProvider;
    if (hasImageBytes) {
      imageProvider = MemoryImage(_imageBytes!);
    } else if (hasExistingImage) {
      if (isNetworkImage) {
        imageProvider = NetworkImage(existingImage);
      } else if (existingImage.startsWith('data:image')) {
        imageProvider = MemoryImage(base64Decode(existingImage.split(',').last));
      } else {
        imageProvider = AssetImage(existingImage);
      }
    }

    return Column(
      children: [
        Center(
          child: Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade200,
              image: imageProvider != null ? DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ) : null,
            ),
            child: imageProvider == null ? const Icon(Icons.image, size: 80, color: Colors.grey) : null,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, style: BorderStyle.none), // Custom dashed border needed
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(
                painter: DashedRectPainter(color: Colors.grey),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(widget.productData != null ? 'Ubah Gambar Produk' : 'Tambah Gambar Produk', style: const TextStyle(color: Colors.black)),
                ),
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
          _buildFieldRow('Nama Produk', _buildTextField(_namaController, 'Contoh: Benih Sawi')),
          const SizedBox(height: 16),
          _buildFieldRow('Stok', Row(
            children: [
              Expanded(flex: 2, child: _buildTextField(_stokController, '100')),
              const SizedBox(width: 8),
              Expanded(flex: 3, child: _buildTextField(_unitController, 'Buah')),
            ],
          )),
          const SizedBox(height: 16),
          _buildFieldRow('Kategori', _buildDropdown(['Sayur', 'Buah', 'Pangan', 'Herbal', 'Tanaman Hias'], _selectedKategori, (val) => setState(() => _selectedKategori = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Sub Kategori', _buildTextField(_subKategoriController, 'Bunga Hias')),
          const SizedBox(height: 16),
          _buildFieldRow('Harga', _buildTextField(_hargaController, 'Rp 20.000')),
          const SizedBox(height: 16),
          _buildFieldRow('Jenis Tanah', _buildDropdown(['Aluvial', 'Andosol', 'Gambut', 'Latosol', 'Pasir', 'Humus'], _selectedJenisTanah, (val) => setState(() => _selectedJenisTanah = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Iklim Ideal', _buildDropdown(['Musim Hujan', 'Musim Panas', 'Dataran Rendah', 'Dataran Tinggi'], _selectedIklim, (val) => setState(() => _selectedIklim = val!))),
          const SizedBox(height: 16),
          _buildFieldRow('Garansi', Row(
            children: [
              Expanded(child: _buildTextField(_garansiController, '1')),
              const SizedBox(width: 12),
              const Text('Bulan', style: TextStyle(fontSize: 16)),
            ],
          )),
          const SizedBox(height: 16),
          _buildFieldRow('Rating', Row(
            children: [
              Expanded(child: _buildTextField(_ratingController, 'Misal: 4.8')),
              const SizedBox(width: 12),
              const Icon(Icons.star, color: Colors.amber, size: 20),
            ],
          )),
          const SizedBox(height: 16),
          const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _deskripsiController,
            maxLines: 4,
            style: const TextStyle(fontSize: 10),
            decoration: InputDecoration(
              hintText: 'Tuliskan deksripsi singkat mengenai produkmu...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _simpanProduk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0BF00),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
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









