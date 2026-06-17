import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class CartItem {
  final String name;
  final String price;
  final String imagePath;
  final String size;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.size,
    this.quantity = 1,
  });
}

class AppNotification {
  final String title;
  final String description;
  final String imagePath;
  final String status;
  final String orderId;
  final String total;

  AppNotification({
    required this.title,
    required this.description,
    required this.imagePath,
    this.status = 'Notifikasi',
    this.orderId = '-',
    this.total = '-',
  });
}

class AppOrder {
  final String orderId;
  final String title;
  final String image;
  final String itemName;
  final String qty;
  final String price;
  final String total;
  String status;
  final List<String> buttons;
  final bool showRating;
  final String paymentMethod;

  AppOrder({
    required this.orderId,
    required this.title,
    required this.image,
    required this.itemName,
    required this.qty,
    required this.price,
    required this.total,
    this.status = 'Belum Bayar',
    this.buttons = const ['Detail Pesanan', 'Hubungi Penjual'],
    this.showRating = false,
    this.paymentMethod = 'Transfer Bank BCA',
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'title': title,
      'orderId': orderId,
      'image': image,
      'itemName': itemName,
      'qty': qty,
      'price': price,
      'total': total,
      'buttons': buttons,
      'showRating': showRating,
      'paymentMethod': paymentMethod,
    };
  }
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final List<CartItem> _cartItems = [];
  final List<AppNotification> _notifications = [];
  final List<AppOrder> _orders = [];
  bool _isLoggedIn = false;

  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userRole;
  String? _userAddress;
  String? _userAvatar;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<AppOrder> get orders => List.unmodifiable(_orders);
  bool get isLoggedIn => _isLoggedIn;
  
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;
  String? get userAddress => _userAddress;
  String? get userAvatar => _userAvatar;

  void setUserAddress(String address) async {
    _userAddress = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAddress', address);
    
    // Simpan juga ke Firebase Firestore
    if (_userId != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(_userId).set({
          'address': address,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error saving address to Firebase: $e');
      }
    }
    
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> loginUser(Map<String, dynamic> userData) async {
    _cartItems.clear();
    _orders.clear();
    _notifications.clear();
    _isLoggedIn = true;
    _userId = userData['id']?.toString() ?? userData['id_user']?.toString();
    _userName = userData['nama'];
    _userEmail = userData['email'] ?? userData['kontak'];
    _userRole = userData['role'];
    
    // Coba ambil alamat dan avatar dari Firebase jika ada
    if (_userId != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
        if (doc.exists) {
          final data = doc.data()!;
          if (data.containsKey('address')) _userAddress = data['address'];
          if (data.containsKey('avatar')) _userAvatar = data['avatar'];
          if (data.containsKey('name')) _userName = data['name'];
        }
      } catch (e) {
        print('Error loading profile from Firebase: $e');
      }
    }

    // Simpan ke SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      if (_userId != null) await prefs.setString('userId', _userId!);
      if (_userName != null) await prefs.setString('userName', _userName!);
      if (_userEmail != null) await prefs.setString('userEmail', _userEmail!);
      if (_userRole != null) await prefs.setString('userRole', _userRole!);
      if (_userAddress != null) await prefs.setString('userAddress', _userAddress!);
      if (_userAvatar != null) await prefs.setString('userAvatar', _userAvatar!);
      print('DEBUG: SharedPreferences berhasil disimpan!');
    } catch (e) {
      print('ERROR SharedPreferences simpan: $e');
    }
    
    await fetchCart();
    await fetchOrders();
    notifyListeners();
  }

  Future<void> loadLoginInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      print('DEBUG: Memuat sesi login dari SharedPreferences. isLoggedIn = $_isLoggedIn');

