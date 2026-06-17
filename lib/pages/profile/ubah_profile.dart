import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../services/app_state.dart';

class UbahProfilePage extends StatefulWidget {
  const UbahProfilePage({super.key});

  @override
  State<UbahProfilePage> createState() => _UbahProfilePageState();
}

class _UbahProfilePageState extends State<UbahProfilePage> {
  late final TextEditingController namaController;
  late final TextEditingController emailController;
  final TextEditingController teleponController =
      TextEditingController(text: '085855900600');
  final TextEditingController tanggalController =
      TextEditingController(text: '01 Januari 2000');

  String gender = 'Laki - Laki';
  bool sudahDisimpan = false;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  static const Color bg = Color(0xFFF4F1F1);
  static const Color yellow = Color(0xFFE2BE00);

  @override
  void initState() {
    super.initState();
    final appState = AppState();
    namaController = TextEditingController(text: appState.userName ?? 'Pengguna');
    emailController = TextEditingController(text: appState.userEmail ?? '');
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    teleponController.dispose();
    tanggalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 30, maxWidth: 600);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Ubah Profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 38),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  ClipOval(
                    child: Builder(
                      builder: (context) {
                        if (_imageBytes != null) {
                          return Image.memory(
                            _imageBytes!,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          );
                        } else if (AppState().userAvatar != null) {
                          // base64 decode
                          String b64 = AppState().userAvatar!;
                          if (b64.startsWith('data:image')) {
                            b64 = b64.split(',').last;
                          }
                          try {
                            return Image.memory(
                              base64Decode(b64),
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            );
                          } catch (e) {
                            return Image.asset(
                              'assets/img/system/pengguna_login.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            );
                          }
                        }
                        return Image.asset(
                          'assets/img/system/pengguna_login.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 35),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Pilih Gambar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  _usernameRow(),
                  const SizedBox(height: 22),
                  _inputRow('Nama', namaController),
                  const SizedBox(height: 18),
                  _inputRow('Email', emailController),
                  const SizedBox(height: 18),
                  _inputRow('No Telepon', teleponController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 18),
                  _inputRow('Tanggal lahir', tanggalController),
                  const SizedBox(height: 20),
                  _genderRow(),
                ],
              ),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: 
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _isLoading = true;
                  });

                  String? base64Image;
                  if (_imageBytes != null) {
                    base64Image = "data:image/jpeg;base64," + base64Encode(_imageBytes!);
                  }

                  await AppState().updateProfile(
                    name: namaController.text.trim(),
                    phone: teleponController.text.trim(),
                    dob: tanggalController.text.trim(),
                    gender: gender,
                    avatarBase64: base64Image,
                  );

                  setState(() {
                    _isLoading = false;
                  });

                  showDialog(
                    context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),

                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF13824B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                const Text(
                                  "Sukses",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Profil berhasil diperbarui",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),

                                const SizedBox(height: 28),

                                SizedBox(
                                  width: 160,
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                        setState(() {
                                          sudahDisimpan = true;
                                        });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE2BE00), // kuning
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "Lanjutkan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2BE00), // kuning
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.transparent, // penting biar ga jadi putih
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                    sudahDisimpan ? "Ubah" : "Simpan",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usernameRow() {
    return Row(
      children: [
        const SizedBox(
          width: 115,
          child: Text(
            'Username',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              AppState().userName ?? 'Pengguna',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ),
      ],
    );
  }

  Widget _inputRow(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 115,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 38,
            child: 
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 13,
              ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.black, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.black, width: 1.4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderRow() {
    return Row(
      children: [
        const SizedBox(
          width: 115,
          child: Text(
            'Jenis Kelamin',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: 'Laki - Laki',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              const Text(
                'Laki - Laki',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Radio<String>(
                value: 'Perempuan',
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              const Text(
                'Perempuan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}