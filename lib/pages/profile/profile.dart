import 'package:flutter/material.dart';
import 'ubah_profile.dart';
import 'alamat_saya.dart';
import 'ubah_password.dart';
import 'pengaturan_notifikasi.dart';
import 'pesanan_saya.dart';
import '../../services/app_state.dart';

class Product {
  final String name;
  final String price;
  final String image;
  final String rating;
  final String tag;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.tag,
  });
}

final List<Product> products = [
  Product(
    name: "Benih Kubis",
    price: "Rp10.000",
    image: "assets/img/produk/kubis.jpg",
    rating: "4.8",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Tomat",
    price: "Rp12.000",
    image: "assets/img/produk/tomat.png",
    rating: "4.5",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Strawberry",
    price: "Rp15.000",
    image: "assets/img/produk/strawberry.png",
    rating: "4.7",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Bunga Daisy",
    price: "Rp18.000",
    image: "assets/img/produk/jasmine.jpg",
    rating: "4.3",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Bunga Rose",
    price: "Rp18.000",
    image: "assets/img/produk/mawar.jpg",
    rating: "4.9",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Padi",
    price: "Rp25.000",
    image: "assets/img/produk/padi.png",
    rating: "5.0",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Jagung",
    price: "Rp25.000",
    image: "assets/img/produk/jagung.jpg",
    rating: "4.8",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Nanas",
    price: "Rp16.000",
    image: "assets/img/produk/nanas_box.png",
    rating: "4.3",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
  Product(
    name: "Benih Kuaci",
    price: "Rp20.000",
    image: "assets/img/produk/kuaci.jpg",
    rating: "4.9",
    tag: "Benih Sayur, Musim Hujan, Gambut",
  ),
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color green = Color(0xFF13824B);
  static const Color bg = Color(0xFFF4F1F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 36,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UbahProfilePage(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/img/system/pengguna_login.png'),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Agung Prasetyo",
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                Text("Alamat Toko",
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            )
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _cardPesanan(context),
            const SizedBox(height: 12),
            _cardAlamat(context),
            const SizedBox(height: 12),
            _cardPengaturan(context),
            const SizedBox(height: 20),
            _rekomendasiProduk(),
          ],
        ),
      ),
    );
  }

  // ================= PESANAN =================
  Widget _cardPesanan(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PesananSayaPage(),
                ),
              );
            },
            child: _titleRow("Pesanan Saya", "Lihat Riwayat Pesanan"),
          ),
          const Divider(
            thickness: 1.5, // ketebalan garis
            color: Colors.black, // warna garis
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: const [
                _menuIcon(Icons.account_balance_wallet, "Belum Bayar"),
                _menuIcon(Icons.inventory_2, "Dikemas"),
                _menuIcon(Icons.local_shipping, "Dikirim"),
                _menuIcon(Icons.check_circle, "Selesai"),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= ALAMAT =================
  Widget _cardAlamat(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlamatSayaPage(),
                ),
              );
            },
            child: _titleRow("Alamat Utama", "Atur Alamat"),
          ),
          const Divider(
            thickness: 1.5, // ketebalan garis
            color: Colors.black, // warna garis
          ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 171, 241, 174),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home, color: green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Agung Prasetyo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Sidokare Indah ai no 12\nSIDOARJO, KAB. SIDOARJO, JAWA TIMUR, ID, 61254",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13824B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Utama",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // ================= PENGATURAN =================
  Widget _cardPengaturan(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pengaturan Akun",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(
            thickness: 1.5,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: green),
            title: const Text(
              "Ubah Password",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UbahPasswordPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: green),
            title: const Text(
              "Atur Notifikasi",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PengaturanNotifikasiPage(),
                ),
              );
            },

            trailing: const Icon(Icons.arrow_forward_ios, size: 15),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        AppState().logout();
                        Navigator.pushNamedAndRemoveUntil(context, '/beranda', (route) => false);
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15),
          ),
        ],
      ),
    );
  }

  // ================= PRODUK =================
  Widget _rekomendasiProduk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Kamu mungkin juga suka",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = products[index];

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEAEA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                item.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            ),

                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF13824B),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        size: 8, color: Colors.yellow),
                                    Text(
                                      item.rating,
                                      style: const TextStyle(
                                          fontSize: 8, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 6,
                      color: Color(0xFF13824B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.price,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2BE00),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        Center(
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFE2BE00),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              "1",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= COMPONENT =================
  Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

  Widget _titleRow(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700, // bold
              color: Colors.black,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              action,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }
}

// ================= ICON MENU =================
class _menuIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _menuIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Icon(
              icon,
              color: const Color(0xFF13824B),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}