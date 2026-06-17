import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/chat_service.dart';
import '../../services/app_state.dart';

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
  final ChatService _chatService = ChatService();
  String get _chatRoomId => AppState().userId ?? 'buyer_id';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await _chatService.sendMessage(
      _chatRoomId,
      text,
      _chatRoomId,
      AppState().userName ?? 'Pembeli',
      false, // isSeller = false
      buyerAvatar: AppState().userAvatar,
    );
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
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getChatMessages(_chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF14824C)));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Terjadi kesalahan'));
        }

        final messages = snapshot.data?.docs ?? [];

        // Scroll to bottom when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msgData = messages[index].data() as Map<String, dynamic>;
            final bool isMe = msgData['isSeller'] == false;
            final timeStr = _chatService.formatTime(msgData['timestamp'] as Timestamp?);
            
            final msg = {
              'isMe': isMe,
              'text': msgData['text'] ?? '',
              'time': timeStr,
            };
            
            return _buildMessageBubble(msg);
          },
        );
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

  // Removed _buildMenuBubble as it's no longer used for dynamic DB chat

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
