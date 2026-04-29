import 'package:flutter/material.dart';

class ChatDetailSellerPage extends StatefulWidget {
  const ChatDetailSellerPage({super.key});

  @override
  State<ChatDetailSellerPage> createState() => _ChatDetailSellerPageState();
}

class _ChatDetailSellerPageState extends State<ChatDetailSellerPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': false,
      'text': 'Halo Kak, Apakah benih ini masih tersedia ya?',
      'time': '09.00',
    },
    {
      'isMe': false,
      'isProduct': true,
      'productName': 'Benih Kubis',
      'productBrand': 'Vida Verda',
      'productPrice': 'Rp 10.000',
      'productImage': 'assets/img/produk/kubis.jpg',
      'time': '09.00',
    },
    {
      'isMe': true,
      'text': 'Halo kak, Selamat datang di Neola Florist ! Ada yang bisa kami bantu?',
      'time': '09.01',
    },
    {
      'isMe': true,
      'text': 'Masih kak, untuk benih kubis masih ada 10 pcs',
      'time': '09.02',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'isMe': true,
          'text': _messageController.text.trim(),
          'time': '09.05', // dummy time
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text('Today', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['isProduct'] == true) {
                  return _buildProductMessage(msg);
                }
                return _buildTextMessage(msg);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF14824C),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: const AssetImage('assets/img/user/user1.jpg'),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Marina', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Text('online 2 menit yang lalu', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage(Map<String, dynamic> msg) {
    final isMe = msg['isMe'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
              child: Text('${msg['time']} me', style: const TextStyle(fontSize: 10, color: Colors.black)),
            ),
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
              child: Row(
                children: [
                  CircleAvatar(radius: 10, backgroundImage: const AssetImage('assets/img/user/user1.jpg'), onBackgroundImageError: (_,__) {}),
                  const SizedBox(width: 8),
                  const Text('Marina', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(msg['time'], style: const TextStyle(fontSize: 10, color: Colors.black)),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Text(msg['text'], style: const TextStyle(fontSize: 13, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductMessage(Map<String, dynamic> msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(msg['productImage'], width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width:40, height:40, color:Colors.grey.shade300)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg['productName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(msg['productBrand'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(msg['productPrice'], style: const TextStyle(color: Color(0xFF14824C), fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: const Color(0xFFF4F4F4),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF14824C)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image_outlined, color: Colors.grey),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ketik pesan',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF14824C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
