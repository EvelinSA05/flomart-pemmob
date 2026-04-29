import 'package:flutter/material.dart';
import 'dart:ui';

class DataSellerPage extends StatefulWidget {
  const DataSellerPage({super.key});

  @override
  State<DataSellerPage> createState() => _DataSellerPageState();
}

class _DataSellerPageState extends State<DataSellerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showPenjualan = true;
  bool _showPengunjung = true;

  final List<String> _months = [
    'Jan\n2025', 'Feb', 'Mar', 'April', 'Mei', 'Jun', 
    'Jul', 'Agust', 'Sept', 'Okt', 'Nov', 'Des'
  ];

  final List<double> _dataPenjualan = [0, 0, 0, 0.2, 0.3, 0.25, 0.2, 0.15, 0.3, 0.5, 0.65, 0.85];
  final List<double> _dataPengunjung = [0, 0, 0, 0.1, 0.4, 0.7, 0.3, 0.3, 0.3, 0.15, 0.65, 0.9];

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
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            _buildCards(),
            _buildChartHeader(),
            _buildChart(),
            const SizedBox(height: 40),
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
          const SizedBox(width: 8),
          const Text('Data', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/chat-list-seller'),
          icon: const Icon(Icons.chat_bubble, color: Color(0xFF14824C)),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.home, color: Color(0xFF14824C)),
        ),
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
          _buildDrawerItem(Icons.store, 'Toko', onTap: () {
            Navigator.pushReplacementNamed(context, '/dashboard-seller');
          }),
          _buildDrawerItem(Icons.grid_view_rounded, 'Produk', onTap: () {
            Navigator.pushReplacementNamed(context, '/produk-saya');
          }),
          _buildDrawerItem(Icons.inventory_2_rounded, 'Pesanan & Pengiriman', onTap: () {
            Navigator.pushReplacementNamed(context, '/pesanan-seller');
          }),
          _buildDrawerItem(Icons.bar_chart_rounded, 'Data', isSelected: true),
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
    return Container(
      color: const Color(0xFFF8F7F3),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.list, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 24),
              const Text(
                'Kriteria Utama', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.trending_up, size: 20),
            label: const Text('Data Realtime', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0BF00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCards() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              title: 'Penjualan',
              value: 'Rp.00000000',
              subtitle: 'dari 5 tahun yang lalu',
              topBorderColor: const Color(0xFF14824C),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMetricCard(
              title: 'Pesanan',
              value: 'Rp.00000000',
              subtitle: 'dari 5 tahun yang lalu',
              topBorderColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String subtitle, required Color topBorderColor}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: topBorderColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 4),
                    const Icon(Icons.help_outline, size: 14, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 12),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Penjualn\ndan Total Pengunjung',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.3),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPenjualan = !_showPenjualan;
                  });
                },
                child: Row(
                  children: [
                    Container(width: 16, height: 16, decoration: BoxDecoration(color: _showPenjualan ? const Color(0xFF14824C) : Colors.grey.shade300, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('Penjualan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _showPenjualan ? const Color(0xFF14824C) : Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPengunjung = !_showPengunjung;
                  });
                },
                child: Row(
                  children: [
                    Container(width: 16, height: 16, decoration: BoxDecoration(color: _showPengunjung ? const Color(0xFFF0BF00) : Colors.grey.shade300, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text('Total Pengunjung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _showPengunjung ? Colors.black : Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      child: CustomPaint(
        painter: _ChartPainter(
          months: _months,
          dataPenjualan: _showPenjualan ? _dataPenjualan : null,
          dataPengunjung: _showPengunjung ? _dataPengunjung : null,
        ),
        child: Container(),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<String> months;
  final List<double>? dataPenjualan;
  final List<double>? dataPengunjung;

  _ChartPainter({
    required this.months,
    this.dataPenjualan,
    this.dataPengunjung,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final paintGrid = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    int numGridLines = 4;
    double gridSpacing = height / numGridLines;
    for (int i = 0; i <= numGridLines; i++) {
      double y = i * gridSpacing;
      canvas.drawLine(Offset(0, y), Offset(width, y), paintGrid);
    }

    // Draw x-axis labels and tick marks
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    double xSpacing = width / (months.length - 1);

    for (int i = 0; i < months.length; i++) {
      double x = i * xSpacing;
      
      // Tick mark
      canvas.drawLine(Offset(x, height), Offset(x, height + 5), paintGrid);

      // Label
      textPainter.text = TextSpan(
        text: months[i],
        style: const TextStyle(color: Colors.grey, fontSize: 10, height: 1.2),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, height + 8),
      );
    }

    // Function to draw line
    void drawDataLine(List<double> data, Color color) {
      final paintLine = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final path = Path();
      for (int i = 0; i < data.length; i++) {
        double x = i * xSpacing;
        // Data is 0.0 to 1.0, map to height
        double y = height - (data[i] * height);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paintLine);
    }

    if (dataPenjualan != null) {
      drawDataLine(dataPenjualan!, const Color(0xFF14824C));
    }
    if (dataPengunjung != null) {
      drawDataLine(dataPengunjung!, const Color(0xFFF0BF00));
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.dataPenjualan != dataPenjualan || 
           oldDelegate.dataPengunjung != dataPengunjung;
  }
}
