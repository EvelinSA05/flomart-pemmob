import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'detail_pesanan.dart';
import '../../services/app_state.dart';
import '../chat/chat_page.dart';

class PesananSayaPage extends StatefulWidget {
  const PesananSayaPage({super.key});

  @override
  State<PesananSayaPage> createState() => _PesananSayaPageState();
}

class _PesananSayaPageState extends State<PesananSayaPage> {
  int selectedTab = 0;

  final List<String> tabs = [
    'All',
    'Belum Bayar',
    'Dikemas',
    'Dikirim',
    'Selesai',
  ];

  // Orders will now be fetched dynamically from Firebase via AppState

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, child) {
        final allOrders = AppState().orders.map((o) => o.toMap()).toList();
        
        final filteredOrders = selectedTab == 0
            ? allOrders
            : allOrders.where((item) {
                String status = item['status'].toString().toLowerCase();
                String tab = tabs[selectedTab].toLowerCase();

                if (tab == 'belum bayar') {
                  return status == 'belum bayar' || status == 'menunggu pembayaran';
                } else if (tab == 'dikemas') {
                  return status == 'dikemas' || status == 'diproses' || status == 'menunggu konfirmasi';
                } else if (tab == 'dikirim') {
                  return status == 'dikirim';
                } else if (tab == 'selesai') {
                  return status == 'selesai' || status == 'menunggu pengembalian' || status == 'pengembalian ditolak' || status == 'pengembalian disetujui';
                }
                return false;
              }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff6f3f3),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  
                  List<String> dynamicButtons = List<String>.from(order['buttons']);
                  if (order['status'] == 'Belum Bayar' || order['status'] == 'Menunggu Pembayaran') {
                    if (!dynamicButtons.contains('Bayar Sekarang')) {
                      dynamicButtons.insert(0, 'Bayar Sekarang');
                    }
                  } else if (order['status']?.toString().toLowerCase() == 'menunggu konfirmasi') {
                    dynamicButtons.remove('Bayar Sekarang');
                    dynamicButtons.remove('Pembatalan');
                  } else if (order['status']?.toString().toLowerCase() == 'selesai') {
                    if (!dynamicButtons.contains('Ajukan Pengembalian')) {
                      dynamicButtons.insert(0, 'Ajukan Pengembalian');
                    }
                  } else if (order['status']?.toString().toLowerCase() == 'menunggu pengembalian' || order['status']?.toString().toLowerCase() == 'pengembalian disetujui' || order['status']?.toString().toLowerCase() == 'pengembalian ditolak') {
                    dynamicButtons.clear();
                    dynamicButtons.add('Detail Pesanan');
                  }

                  return OrderCard(
                    title: order['title'],
                    orderId: order['orderId'],
                    image: order['image'],
                    itemName: order['itemName'],
                    qty: order['qty'],
                    price: order['price'],
                    total: order['total'],
                    status: order['status'],
                    buttons: dynamicButtons,
                    showRating: order['showRating'],
                    onCancel: () {
                      // Batal order handled elsewhere if needed
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _header() {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 22),
          ),
          const SizedBox(width: 18),
          const Text(
            'Pesanan Saya',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      height: 52,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isActive = selectedTab == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 28,
                  height: 2,
                  color: isActive
                      ? const Color(0xffd6b14c)
                      : Colors.transparent,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final String title;
  final String orderId;
  final String image;
  final String itemName;
  final String qty;
  final String price;
  final String total;
  final String status;
  final List<String> buttons;
  final bool showRating;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.title,
    required this.orderId,
    required this.image,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.total,
    required this.status,
    required this.buttons,
    this.showRating = false,
    this.onCancel,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int rating = 0;

  Future<void> _showReturnDialog(BuildContext context, String orderId) async {
    final TextEditingController reasonController = TextEditingController();
    XFile? pickedImage;
    bool isSubmitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16, right: 16, top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ajukan Pengembalian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Alasan Pengembalian:'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tuliskan alasan lengkap (misal: barang rusak, tidak sesuai...)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Foto Bukti Produk:'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 30, maxWidth: 600);
                      if (img != null) {
                        setStateBottomSheet(() {
                          pickedImage = img;
                        });
                      }
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: pickedImage != null
                          ? const Center(child: Text('Foto berhasil dipilih', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)))
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.grey),
                                Text('Tap untuk upload foto', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: isSubmitting 
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF14824C)))
                      : ElevatedButton(
                      onPressed: () async {
                        if (reasonController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi alasan pengembalian', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                          return;
                        }
                        if (pickedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap sertakan foto bukti', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                          return;
                        }
                        
                        setStateBottomSheet(() {
                          isSubmitting = true;
                        });
                        
                        try {
                          final bytes = await pickedImage!.readAsBytes();
                          bool success = await AppState().submitReturnRequest(orderId, reasonController.text.trim(), bytes);
                          
                          if (success) {
                            Navigator.pop(context); // Tutup bottom sheet jika sukses
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengajuan pengembalian berhasil dikirim.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim pengajuan.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                            setStateBottomSheet(() {
                              isSubmitting = false;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
                          setStateBottomSheet(() {
                            isSubmitting = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff008f4c)),
                      child: const Text('Kirim Pengajuan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPesananPage(
              title: widget.title,
              orderId: widget.orderId,
              image: widget.image,
              itemName: widget.itemName,
              qty: widget.qty,
              price: widget.price,
              total: widget.total,
              status: widget.status,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Pesanan ',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                widget.orderId,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xff008f4c),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.status.toLowerCase().contains('ditolak') || widget.status.toLowerCase().contains('batal') ? Colors.red.shade100 : (widget.status.toLowerCase().contains('disetujui') || widget.status.toLowerCase() == 'selesai' ? Colors.green.shade100 : Colors.orange.shade100),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: widget.status.toLowerCase().contains('ditolak') || widget.status.toLowerCase().contains('batal') ? Colors.red : (widget.status.toLowerCase().contains('disetujui') || widget.status.toLowerCase() == 'selesai' ? Colors.green.shade800 : Colors.orange.shade800),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.image,
                width: 38,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 38,
                  height: 45,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.itemName, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(widget.qty, style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Text(widget.price, style: const TextStyle(fontSize: 10)),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Total Pesanan : ', style: TextStyle(fontSize: 10)),
              Text(
                widget.total,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...widget.buttons.map(
                  (buttonText) => OutlinedButton(
                    onPressed: () {
                      if (buttonText == 'Detail Pesanan' || buttonText == 'Bayar Sekarang') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPesananPage(
                              title: widget.title,
                              orderId: widget.orderId,
                              image: widget.image,
                              itemName: widget.itemName,
                              qty: widget.qty,
                              price: widget.price,
                              total: widget.total,
                              status: widget.status,
                            ),
                          ),
                        );
                      } else if (buttonText == 'Hubungi Penjual') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChatPage()),
                        );
                      } else if (buttonText == 'Ajukan Pengembalian') {
                        _showReturnDialog(context, widget.orderId);
                      } else if (buttonText == 'Pembatalan') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Batalkan Pesanan'),
                            content: const Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Tidak', style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  AppState().cancelOrder(widget.orderId);
                                  if (widget.onCancel != null) {
                                    widget.onCancel!();
                                  }
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pesanan berhasil dibatalkan')),
                                  );
                                },
                                child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(105, 32),
                      side: const BorderSide(color: Color(0xff008f4c)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

              if (widget.showRating)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      child: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        size: 22,
                        color: index < rating ? Colors.amber : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
