# 🛍️ Flomart - Aplikasi E-Commerce Bunga Mobile

[![Flutter](https://img.shields.io/badge/Flutter-3.11.4+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.4+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **📝 Catatan:** Dokumentasi README ini diperbarui setelah demo EAS (Evaluasi Akhir Semester).

---

## 1️⃣ Nama Aplikasi

**FLOMART** - Aplikasi E-Commerce Penjualan Bunga dan Aksesori Bunga

---

## 2️⃣ Anggota Kelompok

| No | Nama | NPM |
|:--:|:---|:---|
| 1 | Septian Listia Tri Cahyo | 24082010004 |
| 2 | Hafida Zahra Sofiya L. | 24082010013 |
| 3 | Evelin Salsabila Aflahah | 24082010017 |
| 4 | Titania Kaylife Putri | 24082010022 |
| 5 | Daniel | 24082010045 |

---

## 3️⃣ Tema Aplikasi

**E-Commerce & Business** - Platform jual-beli online dengan fokus pada penjualan produk bunga, buket, dan aksesori bunga dengan fitur-fitur modern seperti katalog produk, keranjang belanja, profil pengguna, chat customer service, dan halaman order management.

---

## 4️⃣ Deskripsi Singkat Aplikasi

**Flomart** adalah aplikasi mobile e-commerce yang dibangun dengan Flutter dan dirancang khusus untuk memudahkan pelanggan dalam membeli berbagai macam produk bunga, buket, tanaman hias, dan aksesori bunga. Aplikasi ini menyediakan pengalaman berbelanja yang user-friendly dengan antarmuka yang responsif, katalog produk yang lengkap, fitur pencarian yang intuitif, serta informasi produk yang detail. Flomart juga dilengkapi dengan sistem cart management, order tracking, dan fitur chat untuk komunikasi antara pembeli dan penjual.

---

## 5️⃣ Jenis Firebase yang Digunakan

**Cloud Firestore** - Database NoSQL berbasis cloud yang dipilih untuk menyimpan data produk, pengguna, keranjang, pesanan, chat, dan informasi transaksi dengan struktur koleksi yang terorganisir dan real-time sync capability.

---

## 6️⃣ Struktur Koleksi Firebase

### Diagram Struktur Firestore

```
FIREBASE FLOMART
│
├── users (Koleksi Pengguna)
│   └── {userId}
│       ├── nama (String)
│       ├── kontak (String - Email/Phone)
│       ├── password (String - Hashed)
│       ├── role (String: buyer/seller/admin)
│       └── created_at (Timestamp)
│
├── products (Koleksi Produk)
│   └── {productId}
│       ├── id (String)
│       ├── name (String)
│       ├── desc (String - Deskripsi)
│       ├── category (String)
│       ├── image (String - URL)
│       ├── price (Number)
│       └── rating (Number - Rating produk)
│
├── carts (Koleksi Keranjang)
│   └── {userId}
│       ├── userId (String)
│       └── items (Array)
│           ├── imagePath (String)
│           ├── name (String)
│           ├── price (Number)
│           ├── quantity (Number)
│           └── size (String)
│
├── orders (Koleksi Pesanan)
│   └── {orderId}
│       ├── orderId (String)
│       ├── alamat_kirim (String)
│       ├── bukti_pembayaran (String - URL)
│       ├── catatan (String)
│       ├── created_at (Timestamp)
│       ├── id_pesanan (String - Unique order number)
│       ├── id_user (String - Reference ke users)
│       └── items[] (Array of items yang dipesan)
│
├── chats (Koleksi Chat/Pesan)
│   └── {chatId}
│       ├── chatId (String)
│       ├── buyerId (String - Reference ke users)
│       ├── buyerName (String)
│       ├── isNewForBuyer (Boolean)
│       ├── isNewForSeller (Boolean)
│       ├── lastMessage (String)
│       ├── lastMessageTime (Timestamp)
│       └── messages (Subcollection)
│           └── {messageId}
│               └── messageId (String)
│
└── (Future Additions)
    ├── reviews (Ulasan produk)
    ├── wishlist (Daftar keinginan)
    ├── notifications (Notifikasi)
    └── transactions (Riwayat transaksi)
```

### Penjelasan Struktur Koleksi

#### 📋 **users** - Koleksi Pengguna
Menyimpan data pengguna aplikasi (pembeli, penjual, admin) dengan informasi autentikasi dan profil.

#### 📦 **products** - Koleksi Produk
Menyimpan informasi lengkap produk bunga dan aksesori yang dijual di aplikasi.

#### 🛒 **carts** - Koleksi Keranjang Belanja
Menyimpan item-item yang ada di keranjang setiap pengguna dengan detail harga, jumlah, dan ukuran.

#### 📥 **orders** - Koleksi Pesanan
Mencatat semua pesanan yang dibuat oleh pembeli termasuk alamat pengiriman, bukti pembayaran, dan status.

#### 💬 **chats** - Koleksi Pesan/Chat
Menyimpan percakapan antara pembeli dan penjual dengan tracking pesan baru dan timestamp pesan terakhir.

---

## 7️⃣ Jumlah Data yang Digunakan

| Koleksi | Jumlah Data |
|:---|:---:|
| **Users** | 8 - 12 pengguna (pembeli + penjual) |
| **Products** | 25+ produk bunga & aksesori |
| **Orders** | 15+ pesanan sampel |
| **Chats** | 10+ percakapan aktif |
| **Carts** | 5+ keranjang aktif |
| **Messages** | 50+ pesan dalam chats |

**Total Dokumen**: ~150+ dokumen di seluruh koleksi Firestore

---

## 8️⃣ Fitur Utama Aplikasi

### 🏠 **Halaman Beranda (Home)**
- Dashboard dengan konten terbaru dan produk unggulan
- Banner promosi dan penawaran spesial
- Rekomendasi produk berbasis rating dan popularitas
- Akses cepat ke kategori produk

### 📱 **Katalog Produk (Products)**
- Browsing produk dengan filter berdasarkan kategori dan harga
- Pencarian produk yang powerful dan mudah digunakan
- Tampilan detail produk (deskripsi, harga, rating)
- Tambah produk ke keranjang dengan pilihan ukuran/varian

### 🛒 **Keranjang Belanja (Cart)**
- Tambah/kurangi/hapus item dari keranjang
- Kalkulasi otomatis total harga
- Pilihan ukuran dan variasi produk
- Proses checkout yang sederhana

### 📥 **Manajemen Pesanan (Orders)**
- Riwayat pesanan lengkap dengan status
- Detail pesanan (alamat kirim, catatan, bukti pembayaran)
- Tracking status pengiriman real-time
- Upload bukti pembayaran

### 💬 **Chat & Customer Service (Chats)**
- Komunikasi real-time antara pembeli dan penjual
- History chat terorganisir dengan timestamp
- Notifikasi pesan baru
- Detail percakapan dengan informasi pembeli

### 👤 **Profil Pengguna (Profile)**
- Kelola informasi akun pribadi
- Lihat riwayat pesanan dan transaksi
- Pengaturan preferensi dan notifikasi
- Logout dan manajemen akun

### 📲 **Fitur Tambahan**
- **Authentication** - Login/Register dengan validasi
- **Real-time Updates** - Sinkronisasi data real-time dengan Firestore
- **Search & Filter** - Pencarian cepat dengan filter kategori dan harga
- **Responsive Design** - Desain yang optimal untuk berbagai ukuran layar

---

## 9️⃣ Screenshot Aplikasi (Minimal 3 Halaman)

### Halaman 1: Beranda (Home)
![Halaman Beranda](/assets/img/konten_beranda/home-screen.png "Halaman Beranda Flomart")

Menampilkan dashboard dengan banner promosi, kategori produk, dan produk unggulan terbaru dengan rating.

---

### Halaman 2: Katalog Produk (Products)
![Katalog Produk](/assets/img/produk/product-catalog.png "Katalog Produk Flomart")

Menampilkan daftar lengkap produk dengan fitur filter kategori, harga, dan pencarian produk.

---

### Halaman 3: Detail Produk & Keranjang
![Detail Produk](/assets/img/produk/product-detail.png "Detail Produk Flomart")

Menampilkan informasi lengkap produk termasuk deskripsi, harga, rating, dan opsi tambah ke keranjang dengan pilihan ukuran.

---

### Halaman 4: Keranjang Belanja (Cart)
![Keranjang Belanja](/assets/img/system/cart-screen.png "Keranjang Belanja Flomart")

Menampilkan item di keranjang dengan opsi edit quantity, hapus, pilih ukuran, dan lanjut ke checkout.

---

### Halaman 5: Manajemen Pesanan (Orders)
![Pesanan](/assets/img/system/orders-screen.png "Manajemen Pesanan Flomart")

Menampilkan riwayat pesanan dengan status, alamat kirim, bukti pembayaran, dan catatan pesanan.

---

### Halaman 6: Chat & Customer Service
![Chat](/assets/img/system/chat-screen.png "Chat Flomart")

Menampilkan daftar chat dengan pembeli/penjual, pesan terakhir, dan akses ke percakapan detail.

---

## 🔟 Cara Menjalankan Aplikasi

### Prasyarat

Sebelum memulai, pastikan Anda telah menginstal:

- **Flutter SDK** (versi 3.11.4 atau lebih tinggi) - [Panduan instalasi](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (disertakan dengan Flutter)
- **IDE** (Visual Studio Code, Android Studio, atau IntelliJ IDEA)
- **Git** - untuk clone repository
- **Android SDK** (untuk Android development)
- **Xcode** (untuk iOS development, hanya untuk macOS)

### Step 1: Clone Repository

```bash
git clone https://github.com/EvelinSA05/flomart-pemmob.git
cd flomart-pemmob
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Setup Firebase

Firebase Cloud Firestore adalah bagian integral dari aplikasi Flomart:

1. **Buat Project Firebase:**
   - Kunjungi [Firebase Console](https://console.firebase.google.com)
   - Klik "Create Project" atau "Add Project"
   - Isi nama project: `Flomart` atau sesuai preferensi
   - Aktifkan Google Analytics (opsional)
   - Klik "Create Project"

2. **Buat Cloud Firestore Database:**
   - Di Firebase Console, pilih project Flomart
   - Klik "Firestore Database" di sidebar
   - Klik "Create Database"
   - Pilih region (misalnya: `asia-southeast1`)
   - Mulai dalam mode "test" (untuk development)
   - Klik "Create"

3. **Download Konfigurasi Firebase:**
   - **Untuk Android:**
     - Di Firebase Console, klik gear ⚙️ → Project Settings
     - Pilih tab "Service Accounts"
     - Klik "Generate New Private Key" untuk Android
     - Download file `google-services.json`
     - Copy ke folder: `android/app/`

   - **Untuk iOS:**
     - Di Firebase Console, klik gear ⚙️ → Project Settings
     - Tab "General" → Download `GoogleService-Info.plist`
     - Copy ke `ios/Runner/` (bisa via Xcode)

4. **Aktifkan Authentication (Opsional):**
   - Di Firebase Console, klik "Authentication"
   - Klik "Get Started"
   - Aktifkan "Email/Password" provider

5. **Setup Firestore Security Rules:**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

### Step 4: Jalankan Aplikasi

**Untuk Emulator/Device Android:**
```bash
flutter run
```

**Untuk iOS (memerlukan macOS):**
```bash
flutter run -t ios
```

**Untuk Web:**
```bash
flutter run -w
```

**Untuk Device tertentu:**
```bash
flutter devices  # Lihat daftar device
flutter run -d <device_id>
```

### Step 5: Build APK/IPA untuk Production

**Untuk Android (APK):**
```bash
flutter build apk --release
```

Hasil APK akan tersimpan di: `build/app/outputs/apk/release/app-release.apk`

**Untuk Android (App Bundle):**
```bash
flutter build appbundle --release
```

**Untuk iOS (memerlukan macOS dan Apple Developer Account):**
```bash
flutter build ios --release
```

---

## 📁 Struktur Direktori

```
flomart-pemmob/
├── android/                    # Konfigurasi Android
│   ├── app/
│   │   ├── google-services.json    # Firebase config untuk Android
│   │   └── build.gradle
│   └── gradle/
├── ios/                        # Konfigurasi iOS
│   ├── Runner/
│   │   ├── GoogleService-Info.plist # Firebase config untuk iOS
│   │   └── Info.plist
│   └── Podfile
├── lib/                        # 📌 Kode sumber utama Dart/Flutter
│   ├── main.dart              # Entry point aplikasi
│   ├── screens/               # Halaman-halaman UI
│   │   ├── home_screen.dart
│   │   ├── products_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── orders_screen.dart
│   │   ├── order_detail_screen.dart
│   │   ├── chats_screen.dart
│   │   ├── chat_detail_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── widgets/               # Widget reusable
│   │   ├── product_card.dart
│   │   ├── cart_item_card.dart
│   │   ├── order_card.dart
│   │   ├── chat_bubble.dart
│   │   └── custom_button.dart
│   ├── models/                # Data models
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   ├── cart_model.dart
│   │   ├── order_model.dart
│   │   ├── chat_model.dart
│   │   └── message_model.dart
│   ├── services/              # Layanan dan Firebase integration
│   │   ├── firebase_service.dart
│   │   ├── auth_service.dart
│   │   ├── product_service.dart
│   │   ├── cart_service.dart
│   │   ├── order_service.dart
│   │   └── chat_service.dart
│   ├── providers/             # State management (Provider)
│   │   ├── user_provider.dart
│   │   ├── product_provider.dart
│   │   ├── cart_provider.dart
│   │   ├── order_provider.dart
│   │   └── chat_provider.dart
│   └── utils/                 # Utility functions
│       ├── constants.dart
│       ├── themes.dart
│       └── helpers.dart
├── assets/                     # Aset aplikasi
│   ├── img/
│   │   ├── konten_beranda/    # Gambar halaman beranda
│   │   ├── produk/            # Gambar produk bunga
│   │   └── system/            # Ikon dan gambar sistem
│   └── fonts/                 # Custom fonts (jika ada)
├── test/                       # Unit dan widget tests
├── web/                        # Konfigurasi web
├── linux/                      # Konfigurasi Linux
├── macos/                      # Konfigurasi macOS
├── windows/                    # Konfigurasi Windows
├── pubspec.yaml               # Dependency management
├── pubspec.lock               # Lock file dependencies
├── analysis_options.yaml      # Konfigurasi linting
└── README.md                  # Dokumentasi (file ini)
```

---

## 📦 Dependencies Utama

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^8.0.2
  firebase_core: ^3.0.0
  cloud_firestore: ^5.0.0
  firebase_auth: ^5.0.0
  firebase_storage: ^11.6.0
  provider: ^6.0.0
  intl: ^0.19.0
  cached_network_image: ^3.3.0
  image_picker: ^1.0.0
  uuid: ^4.0.0
  # Lihat pubspec.yaml untuk daftar lengkap
```

Lihat `pubspec.yaml` untuk daftar lengkap dependencies dan versi yang tepat.

---

## 🛠️ Development & Code Quality

### Jalankan Code Analysis

```bash
flutter analyze
```

### Format Kode

```bash
dart format .
```

### Run Tests

```bash
flutter test
```

---

## 🌐 Platform Support

Flomart Pemmob mendukung berbagai platform:

- ✅ **Android** (API level 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Linux** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Windows** (Desktop)

---

## 🐛 Troubleshooting

### Flutter tidak terinstall atau outdated
```bash
flutter upgrade
flutter --version
```

### Dependencies error
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Build cache error
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Gradle error (Android)
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

### Error koneksi Firebase
- Pastikan file `google-services.json` (Android) sudah di-copy ke `android/app/`
- Pastikan file `GoogleService-Info.plist` (iOS) sudah di-copy ke `ios/Runner/`
- Pastikan Firestore rules memungkinkan read/write untuk authenticated users
- Cek koneksi internet device/emulator

### Error pubspec.yaml
```bash
flutter pub cache clean
flutter pub get
```

---

## 📚 Dokumentasi & Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Firebase Storage](https://firebase.google.com/docs/storage)
- [Flutter Tutorials](https://flutter.dev/docs/codelabs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

---

## 👨‍💼 Project Maintainer

**Evelin Salsabila Aflahah** - [@EvelinSA05](https://github.com/EvelinSA05)

---

## 📄 License

Proyek ini menggunakan lisensi MIT. Lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

---

## 💬 Kontribusi

Kontribusi sangat diterima! Berikut cara berkontribusi:

1. Fork repository ini
2. Buat branch feature baru (`git checkout -b feature/AmazingFeature`)
3. Commit changes Anda (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request dengan deskripsi yang jelas

---

## 📧 Kontak & Support

Jika Anda memiliki pertanyaan, saran, atau melaporkan bug:

- 📌 Buat [GitHub Issue](https://github.com/EvelinSA05/flomart-pemmob/issues)
- 💌 Hubungi melalui GitHub Profile
- 📱 Silakan tanyakan di discussion section

---

## 📝 Changelog

### v1.0.0 - Setelah Demo EAS (22 Juni 2026)
- ✅ Dokumentasi README diperbarui dengan struktur lengkap
- ✅ Struktur Firestore direvisi dengan koleksi: users, products, carts, orders, chats
- ✅ Menambahkan detail anggota kelompok dan NPM
- ✅ Dokumentasi fitur utama (Home, Products, Cart, Orders, Chats, Profile)
- ✅ Placeholder untuk 6 screenshot halaman utama
- ✅ Petunjuk instalasi Firebase Cloud Firestore lengkap
- ✅ Cara menjalankan aplikasi (clone, install, setup, run, build)

---

**Happy Coding!** 🎉

*Diperbarui pada: 22 Juni 2026 (Setelah Demo EAS)*

---
