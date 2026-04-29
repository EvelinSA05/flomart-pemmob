# 🛍️ Flomart Pemmob

[![Flutter](https://img.shields.io/badge/Flutter-3.11.4+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.4+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Flomart Pemmob** adalah aplikasi mobile e-commerce yang dibangun dengan Flutter. Aplikasi ini menyediakan platform berbelanja online yang user-friendly dengan fitur-fitur modern untuk meningkatkan pengalaman pengguna.

## ✨ Fitur Utama

- 🏠 **Halaman Beranda** - Dashboard dengan konten terbaru dan produk unggulan
- 📱 **Katalog Produk** - Browsing dan pencarian produk yang mudah
- 📚 **Blog Konten** - Artikel dan tips terkait produk
- 🛒 **Keranjang Belanja** - Manajemen item belanja dengan mudah
- 👤 **Profil Pengguna** - Kelola akun dan preferensi pribadi
- 📲 **Antarmuka Responsif** - Desain yang optimal untuk berbagai ukuran layar

## 📋 Prasyarat

Sebelum memulai, pastikan Anda telah menginstal:

- **Flutter SDK** (versi 3.11.4 atau lebih tinggi) - [Panduan instalasi](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (disertakan dengan Flutter)
- **IDE** (Visual Studio Code, Android Studio, atau IntelliJ IDEA)
- **Android SDK** (untuk Android development)
- **Xcode** (untuk iOS development, hanya untuk macOS)

## 🚀 Instalasi & Penggunaan

### 1. Clone Repository

```bash
git clone https://github.com/EvelinSA05/flomart-pemmob.git
cd flomart-pemmob
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

**Untuk emulator/device Android:**
```bash
flutter run
```

**Untuk iOS:**
```bash
flutter run -t ios
```

**Untuk Web:**
```bash
flutter run -w
```

### 4. Build APK/IPA

**Untuk Android (APK):**
```bash
flutter build apk
```

**Untuk Android (App Bundle):**
```bash
flutter build appbundle
```

**Untuk iOS:**
```bash
flutter build ios
```

## 📁 Struktur Direktori

```
flomart-pemmob/
├── android/                 # Konfigurasi Android
├── ios/                     # Konfigurasi iOS
├── lib/                     # Kode sumber utama Dart/Flutter
│   ├── main.dart           # Entry point aplikasi
│   ├── screens/            # Halaman-halaman UI
│   ├── widgets/            # Widget reusable
│   ├── models/             # Data models
│   └── services/           # Layanan dan API calls
├── assets/                 # Aset aplikasi (gambar, ikon, dll)
│   ├── img/               # Folder gambar
│   │   ├── konten_blog/   # Gambar artikel blog
│   │   ├── konten_beranda/# Gambar konten halaman beranda
│   │   ├── produk/        # Gambar produk
│   │   └── system/        # Ikon dan gambar sistem
├── test/                   # Unit dan widget tests
├── web/                    # Konfigurasi web
├── linux/                  # Konfigurasi Linux
├── macos/                  # Konfigurasi macOS
├── windows/                # Konfigurasi Windows
├── pubspec.yaml           # Dependency management
├── pubspec.lock           # Lock file dependencies
└── analysis_options.yaml  # Konfigurasi linting
```

## 📦 Dependencies Utama

- **flutter** - Framework Flutter SDK
- **cupertino_icons** (^1.0.8) - iOS style icons
- **google_fonts** (^8.0.2) - Google Fonts untuk typography

Lihat `pubspec.yaml` untuk daftar lengkap dependencies.

## 🛠️ Development

### Code Quality

Untuk menjaga kualitas kode, gunakan:

```bash
# Analyze kode
flutter analyze

# Format kode
dart format .

# Run tests
flutter test
```

## 🌐 Platform Support

Flomart Pemmob mendukung:

- ✅ **Android** (API level 21+)
- ✅ **iOS** (iOS 11.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Linux** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Windows** (Desktop)

## 📚 Dokumentasi & Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Tutorials](https://flutter.dev/docs/codelabs)
- [Cookbook - Flutter recipes](https://flutter.dev/docs/cookbook)

## 🐛 Troubleshooting

### Masalah Umum

**Flutter tidak terinstall atau outdated:**
```bash
flutter upgrade
```

**Dependencies error:**
```bash
flutter clean
flutter pub get
```

**Build cache error:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**Gradle error (Android):**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

## 👤 Author

**Evelin SA** - [@EvelinSA05](https://github.com/EvelinSA05)

## 📄 License

Proyek ini belum memiliki lisensi resmi. Untuk informasi lebih lanjut, hubungi maintainer.

## 💬 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat branch feature (`git checkout -b feature/AmazingFeature`)
3. Commit changes Anda (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## 📧 Kontak & Support

Jika Anda memiliki pertanyaan atau saran, silakan:

- 📌 Buat [GitHub Issue](https://github.com/EvelinSA05/flomart-pemmob/issues)
- 💌 Hubungi melalui GitHub

---

**Happy Coding!** 🎉

*Diperbarui pada: April 29, 2026*
