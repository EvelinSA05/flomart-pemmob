import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedProducts() async {
    try {
      final QuerySnapshot existingProducts = await _firestore.collection('products').get().timeout(const Duration(seconds: 5));
      
      // Jika sudah ada data, jangan di-seed lagi.
      if (existingProducts.docs.isNotEmpty) {
        print('Data products sudah ada di Firebase, skipping seeding.');
        return;
      }
    } catch (e) {
      print('FirebaseSeeder error: $e');
      return;
    }

    print('Mulai menyemai 20 data produk ke Firebase...');
    
    final List<Map<String, dynamic>> products = [
      {
        'id': 'p1', 'name': 'Benih Kubis', 'price': 10000.0, 'rating': 4.8, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/kubis.jpg',
        'desc': 'Benih Kubis berkualitas, tumbuh subur di musim hujan dan tahan hama.'
      },
      {
        'id': 'p2', 'name': 'Benih Kelengkeng', 'price': 18000.0, 'rating': 4.9, 
        'category': 'Benih Buah', 'image': 'assets/img/produk/kelengkeng.png',
        'desc': 'Benih Kelengkeng manis dengan hasil panen lebat.'
      },
      {
        'id': 'p3', 'name': 'Benih Sawi Hijau', 'price': 8000.0, 'rating': 4.6, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/15.png',
        'desc': 'Sawi hijau yang segar, mudah tumbuh di polybag.'
      },
      {
        'id': 'p4', 'name': 'Benih Jagung', 'price': 25000.0, 'rating': 4.8, 
        'category': 'Benih Pangan', 'image': 'assets/img/produk/jagung.jpg',
        'desc': 'Jagung manis unggulan, tongkol besar.'
      },
      {
        'id': 'p5', 'name': 'Benih Labu', 'price': 14000.0, 'rating': 4.5, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/labu.png',
        'desc': 'Labu madu berkualitas dengan rasa manis alami.'
      },
      {
        'id': 'p6', 'name': 'Benih Tomat', 'price': 12000.0, 'rating': 4.5, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/tomat.png',
        'desc': 'Tomat ceri merah merona, cocok untuk salad.'
      },
      {
        'id': 'p7', 'name': 'Benih Padi', 'price': 50000.0, 'rating': 4.9, 
        'category': 'Benih Pangan', 'image': 'assets/img/produk/padi.png',
        'desc': 'Padi varietas unggul tahan hama wereng.'
      },
      {
        'id': 'p8', 'name': 'Benih Jahe Merah', 'price': 15000.0, 'rating': 4.7, 
        'category': 'Benih Herbal', 'image': 'assets/img/produk/jahe.png',
        'desc': 'Jahe merah kualitas super untuk rimpang herbal.'
      },
      {
        'id': 'p9', 'name': 'Benih Kangkung', 'price': 6000.0, 'rating': 4.8, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/kubis.jpg', // menggunakan dummy image
        'desc': 'Kangkung cabut cepat panen, daun lebar.'
      },
      {
        'id': 'p10', 'name': 'Benih Bayam', 'price': 5000.0, 'rating': 4.6, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/15.png',
        'desc': 'Bayam hijau bernutrisi tinggi.'
      },
      {
        'id': 'p11', 'name': 'Benih Semangka', 'price': 20000.0, 'rating': 4.7, 
        'category': 'Benih Buah', 'image': 'assets/img/produk/download (1) 2.png',
        'desc': 'Semangka inul berdaging merah manis.'
      },
      {
        'id': 'p12', 'name': 'Benih Melon', 'price': 22000.0, 'rating': 4.8, 
        'category': 'Benih Buah', 'image': 'assets/img/produk/download (1) 2.png',
        'desc': 'Melon kualitas premium dengan jaring tebal.'
      },
      {
        'id': 'p13', 'name': 'Benih Terong Ungu', 'price': 9000.0, 'rating': 4.4, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/tomat.png',
        'desc': 'Terong ungu panjang, lebat berbuah.'
      },
      {
        'id': 'p14', 'name': 'Benih Cabai Rawit', 'price': 18000.0, 'rating': 4.9, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/15.png',
        'desc': 'Cabai rawit setan yang super pedas.'
      },
      {
        'id': 'p15', 'name': 'Benih Kedelai', 'price': 25000.0, 'rating': 4.5, 
        'category': 'Benih Pangan', 'image': 'assets/img/produk/jagung.jpg',
        'desc': 'Kedelai berkualitas untuk tempe dan tahu.'
      },
      {
        'id': 'p16', 'name': 'Benih Kunyit', 'price': 12000.0, 'rating': 4.6, 
        'category': 'Benih Herbal', 'image': 'assets/img/produk/jahe.png',
        'desc': 'Kunyit kuning kaya akan kurkumin.'
      },
      {
        'id': 'p17', 'name': 'Benih Mawar Merah', 'price': 15000.0, 'rating': 4.8, 
        'category': 'Benih Bunga', 'image': 'assets/img/produk/download (1) 2.png',
        'desc': 'Mawar merah potong yang indah dan wangi.'
      },
      {
        'id': 'p18', 'name': 'Benih Anggrek', 'price': 45000.0, 'rating': 4.9, 
        'category': 'Benih Bunga', 'image': 'assets/img/produk/download (1) 2.png',
        'desc': 'Benih anggrek bulan berkualitas super.'
      },
      {
        'id': 'p19', 'name': 'Benih Brokoli', 'price': 14000.0, 'rating': 4.7, 
        'category': 'Benih Sayuran', 'image': 'assets/img/produk/kubis.jpg',
        'desc': 'Brokoli hijau besar kaya vitamin.'
      },
      {
        'id': 'p20', 'name': 'Benih Stroberi', 'price': 25000.0, 'rating': 4.8, 
        'category': 'Benih Buah', 'image': 'assets/img/produk/kelengkeng.png',
        'desc': 'Stroberi dataran tinggi manis segar.'
      },
    ];

    for (var product in products) {
      await _firestore.collection('products').doc(product['id']).set(product);
    }

    print('Berhasil menyemai 20 data produk!');
  }
}
