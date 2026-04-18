import 'package:flutter/material.dart';
import 'login.dart'; // ✅ WAJIB ADA

class regisPage extends StatelessWidget {
  const regisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: const [
              regisHeader(),
              SizedBox(height: 10),
              regisHero(),
              SizedBox(height: 20),
              regisForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class regisHeader extends StatelessWidget {
  const regisHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 10),
          Image.asset('img/system/LogoFlomart.png', height: 30),
        ],
      ),
    );
  }
}

class regisHero extends StatelessWidget {
  const regisHero({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          Image.asset('img/system/fotocewe_kelola.png', height: 180),
        ],
      ),
    );
  }
}

class regisForm extends StatelessWidget {
  const regisForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Daftar Sebagai Penjual Flomart",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _inputField("Nama Lengkap"),
          const SizedBox(height: 12),
          _inputField("Email / No HP"),
          const SizedBox(height: 12),
          _inputField("Password", isPassword: true),
          const SizedBox(height: 12),
          _inputField("Konfirmasi Password", isPassword: true),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: const Text("Login", style: TextStyle(color: Colors.black)),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Atau"),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.facebook, color: Colors.blue),
              SizedBox(width: 10),
              Text("Facebook"),
              SizedBox(width: 30),
              Icon(Icons.g_mobiledata, color: Colors.red),
              SizedBox(width: 10),
              Text("Google"),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sudah punya akun? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }
}
