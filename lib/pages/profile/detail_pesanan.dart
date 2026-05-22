import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  });

  @override
  State<DetailPesananPage> createState() => _DetailPesananPageState();
}

class _DetailPesananPageState extends State<DetailPesananPage> {
  static const Color _green = Color(0xFF13824B);
  static const Color _bg = Color(0xFFF6F3F3);
  static const Color _yellow = Color(0xFFE2BE00);

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
            ],
          ),
        ),
      ),
    );
  }

  // Determine which step index the status maps to
  int get _statusIndex {
    switch (widget.status) {
      case 'Belum Bayar':
        return 0;
      case 'Konfirmasi':
        return 1;
      case 'Dikemas':
        return 2;
      case 'Dikirim':
        return 3;
      case 'Selesai':
        return 4;
      default:
        return 2; // Default to 'Dikemas' for success flow demo
    }
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
              Text('2 Produk', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
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
                  Text('2 x Rp10.000', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                  const SizedBox(height: 4),
                  const Text('Rp20.000', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== PENJUAL =====================
  Widget _buildSellerCard() {
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
                    Text('Dipesan 12/2/2025 10:25', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
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
                    const Text('Transfer Bank BCA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Pembayaran', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  const Text('Selesai', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _green)),
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

  // ===================== RINGKASAN =====================
  Widget _buildOrderSummaryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ringkasan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Text('2 Produk', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          _summaryRow(Icons.receipt_long, 'Subtotal', 'Rp24.000'),
          const SizedBox(height: 12),
          _summaryRow(Icons.local_shipping_outlined, 'Ongkir', 'Rp13.000'),
          const SizedBox(height: 12),
          _summaryRow(Icons.account_balance_wallet_outlined, 'Biaya Admin', 'Rp500'),
          const SizedBox(height: 14),
          const Divider(thickness: 1.2),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Text('Rp37.500', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
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
                const Text('Agung Prasetyo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'Sidokare Indah ai no 12\nSIDOARJO,KAB. SIDOARJO, JAWA TIMUR, ID, 61212',
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
              final isCompleted = i < _statusIndex;
              final isCurrent = i == _statusIndex;
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
                      _statusPill('Selesai', const Color(0xFFC7EBD7), _green)
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
