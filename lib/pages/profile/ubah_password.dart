import 'package:flutter/material.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  static const Color bg = Color(0xFFF4F1F1);
  static const Color yellow = Color(0xFFE2BE00);

  @override
  void dispose() {
    passwordLamaController.dispose();
    passwordBaruController.dispose();
    konfirmasiPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 55,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _passwordField(
                    label: 'Password Lama',
                    hint: 'Masukkan Password Lama',
                    controller: passwordLamaController,
                  ),

                  const SizedBox(height: 28),

                  _passwordField(
                    label: 'Password Baru',
                    hint: 'Masukkan Password Baru',
                    controller: passwordBaruController,
                  ),

                  const SizedBox(height: 14),

                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      '• Min. 8 karakter\n'
                      '• Kombinasi huruf & angka\n'
                      '• Disarankan pakai simbol',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.25,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  _passwordField(
                    label: 'Konfirmasi Password',
                    hint: 'Konfirmasi Password Baru',
                    controller: konfirmasiPasswordController,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 28,
            right: 28,
            bottom: 28,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.close, size: 30),
                                ),
                              ),

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
                                "Password berhasil diubah",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: 160,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE2BE00),
                                    foregroundColor: Colors.black,
                                    surfaceTintColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text("Lanjutkan"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellow,
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Ubah Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFD0D0D0),
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 1.4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 1.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}