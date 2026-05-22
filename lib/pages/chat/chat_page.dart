import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_conversation_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample chat data
  final List<Map<String, String>> _chatList = [
    {
      'name': 'Kaka Petani',
      'message': '👋 Halo, selamat datang di Chat Flomart!',
      'time': '09:45pm',
      'avatar': 'assets/img/system/pengguna_login.png',
    },
    {
      'name': 'Tian Petani',
      'message': '👋 Halo, selamat datang di Chat Flomart!',
      'time': '09:45pm',
      'avatar': 'assets/img/system/pengguna_login.png',
    },
  ];

  List<Map<String, String>> get _filteredChatList {
    if (_searchQuery.isEmpty) return _chatList;
    return _chatList
        .where((chat) =>
            chat['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            chat['message']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

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
            '${_filteredChatList.length}',
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
    final chats = _filteredChatList;

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada chat ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return _buildChatItem(chats[index]);
      },
    );
  }

  // ============ CHAT ITEM ============
  Widget _buildChatItem(Map<String, String> chat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationPage(
              contactName: chat['name']!,
              contactAvatar: chat['avatar']!,
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
                      color: const Color(0xFF888888),
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
                color: const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
