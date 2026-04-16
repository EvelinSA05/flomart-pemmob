import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/flomart_bottom_nav.dart';
import '../widgets/flomart_header.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FlomartHeader(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero Banner
            SliverToBoxAdapter(child: _buildHeroBanner()),
            // Content
            SliverToBoxAdapter(child: _buildSustainableSection()),
            SliverToBoxAdapter(child: _buildLatarBelakangSection()),
            SliverToBoxAdapter(child: _buildVisiSection()),
            SliverToBoxAdapter(child: _buildMissionSection()),
            SliverToBoxAdapter(child: _buildBenihTerbaikSection()),
            SliverToBoxAdapter(child: _buildCTASection()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
      bottomNavigationBar: const FlomartBottomNav(currentTab: FlomartTab.about),
    );
  }

  // ============ APP BAR ============
  // ============ HERO BANNER ============
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFFF0F7EE)),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/system/BannerBg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content overlay
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                // Tree icon in circle
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.park_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'About Us',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Home / About Us',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 12),
                // Decorative dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(6, Colors.white.withValues(alpha: 0.4)),
                    const SizedBox(width: 6),
                    _dot(8, Colors.white),
                    const SizedBox(width: 6),
                    _dot(6, Colors.white.withValues(alpha: 0.4)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ============ SUSTAINABLE SECTION ============
  Widget _buildSustainableSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sustainable Plant ',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF222222),
                  ),
                ),
                TextSpan(
                  text: 'Marketplace',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pasar Tanaman Berkelanjutan',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  // ============ LATAR BELAKANG ============
  Widget _buildLatarBelakangSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD5E8D5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latar Belakang Flomart',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text content
              Expanded(
                flex: 3,
                child: Text(
                  'FLOMART hadir sebagai solusi e-commerce yang mempertemukan penjual dan pembeli tanaman dalam satu platform digital. Meningkatnya minat masyarakat terhadap gaya hidup hijau mendorong kebutuhan akan marketplace tanaman yang terpercaya, mudah digunakan, dan ramah lingkungan. FLOMART dirancang untuk mendukung pertumbuhan bisnis tanaman sekaligus menjaga keberlanjutan lingkungan.',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: const Color(0xFF555555),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Image
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/img/konten_blog/Konten1.jpg',
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============ VISI SECTION ============
  Widget _buildVisiSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Column(
        children: [
          Text(
            'Visi Flomart',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBF8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0EFE0)),
            ),
            child: Text(
              '" Menjadi platform e-commerce tanaman yang mendukung gaya hidup hijau dan pertumbuhan usaha berkelanjutan."',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF444444),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ MISSION SECTION ============
  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Text(
            'Mission Flomart',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _missionCard(
                icon: Icons.security_outlined,
                title: 'Keamanan',
                description:
                    'Menyediakan platform e-commerce tanaman yang mudah, aman, dan terpercaya.',
                iconColor: const Color(0xFFE53935),
                borderColor: const Color(0xFFE53935), // Red box
              ),
              const SizedBox(width: 8),
              _missionCard(
                icon: Icons.handshake_outlined,
                title: 'Pemberdayaan',
                description:
                    'Mendukung penjual tanaman lokal untuk menjangkau pasar yang lebih luas.',
                iconColor: const Color(0xFFE8B931),
                borderColor: const Color(0xFFE8B931), // Yellow box
              ),
              const SizedBox(width: 8),
              _missionCard(
                icon: Icons.eco_outlined,
                title: 'Keberlanjutan',
                description:
                    'Mendorong kesadaran masyarakat terhadap pentingnya gaya hidup ramah lingkungan.',
                iconColor: const Color(0xFF2E7D32),
                borderColor: const Color(0xFF2E7D32), // Green box
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _missionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Circular icon with white background
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: iconColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 8,
                color: Colors.white.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ BENIH TERBAIK SECTION ============
  Widget _buildBenihTerbaikSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Kita Menyediakan Kamu\nBenih Yang Terbaik',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _benihCard(
                iconAsset: 'assets/img/system/logoChat.png',
                title: 'Benih Tepat Guna',
                description:
                    'Bibit tanaman sesuai kebutuhan untuk hasil\nyang optimal',
              ),
              const SizedBox(width: 12),
              _benihCard(
                iconAsset: 'assets/img/system/logo_logistik.png',
                title: 'Pengiriman Aman',
                description: 'Pengiriman aman menjaga kualitas\ntanaman',
              ),
              const SizedBox(width: 12),
              _benihCard(
                iconAsset: 'assets/img/system/safety.png',
                title: 'Kualitas Terjamin',
                description: 'Produk tanaman berkualitas dan\nterpercaya',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _benihCard({
    required String iconAsset,
    required String title,
    required String description,
  }) {
    return Expanded(
      child: Column(
        children: [
          // Circle with icon image from assets
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: 24,
                height: 24,
                color: const Color(0xFF2E7D32),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: const Color(0xFF777777),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============ CTA SECTION ============
  Widget _buildCTASection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image from asset
            Positioned.fill(
              child: Image.asset(
                'assets/img/konten_blog/Konten13.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Left text
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Belanja Pintar\n',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                              ),
                              TextSpan(
                                text: 'untuk Masa Depan\nyang Lebih ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                              ),
                              TextSpan(
                                text: 'Hijau',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mulai jual beli tanaman dengan mudah di FLOMART. Gabung sekarang dan dukung marketplace tanaman yang ramah lingkungan.',
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            color: const Color(0xFF555555),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Right buttons
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Register button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8B931),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                            ),
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8B931),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ BOTTOM NAV BAR ============
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navBarItem(Icons.home_outlined, 'Beranda', 0),
              _navBarItem(Icons.store_outlined, 'Toko', 1),
              _navBarItemCenter(Icons.add_circle, 'Mulai Berjualan', 2),
              _navBarItem(Icons.article_outlined, 'Blog', 3),
              _navBarItem(Icons.info_outline, 'Tentang Kami', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBarItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? const Color(0xFF2E7D32)
                : const Color(0xFF999999),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBarItemCenter(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_outlined,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }
}