      if (_isLoggedIn) {
        _userId = prefs.getString('userId');
        _userName = prefs.getString('userName');
        _userEmail = prefs.getString('userEmail');
        _userRole = prefs.getString('userRole');
        _userAddress = prefs.getString('userAddress');
        _userAvatar = prefs.getString('userAvatar');
        
        print('DEBUG: User ID ter-load = $_userId');
        
        await fetchCart();
        await fetchOrders();
      }
    } catch (e) {
      print('ERROR SharedPreferences muat: $e');
    }
    notifyListeners();
  }

  Future<void> fetchCart() async {
    if (_userId == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance.collection('carts').doc(_userId).get().timeout(const Duration(seconds: 5));
      _cartItems.clear();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final items = data['items'] as List<dynamic>? ?? [];
        for (var item in items) {
          _cartItems.add(CartItem(
            name: item['name'] ?? '',
            price: item['price'] ?? 'Rp0',
            imagePath: item['imagePath'] ?? '',
            size: item['size'] ?? 'Normal',
            quantity: item['quantity'] ?? 1,
          ));
        }
      }
      notifyListeners();
    } catch (e) {
      print('Failed to fetch cart from Firestore: $e');
    }
  }

  Future<void> _saveCartToFirestore() async {
    if (_userId == null) return;
    try {
      final items = _cartItems.map((item) => {
        'name': item.name,
        'price': item.price,
        'imagePath': item.imagePath,
        'size': item.size,
        'quantity': item.quantity,
      }).toList();
      await FirebaseFirestore.instance.collection('carts').doc(_userId).set({
        'items': items,
      });
    } catch (e) {
      print('Failed to save cart to Firestore: $e');
    }
  }

  Future<void> fetchOrders() async {
    if (_userId == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('id_user', isEqualTo: _userId)
          .get()
          .timeout(const Duration(seconds: 5));

      _orders.clear();
      // Sort in memory to avoid needing composite index in Firestore
      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime = a.data()['created_at'] as Timestamp?;
        final bTime = b.data()['created_at'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });

      for (var doc in docs) {
        final data = doc.data();
        
        // Handle items
        List<dynamic> items = data['items'] ?? [];
        String itemName = 'Unknown Item';
        String imagePath = 'assets/img/produk/dummy.png';
        String qty = '1x';
        String price = 'Rp 0';

        if (items.isNotEmpty) {
          if (items[0] is Map) {
             itemName = items[0]['nama_produk'] ?? itemName;
             qty = '${items[0]['qty'] ?? 1}x';
             price = 'Rp${(items[0]['harga'] ?? 0).toInt()}';
             imagePath = items[0]['gambar'] ?? imagePath;
          } else if (items[0] is String) {
             // In case items was stored as JSON string
             try {
                final decoded = json.decode(items[0]);
                itemName = decoded['nama_produk'] ?? itemName;
                qty = '${decoded['qty'] ?? 1}x';
                price = 'Rp${(decoded['harga'] ?? 0).toInt()}';
                imagePath = decoded['gambar'] ?? imagePath;
             } catch(e) {}
          }
        }

        // Format total
        double totalDouble = double.tryParse(data['total_harga'].toString()) ?? 0;
        String totalFormatted = 'Rp${totalDouble.toInt()}';

        final paymentMethod = data['metode_pembayaran'] ?? 'Transfer Bank BCA';
        _orders.add(AppOrder(
          orderId: 'FLM${doc.id}',
          title: itemName,
          image: imagePath,
          itemName: itemName,
          qty: qty,
          price: price,
          total: totalFormatted,
          status: data['status'] ?? 'Belum Bayar',
          buttons: const ['Detail Pesanan', 'Hubungi Penjual'],
          showRating: false,
          paymentMethod: paymentMethod,
        ));
      }
      notifyListeners();
    } catch (e) {
      print('Failed to fetch orders from Firestore: $e');
    }
  }
  
  void logout() async {
    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    _userAddress = null;
    _userAvatar = null;
    clearCart();
    _orders.clear();
    _notifications.clear();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    // Check if item already exists in cart
    int index = _cartItems.indexWhere((i) => i.name == item.name && i.size == item.size);
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    
    await _saveCartToFirestore();
    
    // Add notification
    addNotification(AppNotification(
      title: 'Produk Ditambahkan',
      description: '${item.name} (${item.size}) berhasil ditambahkan ke keranjang.',
      imagePath: item.imagePath,
    ));
    
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveCartToFirestore();
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    _saveCartToFirestore();
    notifyListeners();
  }

  void updateQuantity(int index, int newQty) {
    if (newQty > 0) {
      _cartItems[index].quantity = newQty;
      _saveCartToFirestore();
      notifyListeners();
    }
  }

  double get subtotal {
    double total = 0;
    for (var item in _cartItems) {
      String priceStr = item.price.replaceAll('Rp', '').replaceAll('.', '');
      double price = double.tryParse(priceStr) ?? 0;
      total += price * item.quantity;
    }
    return total;
  }

  void addOrder(AppOrder order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    // Optimistic UI update
    _orders.removeWhere((order) => order.orderId == orderId);
    notifyListeners();

    // Hapus dari database (backend)
    String rawId = orderId;
    if (rawId.startsWith('FLM')) {
      rawId = rawId.substring(3);
    }
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/flomart_api/hapus_pesanan.php'),
        body: {'id_pesanan': rawId},
      );
      final data = json.decode(response.body);
      if (data['status'] != 'success') {
        print('Gagal menghapus pesanan di database: ${data['message']}');
      }
    } catch (e) {
      print('Error membatalkan pesanan ke API: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    // Optimistic UI update
    int index = _orders.indexWhere((order) => order.orderId == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }

    String rawId = orderId;
    if (rawId.startsWith('FLM')) {
      rawId = rawId.substring(3);
    }
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/flomart_api/update_status_pesanan.php'),
        body: {
          'id_pesanan': rawId,
          'status_pesanan': newStatus,
        },
      );
      final data = json.decode(response.body);
      if (data['status'] != 'success') {
        print('Gagal memperbarui status di database: ${data['message']}');
      }
    } catch (e) {
      print('Error memperbarui status ke API: $e');
    }
  }

  Future<bool> uploadPaymentProof(String orderId, Uint8List imageBytes) async {
    String rawId = orderId;
    if (rawId.startsWith('FLM')) {
      rawId = rawId.substring(3);
    }

    try {
      // Encode image bytes ke base64 agar bisa disimpan di Firestore tanpa Firebase Storage
      String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";

      // Perbarui status pesanan di Firestore (gunakan set dengan merge: true agar tidak crash jika pesanan lama tidak ada di Firestore)
      await FirebaseFirestore.instance.collection('orders').doc(rawId).set({
        'status': 'menunggu konfirmasi',
        'bukti_pembayaran': base64Image,
      }, SetOptions(merge: true));

      // Optimistic UI update for status
      int index = _orders.indexWhere((order) => order.orderId == orderId);
      if (index != -1) {
        _orders[index].status = 'menunggu konfirmasi';
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error update status ke Firestore: $e');
      return false;
    }
  }

  Future<bool> submitReturnRequest(String orderId, String reason, Uint8List imageBytes) async {
    String rawId = orderId;
    if (rawId.startsWith('FLM')) {
      rawId = rawId.substring(3);
    }

    try {
      String base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";

      await FirebaseFirestore.instance.collection('orders').doc(rawId).set({
        'status': 'menunggu pengembalian',
        'alasan_pengembalian': reason,
        'bukti_pengembalian': base64Image,
      }, SetOptions(merge: true));

      int index = _orders.indexWhere((order) => order.orderId == orderId);
      if (index != -1) {
        _orders[index].status = 'menunggu pengembalian';
        notifyListeners();
      }
      return true;
    } catch (e) {
      print('Error ajukan pengembalian: $e');
      return false;
    }
  }

  Future<void> updateProfile({String? name, String? phone, String? dob, String? gender, String? avatarBase64}) async {
    if (name != null) _userName = name;
    if (avatarBase64 != null) _userAvatar = avatarBase64;
    
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('userName', name);
    if (avatarBase64 != null) await prefs.setString('userAvatar', avatarBase64);

    if (_userId != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(_userId).set({
          'name': ?name,
          'phone': ?phone,
          'dob': ?dob,
          'gender': ?gender,
          'avatar': ?avatarBase64,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error saving profile to Firebase: $e');
      }
    }
    notifyListeners();
  }
}
