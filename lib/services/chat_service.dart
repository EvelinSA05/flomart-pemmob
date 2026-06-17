import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Dapatkan daftar chat (semua pembeli) untuk seller
  Stream<QuerySnapshot> getSellerChatList() {
    return _firestore
        .collection('chats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Dapatkan pesan dari chat room (id buyer = chatRoomId)
  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Dapatkan detail chat room untuk buyer
  Stream<DocumentSnapshot> getBuyerChatRoom(String buyerId) {
    return _firestore.collection('chats').doc(buyerId).snapshots();
  }

  // Kirim pesan
  Future<void> sendMessage(String chatRoomId, String text, String senderId, String senderName, bool isSeller, {String? buyerAvatar}) async {
    final timestamp = FieldValue.serverTimestamp();

    final chatDoc = _firestore.collection('chats').doc(chatRoomId);
    final docSnapshot = await chatDoc.get();

    final updateData = <String, dynamic>{
      'lastMessage': text,
      'lastMessageTime': timestamp,
      'isNewForSeller': !isSeller,
      'isNewForBuyer': isSeller,
    };
    
    if (!isSeller) {
      updateData['buyerName'] = senderName;
      if (buyerAvatar != null) {
        updateData['buyerAvatar'] = buyerAvatar;
      }
    }

    if (!docSnapshot.exists) {
      updateData['buyerId'] = chatRoomId;
      if (isSeller) {
        updateData['buyerName'] = 'Pembeli';
      }
      await chatDoc.set(updateData);
    } else {
      await chatDoc.update(updateData);
    }

    await chatDoc.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': timestamp,
      'isSeller': isSeller,
    });
  }

  // Tandai pesan sudah dibaca
  Future<void> markAsRead(String chatRoomId, bool isSeller) async {
    final chatDoc = _firestore.collection('chats').doc(chatRoomId);
    final docSnapshot = await chatDoc.get();
    if (docSnapshot.exists) {
      if (isSeller) {
        await chatDoc.update({'isNewForSeller': false});
      } else {
        await chatDoc.update({'isNewForBuyer': false});
      }
    }
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return DateFormat('HH:mm').format(date);
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
