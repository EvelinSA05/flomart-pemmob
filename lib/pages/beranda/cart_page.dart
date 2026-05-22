import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../profile/detail_pesanan.dart';
import '../../services/app_state.dart';
import 'package:intl/intl.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String _selectedPayment = 'Pilih Metode Pembayaran';
  String _selectedShipping = 'Opsi Pengiriman';
  String _selectedAddress = 'Alamat Pengiriman';
  final TextEditingController _catatanController = TextEditingController();
  bool _isLoading = false;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/img/system/LogoFlomart.png',
          height: 35,
        ),
        centerTitle: false,
      ),
      body: ListenableBuilder(
        listenable: AppState(),
        builder: (context, child) {
          final cartItems = AppState().cartItems;
          return cartItems.isEmpty ? _buildEmptyCart() : _buildCartItems(cartItems);
        },
      ),

    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration - using logoKeranjang for now
          Image.asset(
            'assets/img/system/logoKeranjang.png',
            height: 200,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_basket_outlined, size: 150, color: Colors.green),
          ),
          const SizedBox(height: 20),
          Text(
            'Keranjangmu Sekarang Kosong!',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5B800),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Belanja Sekarang',
              style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartItem> cartItems) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Products Card
          _buildProductsCard(cartItems),
          const SizedBox(height: 16),
          // Order Summary Card
          _buildSummaryCard(cartItems),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductsCard(List<CartItem> cartItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Toko', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              const Text('Keranjang', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Produk Yang Dipesan',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF222222)),
          ),
          const Text(
            'Pastikan membaca semua dengan benar sebelum melakukan pembelian',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Product Items
          ...cartItems.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProductItem(entry.value, entry.key),
          )),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _buildActionButton('Belanja', const Color(0xFFE5B800)),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => AppState().clearCart(),
                child: _buildActionButton('Kosongkan', const Color(0xFFE5B800)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(CartItem item, int index) {
    String priceStr = item.price.replaceAll('Rp', '').replaceAll('.', '');
    double price = double.tryParse(priceStr) ?? 0;
    double itemTotal = price * item.quantity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200, width: 60, height: 60, child: const Icon(Icons.image)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(item.size, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _quantityButton(Icons.remove, () {
                      AppState().updateQuantity(index, item.quantity - 1);
                    }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    _quantityButton(Icons.add, () {
                      AppState().updateQuantity(index, item.quantity + 1);
                    }),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => AppState().removeFromCart(index),
                      child: const Text('Hapus', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.price, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 15),
              Text(_currencyFormat.format(itemTotal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSummaryCard(List<CartItem> cartItems) {
    double subtotal = AppState().subtotal;
    double ongkir = 13000;
    double pajak = 500;
    double total = subtotal + ongkir + pajak;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan Pesanan',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF222222)),
              ),
              Text('${cartItems.length} Produk', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          _summaryRow(Icons.list_alt, 'Subtotal', _currencyFormat.format(subtotal)),
          _summaryRow(Icons.local_shipping_outlined, 'Ongkir', _currencyFormat.format(ongkir)),
          _summaryRow(Icons.description_outlined, 'Pajak Admin', _currencyFormat.format(pajak)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFFEEEEEE)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(_currencyFormat.format(total), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _selectionField(Icons.location_on_outlined, _selectedAddress, () => _showAddressModal()),
          _selectionField(Icons.local_shipping_outlined, _selectedShipping, () => _showShippingModal()),
          _selectionField(Icons.person_outline, AppState().userName ?? 'Nama', null),
          _selectionField(Icons.payment_outlined, _selectedPayment, () => _showPaymentModal()),
          const SizedBox(height: 10),
          TextField(
            controller: _catatanController,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Deskripsi / Catatan',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (cartItems.isEmpty) return;
                
                final appState = AppState();
                if (appState.userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan login terlebih dahulu untuk checkout')),
                  );
                  return;
                }

                if (_selectedPayment == 'Pilih Metode Pembayaran' || _selectedShipping == 'Opsi Pengiriman') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih metode pembayaran dan pengiriman')),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  List<Map<String, dynamic>> itemsJson = cartItems.map((item) {
                    double price = double.tryParse(item.price.replaceAll('Rp', '').replaceAll('.', '')) ?? 0;
                    return {
                      'nama_produk': item.name,
                      'qty': item.quantity,
                      'harga': price,
                      'subtotal': price * item.quantity,
                    };
                  }).toList();

                  final response = await http.post(
                    Uri.parse('http://127.0.0.1/flomart_api/checkout.php'),
                    body: {
                      'id_user': appState.userId.toString(),
                      'total_harga': total.toString(),
                      'alamat_kirim': _selectedAddress,
                      'metode_pembayaran': _selectedPayment,
                      'catatan': _catatanController.text,
                      'nama_penerima': appState.userName ?? '',
                      'no_hp': '08120000000', // Can be fetched from user profile if available
                      'items': json.encode(itemsJson),
                    },
                  );

                  final data = json.decode(response.body);

                  if (response.statusCode == 200 && data['status'] == 'success') {
                    final firstItem = cartItems.first;
                    
                    // Add order notification
                    appState.addNotification(AppNotification(
                      title: 'Selesaikan Pembayaranmu',
                      description: 'Hai ${appState.userName} pesananmu sebesar ${_currencyFormat.format(total)} belum dibayar. Segera selesaikan pembayaranmu.',
                      imagePath: firstItem.imagePath,
                      status: 'Belum Bayar',
                      orderId: 'FLM${data['id_pesanan']}',
                      total: _currencyFormat.format(total),
                    ));

                    // Clear local cart
                    appState.clearCart();

                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPesananPage(
                          title: 'Detail Pesanan',
                          orderId: 'FLM${data['id_pesanan']}',
                          image: firstItem.imagePath,
                          itemName: firstItem.name,
                          qty: '${firstItem.size} ${firstItem.quantity}x',
                          price: firstItem.price,
                          total: _currencyFormat.format(total),
                          status: 'Menunggu Pembayaran',
                          showSuccessDialog: true,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(data['message'] ?? 'Gagal membuat pesanan')),
                    );
                  }
                } catch (e) {
                  print('Checkout error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terjadi kesalahan koneksi')),
                  );
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5B800),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : Text(
                  'Check Out',
                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _selectionField(IconData icon, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500))),
            if (onTap != null) const Icon(Icons.keyboard_arrow_down, color: Colors.black45, size: 20),
          ],
        ),
      ),
    );
  }

  // Modals
  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionModal(
        'Pilih Metode Pembayaran',
        [
          {'label': 'COD', 'desc': 'Pembayaran Ditempat', 'icon': Icons.money},
          {'label': 'Transfer Bank BCA', 'desc': 'Nomor rekening anda belum terdaftar', 'icon': Icons.account_balance},
          {'label': 'Transfer Bank BNI', 'desc': 'Nomor rekening anda belum terdaftar', 'icon': Icons.account_balance},
        ],
        (val) => setState(() => _selectedPayment = val),
      ),
    );
  }

  void _showShippingModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionModal(
        'Pilih Layanan Pengiriman',
        [
          {'label': 'Antareja Regular', 'desc': 'Rp3.000 (7 Hari)', 'icon': Icons.local_shipping},
          {'label': 'ID Express', 'desc': 'Rp4.000 (5-6 Hari)', 'icon': Icons.local_shipping},
          {'label': 'JNE Regular', 'desc': 'Rp13.000 (3-4 Hari)', 'icon': Icons.local_shipping},
          {'label': 'JNT Express', 'desc': 'Rp20.000 (1-2 Hari)', 'icon': Icons.local_shipping},
        ],
        (val) => setState(() => _selectedShipping = val),
      ),
    );
  }

  void _showAddressModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionModal(
        'Pilih Alamat Tersedia',
        [
          {'label': 'Agung Prasetyo', 'desc': 'Sidoarjo Indah ai no 12, SIDOARJO, KAB. SIDOARJO, JAWA TIMUR, ID, 61212', 'icon': Icons.location_on},
        ],
        (val) => setState(() => _selectedAddress = val),
      ),
    );
  }

  Widget _buildSelectionModal(String title, List<Map<String, dynamic>> items, Function(String) onSelect) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(item['icon'] as IconData, color: Colors.green, size: 24),
                  ),
                  title: Text(item['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(item['desc'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                  onTap: () {
                    onSelect(item['label'] as String);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
