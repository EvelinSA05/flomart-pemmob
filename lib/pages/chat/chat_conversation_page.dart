import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatConversationPage extends StatefulWidget {
  final String contactName;
  final String contactAvatar;

  const ChatConversationPage({
    super.key,
    required this.contactName,
    required this.contactAvatar,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': '👋 Halo, selamat datang di Chat Flomart!',
      'isMe': false,
      'time': '09:43',
    },
    {
      'text': 'Saya Filo, asisten virtual yang siap membantu kamu 😊',
      'isMe': false,
      'time': '09:43',
    },
    {
      'type': 'menu',
      'title': 'Kamu ingin bantuan apa hari ini?',
      'options': [
        {'id': '1', 'text': 'Tanya Produk', 'icon': '🌱'},
        {'id': '2', 'text': 'Cek Pesanan', 'icon': '📦'},
        {'id': '3', 'text': 'Info Pengiriman', 'icon': '🚚'},
        {'id': '4', 'text': 'Chat Langsung dengan Admin', 'icon': '💬'},
      ],
      'isMe': false,
      'time': '09:43',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addMessage(text, true);
    _messageController.clear();
  }

  void _addMessage(String text, bool isMe) {
    setState(() {
      _messages.add({
        'text': text,
        'isMe': isMe,
        'time': '09.43', // Hardcoded time for simplicity like in design
      });
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Handle automated responses for menu options
    if (text == '1') {
      Future.delayed(const Duration(seconds: 1), () {
        _addMessage('Tentu! Produk kami selalu ready stok dan segar. Anda ingin menanyakan detail produk yang mana? 😊', false);
      });
    } else if (text == '2') {
      Future.delayed(const Duration(seconds: 1), () {
        _addMessage('Boleh, silakan masukkan nomor pesanan Anda atau cek di halaman "Pesanan Saya" untuk status terbaru. Ada lagi yang bisa dibantu? 📦', false);
      });
    } else if (text == '3') {
      Future.delayed(const Duration(seconds: 1), () {
        _addMessage('Kami bekerja sama dengan berbagai jasa pengiriman terpercaya. Estimasi paket sampai adalah 1-3 hari tergantung lokasi Anda. 🚚', false);
      });
    } else if (text == '4') {
      Future.delayed(const Duration(seconds: 1), () {
        _addMessage('Siap 😊, Saya akan menghubungkan kamu dengan admin penjual.', false);
        Future.delayed(const Duration(seconds: 1), () {
          _addMessage('⏳ Mohon tunggu sebentar, admin akan segera membalas pesanmu.', false);
          Future.delayed(const Duration(seconds: 1), () {
            _addMessage('Halo 👋, Saya admin dari Kaka Petani.\nAda yang bisa saya bantu?', false);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Column(
        children: [
          _buildGreenAppBar(),
          Expanded(
            child: _buildChatArea(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildGreenAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 12,
        right: 16,
        bottom: 14,
      ),
      color: const Color(0xFF007B3E), // Darker green like in design
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(widget.contactAvatar),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contactName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'online',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        if (message['type'] == 'menu') {
          return _buildMenuBubble(message);
        }
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isMe = message['isMe'] as bool;
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isMe) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Row(
              children: [
                CircleAvatar(radius: 12, backgroundImage: AssetImage(widget.contactAvatar)),
                const SizedBox(width: 8),
                Text(widget.contactName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Text(message['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(message['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
                const SizedBox(width: 6),
                const Text('me', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
              ],
            ),
            child: Text(
              message['text'] ?? '',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuBubble(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Row(
            children: [
              CircleAvatar(radius: 12, backgroundImage: AssetImage(widget.contactAvatar)),
              const SizedBox(width: 8),
              Text(widget.contactName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text(message['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(message['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ... (message['options'] as List).map((opt) {
                return InkWell(
                  onTap: () => _addMessage(opt['id'], true),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Text(opt['icon'], style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(child: Text(opt['text'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                            Text(opt['id'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: 'Ketik pesan', border: InputBorder.none),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const Icon(Icons.attach_file, color: Colors.grey),
                  const SizedBox(width: 10),
                  const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              backgroundColor: const Color(0xFF007B3E),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
