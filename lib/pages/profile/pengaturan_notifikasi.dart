import 'package:flutter/material.dart';

class PengaturanNotifikasiPage extends StatefulWidget {
  const PengaturanNotifikasiPage({super.key});

  @override
  State<PengaturanNotifikasiPage> createState() =>
      _PengaturanNotifikasiPageState();
}

class _PengaturanNotifikasiPageState extends State<PengaturanNotifikasiPage> {
  bool emailKeamanan = false;
  bool emailPesanan = false;
  bool emailPromosi = false;

  bool smsKeamanan = false;
  bool smsPromosi = false;

  bool whatsappKeamanan = false;
  bool whatsappPesanan = false;
  bool whatsappPromosi = false;

  static const Color bg = Color(0xFFF4F1F1);
  static const Color green = Color(0xFF13824B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 26, 18, 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              _sectionTitle('Notifikasi Email'),
              _settingRow(
                title: 'Notifikasi Email',
                subtitle:
                    'Notifikasi tentang keamanan akun dan pengingat penting\ntidak dapat dinonaktifkan',
                value: emailKeamanan,
                onChanged: (value) {
                  setState(() {
                    emailKeamanan = value;
                  });
                },
              ),
              _settingRow(
                title: 'Status Pesanan',
                subtitle: 'Informasi terbaru dari status pesanan',
                value: emailPesanan,
                onChanged: (value) {
                  setState(() {
                    emailPesanan = value;
                  });
                },
              ),
              _settingRow(
                title: 'Promosi',
                subtitle:
                    'Informasi ekslusif tentang promo dan penawaran yang akan\ndatang',
                value: emailPromosi,
                onChanged: (value) {
                  setState(() {
                    emailPromosi = value;
                  });
                },
              ),

              const Divider(thickness: 1.2, color: Colors.black),

              _sectionTitle('Notifikasi SMS'),
              _settingRow(
                title: 'Notifikasi SMS',
                subtitle:
                    'Notifikasi tentang keamanan akun dan pengingat penting\ntidak dapat dinonaktifkan',
                value: smsKeamanan,
                onChanged: (value) {
                  setState(() {
                    smsKeamanan = value;
                  });
                },
              ),
              _settingRow(
                title: 'Promosi',
                subtitle:
                    'Informasi ekslusif tentang promo dan penawaran yang akan\ndatang',
                value: smsPromosi,
                onChanged: (value) {
                  setState(() {
                    smsPromosi = value;
                  });
                },
              ),

              const Divider(thickness: 1.2, color: Colors.black),

              _sectionTitle('Notifikasi Whatsapp'),
              _settingRow(
                title: 'Notifikasi Whatsapp',
                subtitle:
                    'Notifikasi tentang keamanan akun dan pengingat penting\ntidak dapat dinonaktifkan',
                value: whatsappKeamanan,
                onChanged: (value) {
                  setState(() {
                    whatsappKeamanan = value;
                  });
                },
              ),
              _settingRow(
                title: 'Pesanan',
                subtitle: 'Informasi terbaru dari status pesanan',
                value: whatsappPesanan,
                onChanged: (value) {
                  setState(() {
                    whatsappPesanan = value;
                  });
                },
              ),
              _settingRow(
                title: 'Promosi',
                subtitle:
                    'Informasi ekslusif tentang promo dan penawaran yang akan\ndatang',
                value: whatsappPromosi,
                onChanged: (value) {
                  setState(() {
                    whatsappPromosi = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _settingRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != 'Notifikasi Email' &&
                      title != 'Notifikasi SMS' &&
                      title != 'Notifikasi Whatsapp')
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: green,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}