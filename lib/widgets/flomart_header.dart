import 'package:flutter/material.dart';

class FlomartHeader extends StatelessWidget implements PreferredSizeWidget {
  const FlomartHeader({super.key});

  static const String headerLogoAsset = 'assets/img/system/logoFlomart.png';
  static const String headerWhatsappAsset = 'assets/img/system/logoChat.png';
  static const String headerShopAsset = 'assets/img/system/logoKeranjang.png';
  static const String headerNotificationAsset =
      'assets/img/system/logoNotif.png';
  static const String headerCartAsset = 'assets/img/system/logPesanan.png';
  static const String headerProfileAsset = 'assets/img/system/logoProfile.png';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 64,
      titleSpacing: 16,
      title: _assetImage(
        headerLogoAsset,
        height: 24,
        fit: BoxFit.contain,
        fallback: const Text(
          'FLOMART',
          style: TextStyle(
            color: Color(0xFF14824C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerWhatsappAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerShopAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerNotificationAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(headerCartAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 4),
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 32,
              height: 32,
              child: ClipOval(
                child: _assetImage(
                  headerProfileAsset,
                  fit: BoxFit.cover,
                  fallback: const Icon(
                    Icons.person_outline,
                    color: Color(0xFFBEBEBE),
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  Widget _headerActionAsset(String path) {
    return IconButton(
      onPressed: () {},
      splashRadius: 20,
      icon: _assetImage(
        path,
        width: 21,
        height: 21,
        fit: BoxFit.contain,
        fallback: const Icon(
          Icons.crop_square,
          color: Color(0xFF14824C),
          size: 20,
        ),
      ),
    );
  }

  Widget _assetImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? fallback,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child:
                fallback ??
                Container(
                  width: width,
                  height: height,
                  color: const Color(0xFFEAE7E0),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
          ),
        );
      },
    );
  }
}
