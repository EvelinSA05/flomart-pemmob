import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final List<CartItem> _cartItems = [];
  final List<AppNotification> _notifications = [];
  bool _isLoggedIn = false;

  int? _userId;
  String? _userName;
  String? _userEmail;
  String? _userRole;

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  bool get isLoggedIn => _isLoggedIn;
  
  int? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userRole => _userRole;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> loginUser(Map<String, dynamic> userData) async {
    _isLoggedIn = true;
    _userId = int.tryParse(userData['id_user'].toString());
    _userName = userData['nama'];
    _userEmail = userData['email'];
    _userRole = userData['role'];
    
    await fetchCart();
    notifyListeners();
  }

  Future<void> fetchCart() async {
    if (_userId == null) return;
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/flomart_api/get_keranjang.php?id_user=$_userId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _cartItems.clear();
          for (var item in data['data']) {
            _cartItems.add(CartItem(
              name: item['nama_produk'],
              price: 'Rp' + item['harga'].toString(),
              imagePath: item['gambar'],
              size: 'Normal', // Default or parse from DB if available
              quantity: int.tryParse(item['jumlah'].toString()) ?? 1,
            ));
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('Failed to fetch cart: $e');
    }
  }
  
  void logout() {
    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    clearCart();
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    if (_userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://127.0.0.1/flomart_api/tambah_keranjang.php'),
          body: {
            'id_user': _userId.toString(),
            'nama_produk': item.name,
            'jumlah': item.quantity.toString(),
          },
        );
        final data = json.decode(response.body);
        if (data['status'] != 'success') {
          print('Failed to add to DB: ${data['message']}');
        }
      } catch (e) {
        print('Error adding to DB: $e');
      }
    }

    // Check if item already exists in cart
    int index = _cartItems.indexWhere((i) => i.name == item.name && i.size == item.size);
    if (index != -1) {
      _cartItems[index].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    
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
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int newQty) {
    if (newQty > 0) {
      _cartItems[index].quantity = newQty;
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
}
