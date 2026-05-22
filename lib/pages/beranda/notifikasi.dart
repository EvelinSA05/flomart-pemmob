import 'package:flutter/material.dart';
import '../../services/app_state.dart';


class NotificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> pesananSaya;

  const NotificationPage({
    super.key,
    this.pesananSaya = const [],
  });

  String _getString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  String getTitle(String status) {
    switch (status) {
      case 'Belum Bayar':
        return 'Selesaikan Pembayaranmu';
      case 'Dikemas':
        return 'Pesanan sedang Dikemas';
      case 'Dikirim':
        return 'Pesanan sedang Dikirim';
      case 'Selesai':
        return 'Pesanan Selesai';
      default:
        return 'Notifikasi Pesanan';
    }
  }

  String getDesc(Map<String, dynamic> pesanan) {
    final status = _getString(pesanan, ['status']);
    final orderId = _getString(pesanan, ['orderId', 'idPesanan', 'id']);
    final total = _getString(pesanan, ['total', 'totalHarga', 'harga']);

    switch (status) {
      case 'Belum Bayar':
        return 'Hai Agung pesananmu sebesar $total belum dibayar. Segera selesaikan pembayaranmu.';
      case 'Dikemas':
        return 'Pesanan $orderId sedang dikemas. Penjual sedang menyiapkan pesanan kamu dan akan segera dikirim.';
      case 'Dikirim':
        return 'Pesanan $orderId telah dikirim. Silakan cek rincian pengiriman pesananmu.';
      case 'Selesai':
        return 'Pesanan dengan total $total telah berhasil diselesaikan. Jangan lupa beri ulasan produkmu!';
      default:
        return 'Ada update terbaru untuk pesanan kamu.';
    }
  }

  String getImage(Map<String, dynamic> pesanan) {
    return _getString(pesanan, [
      'image',
      'gambar',
      'productImage',
      'foto',
      'asset',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f3f3),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 74,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/img/system/back.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Icon(Icons.arrow_back, size: 28);
                      },
                    ),
                  ),
                  const SizedBox(width: 22),
                  const Text(
                    'Notifikasi Saya',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListenableBuilder(
                listenable: AppState(),
                builder: (context, child) {
                  final notifications = AppState().notifications;
                  return notifications.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada notifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(22, 36, 22, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: notifications.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 24,
                                  thickness: 1,
                                  indent: 24,
                                  endIndent: 24,
                                  color: Color(0xffbdbdbd),
                                );
                              },
                              itemBuilder: (context, index) {
                                final n = notifications[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      n.imagePath.isEmpty
                                          ? Container(
                                              width: 60,
                                              height: 60,
                                              color: const Color(0xffeeeeee),
                                              child: const Icon(Icons.image),
                                            )
                                          : Image.asset(
                                              n.imagePath,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) {
                                                return Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: const Color(0xffeeeeee),
                                                  child: const Icon(Icons.image),
                                                );
                                              },
                                            ),

                                      const SizedBox(width: 14),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              n.title,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              n.description,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                height: 1.3,
                                                color: Color(0xff4a4a4a),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffead77a),
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                        ),
                                        child: const Text(
                                          'Tampilkan Rincian',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}