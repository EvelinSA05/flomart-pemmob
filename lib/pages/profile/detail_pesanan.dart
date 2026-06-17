import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../services/app_state.dart';
import 'pesanan_saya.dart';

class OrderItem {
  final String name;
  final String image;
  final String size;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.image,
    required this.size,
    required this.quantity,
    required this.price,
  });
}

class DetailPesananPage extends StatefulWidget {
  final String title;
  final String orderId;
  final String image;
  final String itemName;
  final String qty;
  final String price;
  final String total;
  final String status;
  final bool showSuccessDialog;
  // New fields for cart info
  final List<OrderItem> orderItems;
  final double subtotal;
  final double ongkir;
  final String paymentMethod;
  final String shippingMethod;
  final String recipientName;
  final String recipientAddress;

  const DetailPesananPage({
    super.key,
    required this.title,
    required this.orderId,
    required this.image,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.total,
    required this.status,
    this.showSuccessDialog = false,
    this.orderItems = const [],
    this.subtotal = 0,
    this.ongkir = 0,
    this.paymentMethod = 'Transfer Bank BCA',
    this.shippingMethod = '',
    this.recipientName = '',
    this.recipientAddress = '',
  });

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  static const Color _green = Color(0xFF13824B);
  static const Color _bg = Color(0xFFF6F3F3);
  static const Color _yellow = Color(0xFFE2BE00);

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.showSuccessDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessDialog();
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.black, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(color: Color(0xFF13824B), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 45),
              ),
              const SizedBox(height: 20),
              const Text(
                'Berhasil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pembayaran Pembelian Anda Berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PesananSayaPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2BE00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Lihat Pesanan',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Determine which step index the status maps to
  int get _statusIndex {
    String s = widget.status.toLowerCase();
    if (s.contains('belum bayar') || s.contains('menunggu pembayaran') || s == 'menunggu') return 0;
    if (s.contains('menunggu konfirmasi') || s.contains('konfirmasi') || s.contains('diproses')) return 1;
    if (s.contains('dikemas') || s.contains('perlu dikirim')) return 2;
    if (s == 'dikirim') return 3;
    if (s.contains('selesai') || s.contains('pengembalian') || s.contains('batal') || s.contains('tolak')) return 4;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                child: Column(
                  children: [
                    _buildProductCard(),
                    const SizedBox(height: 12),
                    _buildSellerCard(),
                    const SizedBox(height: 12),
                    _buildVirtualAccountCard(context),
                    const SizedBox(height: 12),
                    if (_statusIndex == 0) ...[
                      _buildUploadBuktiCard(context),
                      const SizedBox(height: 12),
                    ],
                    _buildOrderSummaryCard(),
                    const SizedBox(height: 12),
                    _buildRecipientCard(),
                    const SizedBox(height: 12),
                    _buildStatusCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== HEADER =====================
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/img/system/logoFlomart.png',
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Text(
              'FLOMART',
              style: TextStyle(
                color: Color(0xFF14824C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PRODUK =====================
  Widget _buildProductCard() {
    final items = widget.orderItems;
    final itemCount = items.isNotEmpty ? items.length : 1;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              Text('Home', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              const Text('Detail Pesanan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Produk Yang Dipesan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Text('$itemCount Produk', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 14),
          if (items.isNotEmpty)
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildOrderItemRow(item),
            ))
          else
            _buildLegacyItemRow(),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItem item) {
    final itemTotal = item.price * item.quantity;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            item.image,
            width: 58,
            height: 65,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(width: 58, height: 65, color: Colors.grey.shade200, child: const Icon(Icons.image)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(item.size, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${item.quantity} x ${_currencyFormat.format(item.price)}', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(_currencyFormat.format(itemTotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }

  // Fallback for old-style single item (backward compatibility)
  Widget _buildLegacyItemRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            widget.image,
            width: 58,
            height: 65,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(width: 58, height: 65, color: Colors.grey.shade200),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.itemName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(widget.qty.split(' ').first, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.price, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text(widget.total, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }

  // ===================== PENJUAL =====================
  Widget _buildSellerCard() {
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Penjual', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    const Text('Kaka Petani', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Dipesan $now', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/img/system/pengguna_login.png', width: 65, height: 65, fit: BoxFit.cover),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pembayaran', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 4),
                    Text(
                      widget.paymentMethod.isNotEmpty ? widget.paymentMethod : 'Transfer Bank BCA',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Pesanan', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Builder(
                    builder: (context) {
                      String statusLower = widget.status.toLowerCase();
                      
                      Color displayColor = Colors.orange;
                      if (statusLower.contains('ditolak') || statusLower.contains('batal')) {
                        displayColor = Colors.red;
                      } else if (statusLower.contains('disetujui') || statusLower == 'selesai') {
                        displayColor = const Color(0xFF14824C); // _green
                      } else if (statusLower == 'dikirim' || statusLower == 'perlu dikirim') {
                        displayColor = Colors.blue;
                      }

                      // Format display text (Capitalize Each Word)
                      String displayText = widget.status.split(' ').map((word) {
                        if (word.isEmpty) return '';
                        return word[0].toUpperCase() + word.substring(1).toLowerCase();
                      }).join(' ');

                      return Text(
                        displayText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: displayColor,
                        ),
                      );
                    }
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== VIRTUAL AKUN =====================
  Widget _buildVirtualAccountCard(BuildContext context) {
    const String vaNumber = '1234567899029302';
    return _card(
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Text('Virtual Akun ID :  ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(vaNumber, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: vaNumber));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor Virtual Account disalin!')));
            },
            child: const Text('Salin', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // ===================== UPLOAD BUKTI =====================
  Widget _buildUploadBuktiCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Instruksi Pembayaran & Upload Bukti', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Text(
            'Silakan transfer ke rekening berikut:\n\n'
            'Bank BCA: 1234567890\n'
            'A.N: Flomart Official\n\n'
            'Setelah transfer, silakan upload bukti pembayaran agar pesanan Anda dapat segera diproses.',
            style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => _pickAndUploadImage(context),
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload Bukti Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0BF00),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 30, maxWidth: 600);

    if (image == null) return; // User canceled

    final bytes = await image.readAsBytes();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(color: Color(0xFF14824C)),
            SizedBox(width: 16),
            Text('Mengunggah bukti...'),
          ],
        ),
      ),
    );

    bool success = await AppState().uploadPaymentProof(widget.orderId, bytes);
    
    Navigator.pop(context); // tutup dialog loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bukti berhasil diunggah! Menunggu konfirmasi admin.', style: TextStyle(color: Colors.white)), 
          backgroundColor: Color(0xFF14824C)
        ),
      );
      Navigator.pop(context); // kembali ke halaman sebelumnya (Pesanan Saya)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengunggah bukti, silakan coba lagi.', style: TextStyle(color: Colors.white)), 
          backgroundColor: Colors.red
        ),
      );
    }
  }

  // ===================== RINGKASAN =====================
  Widget _buildOrderSummaryCard() {
    final itemCount = widget.orderItems.isNotEmpty ? widget.orderItems.length : 1;
    final subtotal = widget.subtotal > 0 ? widget.subtotal : 0;
    final ongkir = widget.ongkir;
    const double pajak = 500;
    final totalCalc = subtotal + ongkir + pajak;
    // Use the passed total if subtotal is 0 (legacy), otherwise use calculated
    final displayTotal = subtotal > 0 ? _currencyFormat.format(totalCalc) : widget.total;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ringkasan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Text('$itemCount Produk', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          _summaryRow(Icons.receipt_long, 'Subtotal', subtotal > 0 ? _currencyFormat.format(subtotal) : widget.total),
          const SizedBox(height: 12),
          _summaryRow(Icons.local_shipping_outlined, 'Ongkir', _currencyFormat.format(ongkir)),
          const SizedBox(height: 12),
          _summaryRow(Icons.account_balance_wallet_outlined, 'Biaya Admin', _currencyFormat.format(pajak)),
          const SizedBox(height: 14),
          const Divider(thickness: 1.2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Text(displayTotal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ===================== PENERIMA =====================
  Widget _buildRecipientCard() {
    final recipientName = widget.recipientName.isNotEmpty
        ? widget.recipientName
        : (AppState().userName ?? 'Pengguna');
    final recipientAddress = widget.recipientAddress.isNotEmpty
        ? widget.recipientAddress
        : 'Sidokare Indah ai no 12\nSIDOARJO,KAB. SIDOARJO, JAWA TIMUR, ID, 61212';

    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penerima', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(recipientName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  recipientAddress,
                  style: TextStyle(fontSize: 11, height: 1.4, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.location_on, color: Colors.black, size: 30),
        ],
      ),
    );
  }

  // ===================== STATUS =====================
  Widget _buildStatusCard() {
    final steps = ['Pembayaran', 'Konfirmasi', 'Dikemas', 'Dikirim', 'Selesai'];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Status Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 25),
          Row(
            children: List.generate(steps.length, (i) {
              final isCompleted = i < _statusIndex || (_statusIndex == 4 && i == 4);
              final isCurrent = i == _statusIndex && _statusIndex != 4;
              return Expanded(
                child: Column(
                  children: [
                    Text(steps[i], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: isCompleted || isCurrent ? _green : Colors.grey.shade300,
                            ),
                          ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted ? _green : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isCompleted ? _green : (isCurrent ? _yellow : Colors.grey.shade300),
                              width: 2,
                            ),
                          ),
                          child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: isCompleted ? _green : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (isCompleted)
                      _statusPill('Tuntas', const Color(0xFFC7EBD7), _green)
                    else if (isCurrent)
                      _statusPill('Proses', const Color(0xFFFFF7CC), _yellow)
                    else
                      const SizedBox(height: 18),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textColor)),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}
