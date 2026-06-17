import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_conversation_page.dart';
import '../../services/chat_service.dart';
import '../../services/app_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ChatService _chatService = ChatService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar with back arrow and FLOMART logo
            _buildAppBar(),
            // "Semua Chat" header with count
            _buildChatHeader(),
            // Search bar
            _buildSearchBar(),
            const SizedBox(height: 8),
            // Chat list
            Expanded(
              child: _buildChatList(),
            ),
          ],
        ),
      ),
    );
  }

  // ============ APP BAR ============
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(width: 8),
          // FLOMART Logo
          Image.asset(
            'assets/img/system/LogoFlomart.png',
            height: 70,
          ),
        ],
      ),
    );
  }

  // ============ CHAT HEADER ============
  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Semua Chat',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
          Text(
            '1', // Karena hanya ada 1 toko
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }

  // ============ SEARCH BAR ============
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF2E7D32),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Green search icon circle
            Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
            // Text field
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF222222),
                ),
                decoration: InputDecoration(
                  hintText: 'Ketik Pencarianmu',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFAAAAAA),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ CHAT LIST ============
  Widget _buildChatList() {
    final buyerId = AppState().userId;
    if (buyerId == null) {
      return const Center(child: Text('Silakan login terlebih dahulu.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _chatService.getBuyerChatRoom(buyerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF14824C)));
        }

        final data = snapshot.data?.data() as Map<String, dynamic>?;
        
        // Selalu tampilkan Flomart CS meskipun belum ada chat
        String lastMsg = data?['lastMessage'] ?? 'Halo, ada yang bisa kami bantu?';
        String timeStr = _chatService.formatTime(data?['lastMessageTime'] as Timestamp?);
        bool isNew = data?['isNewForBuyer'] ?? false;
        
        final chatInfo = {
          'name': 'Flomart CS',
          'message': lastMsg,
          'time': timeStr,
          'avatar': 'assets/img/system/LogoFlomart.png',
          'isNew': isNew,
        };

        if (_searchQuery.isNotEmpty && !chatInfo['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) && !chatInfo['message'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
           return const SizedBox.shrink();
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
             _buildChatItem(chatInfo),
          ],
        );
      },
    );
  }

  // ============ CHAT ITEM ============
  Widget _buildChatItem(Map<String, dynamic> chat) {
    final isNew = chat['isNew'] == true;
    return InkWell(
      onTap: () {
        final buyerId = AppState().userId;
        if (buyerId != null) {
          _chatService.markAsRead(buyerId, false);
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationPage(
              contactName: chat['name'],
              contactAvatar: chat['avatar'],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Profile avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
                image: DecorationImage(
                  image: AssetImage(chat['avatar']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name and message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name']!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat['message']!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isNew ? const Color(0xFF222222) : const Color(0xFF888888),
                      fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Time
            Text(
              chat['time']!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: isNew ? const Color(0xFF2E7D32) : const Color(0xFF999999),
                fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
