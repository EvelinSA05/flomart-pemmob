import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/chat_service.dart';
import 'chat_detail_seller.dart';

class ChatListSellerPage extends StatefulWidget {
  const ChatListSellerPage({super.key});

  @override
  State<ChatListSellerPage> createState() => _ChatListSellerPageState();
}

class _ChatListSellerPageState extends State<ChatListSellerPage> {
  final ChatService _chatService = ChatService();
  String _searchQuery = '';
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = _chatService.getSellerChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF14824C)));
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          final allChats = snapshot.data?.docs ?? [];
          final filteredChats = allChats.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['buyerName'] ?? '').toString().toLowerCase();
            return name.contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Semua Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${filteredChats.length}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
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
          if (filteredChats.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Tidak ada pesan.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: filteredChats.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final chatDoc = filteredChats[index];
                  final chatData = chatDoc.data() as Map<String, dynamic>;
                  final isNew = chatData['isNewForSeller'] ?? false;
                  final timeStr = _chatService.formatTime(chatData['lastMessageTime'] as Timestamp?);
                  final avatarBase64 = chatData['buyerAvatar'];
                  
                  Widget avatarWidget;
                  if (avatarBase64 != null && avatarBase64.startsWith('data:image')) {
                    try {
                      final b64 = avatarBase64.split(',').last;
                      avatarWidget = Image.memory(base64Decode(b64), fit: BoxFit.cover, width: 56, height: 56);
                    } catch (e) {
                      avatarWidget = Image.asset('assets/img/system/pengguna_login.png', fit: BoxFit.cover, width: 56, height: 56);
                    }
                  } else {
                    avatarWidget = Image.asset('assets/img/system/pengguna_login.png', fit: BoxFit.cover, width: 56, height: 56);
                  }
                  
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: ClipOval(
                      child: avatarWidget,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chatData['buyerName'] ?? 'Pembeli', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isNew ? const Color(0xFF14824C) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        chatData['lastMessage'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isNew ? Colors.black87 : Colors.grey,
                          fontSize: 13,
                          fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    onTap: () {
                      _chatService.markAsRead(chatDoc.id, true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailSellerPage(
                            chatRoomId: chatDoc.id,
                            buyerName: chatData['buyerName'] ?? 'Pembeli',
                            buyerAvatar: avatarBase64,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      );
    },
  ),
);
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, '/dashboard-seller');
          }
        },
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/img/system/LogoFlomart.png',
            height: 24,
            errorBuilder: (_, _, _) => const Text(
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
