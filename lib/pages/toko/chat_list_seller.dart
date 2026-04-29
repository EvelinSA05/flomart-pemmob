import 'package:flutter/material.dart';

class ChatListSellerPage extends StatefulWidget {
  const ChatListSellerPage({super.key});

  @override
  State<ChatListSellerPage> createState() => _ChatListSellerPageState();
}

class _ChatListSellerPageState extends State<ChatListSellerPage> {
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Marina',
      'message': 'Halo kak, selamat datang di Neola Floris...',
      'date': '12/04/2025',
      'image': 'assets/img/user/user1.jpg',
      'isNew': true,
    },
    {
      'name': 'Ekolim',
      'message': 'Sama - sama kak,',
      'date': '11/04/2025',
      'image': 'assets/img/user/user2.jpg',
      'isNew': false,
    },
    {
      'name': 'Siti Nurbayah',
      'message': 'Baik kak, terimakasih sudah memesan...',
      'date': '10/04/2025',
      'image': 'assets/img/user/user3.jpg',
      'isNew': false,
    },
    {
      'name': 'Cintia',
      'message': 'Baik kak bisa ditunggu paket Benih nya ya',
      'date': '10/04/2025',
      'image': 'assets/img/user/user4.jpg',
      'isNew': false,
    },
    {
      'name': 'Budi Harianto',
      'message': 'Terimakasih Banyak kak',
      'date': '09/04/2025',
      'image': 'assets/img/user/user5.jpg',
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Semua Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${_chats.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF14824C)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF14824C),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ketik Pencarianmu',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _chats.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                final chat = _chats[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: AssetImage(chat['image']),
                    onBackgroundImageError: (_, __) {},
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        chat['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: chat['isNew'] ? const Color(0xFF14824C) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      chat['message'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  onTap: () {
                    if (chat['name'] == 'Marina') {
                      Navigator.pushNamed(context, '/chat-detail-seller');
                    }
                  },
                );
              },
            ),
          ),
        ],
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
          const Text('Chat', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.store, color: Color(0xFF14824C))),
        IconButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), icon: const Icon(Icons.home, color: Color(0xFF14824C))),
        const SizedBox(width: 8),
      ],
    );
  }
}
