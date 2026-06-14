import 'package:flutter/material.dart';
import '../../services/app_state.dart';

class AddressData {
  final String nama;
  final String alamat;

  AddressData({
    required this.nama,
    required this.alamat,
  });
}

class AlamatSayaPage extends StatefulWidget {
  const AlamatSayaPage({super.key});

  static const Color bg = Color(0xFFF4F1F1);
  static const Color green = Color(0xFF13824B);
  static const Color brightGreen = Color(0xFF16D600);

  @override
  State<AlamatSayaPage> createState() => _AlamatSayaPageState();
}

class _AlamatSayaPageState extends State<AlamatSayaPage> {
  int selectedIndex = 0;

  List<AddressData> addresses = [];

  @override
  void initState() {
    super.initState();
    final userAddress = AppState().userAddress;
    if (userAddress != null && userAddress.isNotEmpty) {
      addresses.add(AddressData(
        nama: AppState().userName ?? 'Pengguna',
        alamat: userAddress,
      ));
    }
  }

  Widget _alamatInput(
  String label,
  String hint,
  TextEditingController controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 42,
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: const Color(0xFFD9D9D9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
    ],
  );
}

  Widget _alamatSelectionInput(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return _SelectionBottomSheet(
                    title: label,
                    items: items,
                    onSelected: (value) {
                      controller.text = value;
                    },
                  );
                },
              );
            },
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: const Color(0xFFD9D9D9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _showTambahAlamatDialog(BuildContext context) {
  final alamatController = TextEditingController();
  final negaraController = TextEditingController();
  final provinsiController = TextEditingController();
  final kotaController = TextEditingController();
  final jalanController = TextEditingController();
  final kodePosController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 28),
                    ),

                    const SizedBox(width: 8), // jarak antara icon dan text

                    const Text(
                      "Kembali",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                const Text(
                  "Tambahkan Alamat Baru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 22),

                _alamatInput("Alamat Pengantaran", "Alamat Pegantaran", alamatController),
                _alamatSelectionInput(context, "Bagian/Provinsi", "Pilih Provinsi", provinsiController, ["Jawa Timur", "Jawa Tengah", "Jawa Barat", "DKI Jakarta", "Banten", "DI Yogyakarta", "Bali"]),
                _alamatSelectionInput(context, "Kota/Kabupaten", "Pilih Kota", kotaController, ["Sidoarjo", "Surabaya", "Gresik", "Malang", "Mojokerto", "Pasuruan", "Jakarta Selatan", "Jakarta Barat", "Jakarta Pusat", "Jakarta Timur", "Bandung", "Semarang", "Denpasar"]),
                _alamatInput("Alamat Jalan", "Alamat Jalan", jalanController),
                _alamatInput("Kode Pos", "Kode Pos", kodePosController),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2BE00),
                            foregroundColor: Colors.black,
                            surfaceTintColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Batal",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            if (alamatController.text.isEmpty ||
                                provinsiController.text.isEmpty ||
                                kotaController.text.isEmpty ||
                                jalanController.text.isEmpty ||
                                kodePosController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua kolom wajib diisi!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context); // tutup form

                            // tampilkan popup sukses
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
                                          child: const Icon(Icons.check,
                                              color: Colors.white, size: 40),
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
                                          "Alamat baru berhasil ditambahkan",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),

                                        const SizedBox(height: 30),

                                        SizedBox(
                                          width: 160,
                                          height: 45,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context); // tutup popup sukses

                                              setState(() {
                                                addresses.add(
                                                  AddressData(
                                                    nama: AppState().userName ?? 'Pengguna',
                                                    alamat: '${jalanController.text}\n'
                                                            '${kotaController.text.toUpperCase()}, '
                                                            '${provinsiController.text.toUpperCase()}, '
                                                            'ID, ${kodePosController.text}',
                                                  ),
                                                );
                                                if (addresses.length == 1) {
                                                  AppState().setUserAddress(addresses[0].alamat);
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFE2BE00),
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
                            backgroundColor: const Color(0xFFE2BE00),
                            foregroundColor: Colors.black,
                            surfaceTintColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 55,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Alamat Saya',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 105),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alamat',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                      child: addresses.isEmpty 
                        ? Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                            _showTambahAlamatDialog(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Masukkan alamat anda',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(addresses.length, (index) {
                          final item = addresses[index];

                          return Column(
                            children: [
                              _AddressItem(
                                index: index,
                                selectedIndex: selectedIndex,
                                showDelete: index != 0,
                                nama: item.nama,
                                alamat: item.alamat,
                                onTapUtama: (i) {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                  AppState().setUserAddress(addresses[i].alamat);
                                },
                              ),
                              if (index != addresses.length - 1)
                                const Divider(
                                  height: 28,
                                  thickness: 1.2,
                                  color: Colors.black,
                                ),
                            ],
                          );
                        }),
                      ),
                ),

              ],
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 22,
            child: SizedBox(
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showTambahAlamatDialog(context);
                },
                icon: const Icon(Icons.add, size: 30, color: Colors.black),
                label: const Text(
                  'Tambah  Alamat Baru',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF16D600),
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFF13824B), width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  class _AddressItem extends StatelessWidget {
  const _AddressItem({
    required this.index,
    required this.selectedIndex,
    required this.showDelete,
    required this.nama,
    required this.alamat,
    required this.onTapUtama,
  });

  final int index;
  final int selectedIndex;
  final bool showDelete;
  final String nama;    
  final String alamat;   
  final Function(int) onTapUtama;

  static const Color green = Color(0xFF13824B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nama,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          alamat,
          style: TextStyle(
            fontSize: 11,
            height: 1.25,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            index == selectedIndex
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Utama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const Text(
                  'Utama',
                  style: TextStyle(fontSize: 11, color: Colors.black),
                ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Text(
                      'Ubah',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                      ),
                    ),
                    if (showDelete) ...[
                      const SizedBox(width: 12),
                      const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      onTapUtama(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Atur Sebagai Utama',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const _SelectionBottomSheet({
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  State<_SelectionBottomSheet> createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<_SelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih ${widget.title}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari ${widget.title}...',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(_filteredItems[index], style: const TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  onTap: () {
                    widget.onSelected(_filteredItems[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}