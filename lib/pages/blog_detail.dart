import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key});

  static const Color backgroundColor = Color(0xFFF4F2ED);
  static const Color primaryGreen = Color(0xFF14824C);
  static const Color textColor = Color(0xFF181818);
  static const Color lineColor = Color(0xFFD8D4CA);

  static const String headerLogoAsset =
      'assets/img/system/LogoFlomart.png';
  static const String backButtonAsset =
      'assets/img/system/back.png';

  static const String heroImage =
      'assets/img/konten_blog/fotoMulaiJualan1.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1, thickness: 1, color: lineColor),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ================= TITLE =================
                    const Center(
                      child: Text(
                        'Peningkatan Aktivitas\nUMKM oleh FLOMART',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ================= META =================
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Daniel Ang',
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ', 12 Desember 2025, ',
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Surabaya',
                              style: TextStyle(
                                color: primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ================= IMAGE =================
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        heroImage,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            height: 300,
                            color: const Color(0xFFEAE7E0),
                            alignment: Alignment.center,
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ================= CONTENT =================
                    const Text(
                      'FLOMART hadir sebagai platform e-commerce berbasis tanaman yang bertujuan mendukung pertumbuhan UMKM lokal di sektor pertanian dan hortikultura. Melalui digitalisasi proses penjualan, FLOMART membantu pelaku usaha kecil untuk menjangkau pasar yang lebih luas secara efisien dan berkelanjutan.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Peran FLOMART dalam Digitalisasi UMKM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'FLOMART berperan sebagai jembatan antara pelaku UMKM di bidang tanaman dengan konsumen di era digital. Melalui platform e-commerce yang terintegrasi, FLOMART membantu UMKM untuk bertransformasi dari sistem penjualan konvensional menuju penjualan berbasis digital yang lebih efektif dan efisien. Proses pendaftaran yang sederhana memungkinkan pelaku usaha lokal untuk mulai memasarkan produknya tanpa hambatan teknis yang kompleks.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Platform FLOMART menyediakan berbagai fitur pendukung seperti pengelolaan katalog produk, pengaturan harga, manajemen stok, hingga sistem pemesanan otomatis. Dengan adanya fitur-fitur tersebut, UMKM dapat mengelola bisnisnya secara mandiri dan profesional, meskipun dengan keterbatasan sumber daya. Hal ini membantu pelaku usaha untuk lebih fokus pada kualitas produk dan pelayanan kepada pelanggan.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Selain itu, FLOMART mendukung UMKM dalam meningkatkan visibilitas produk melalui tampilan yang menarik dan sistem pencarian yang terstruktur. Produk tanaman lokal menjadi lebih mudah ditemukan oleh konsumen berdasarkan kategori, kebutuhan tanaman, maupun lokasi penjual. Dengan demikian, peluang terjadinya transaksi menjadi lebih besar dibandingkan dengan metode penjualan tradisional.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Dampak terhadap Peningkatan Penjualan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Sejak bergabung dengan FLOMART, banyak UMKM mengalami peningkatan penjualan yang signifikan. Jangkauan pasar yang lebih luas memungkinkan produk lokal dikenal oleh konsumen dari berbagai daerah.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Kemudahan transaksi, sistem pembayaran digital, serta proses pengiriman yang terstruktur memberikan pengalaman belanja yang lebih nyaman bagi konsumen dan meningkatkan kepercayaan terhadap produk UMKM.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Dukungan Berkelanjutan bagi UMKM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'FLOMART tidak hanya berfokus pada transaksi, tetapi juga pada pemberdayaan UMKM secara berkelanjutan. Program edukasi, pendampingan digital, dan kampanye gaya hidup hijau menjadi bagian dari ekosistem FLOMART.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Melalui pendekatan ini, FLOMART berkomitmen untuk menciptakan pertumbuhan ekonomi yang seimbang antara keuntungan bisnis, kesejahteraan pelaku usaha, dan kelestarian lingkungan.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: textColor,
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

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              backButtonAsset,
              width: 22,
              height: 22,
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.arrow_back_ios_new_rounded);
              },
            ),
          ),
          const SizedBox(width: 14),
          Image.asset(
            headerLogoAsset,
            height: 26,
            errorBuilder: (_, __, ___) {
              return const Text(
                'FLOMART',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}