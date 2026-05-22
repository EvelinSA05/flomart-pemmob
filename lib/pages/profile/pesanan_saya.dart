import 'package:flutter/material.dart';
import 'detail_pesanan.dart';

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

  final List<Map<String, dynamic>> orders = [
    {
      'status': 'Belum Bayar',
      'title': 'Bibit Ubi Ungu',
      'orderId': '24082010170KAJ',
      'image': 'assets/img/produk/ubiUngu.png',
      'itemName': 'Bibit Ubi Ungu',
      'qty': '20g 9x',
      'price': 'Rp 10.000',
      'total': 'Rp 90.000',
      'buttons': ['Pembatalan', 'Hubungi Penjual'],
      'showRating': false,
    },
    {
      'status': 'Dikemas',
      'title': 'Bibit Ubi Ungu',
      'orderId': '24082010169KAJ',
      'image': 'assets/img/produk/ubiUngu.png',
      'itemName': 'Bibit Ubi Ungu',
      'qty': '20g 1x',
      'price': 'Rp 10.000',
      'total': 'Rp 15.500',
      'buttons': ['Detail Pesanan', 'Hubungi Penjual'],
      'showRating': false,
    },
    {
      'status': 'Dikirim',
      'title': 'Bibit Wortel',
      'orderId': '24082010168KAJ',
      'image': 'assets/img/produk/Wortel.png',
      'itemName': 'Bibit Kubis',
      'qty': '20g 1x',
      'price': 'Rp 12.000',
      'total': 'Rp 17.500',
      'buttons': ['Detail Pesanan', 'Hubungi Penjual'],
      'showRating': false,
    },
    {
      'status': 'Selesai',
      'title': 'Bibit Bunga Matahari',
      'orderId': '24082010167KAJ',
      'image': 'assets/img/produk/bunga_matahari.gif',
      'itemName': 'Bibit Bunga Matahari',
      'qty': '20g 1x',
      'price': 'Rp 90.000',
      'total': 'Rp 90.000',
      'buttons': ['Beli Lagi'],
      'showRating': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = selectedTab == 0
        ? orders
        : orders.where((item) => item['status'] == tabs[selectedTab]).toList();

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

                  return OrderCard(
                    title: order['title'],
                    orderId: order['orderId'],
                    image: order['image'],
                    itemName: order['itemName'],
                    qty: order['qty'],
                    price: order['price'],
                    total: order['total'],
                    status: order['status'],
                    buttons: List<String>.from(order['buttons']),
                    showRating: order['showRating'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Divider(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.image,
                width: 38,
                height: 45,
                fit: BoxFit.cover,
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

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...widget.buttons.map(
                (buttonText) => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: OutlinedButton(
                    onPressed: () {
                      if (buttonText == 'Detail Pesanan') {
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
              ),

              if (widget.showRating) ...[
                const SizedBox(width: 14),
                Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
