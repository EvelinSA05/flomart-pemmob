import 'package:flutter/material.dart';
import '../pages/profile/profile.dart';
import '../pages/chat/chat_page.dart';
import '../pages/beranda/cart_page.dart';
import '../pages/beranda/notifikasi.dart';
import '../pages/profile/pesanan_saya.dart';
import '../services/app_state.dart';

class FlomartHeaderLoggedIn extends StatelessWidget implements PreferredSizeWidget {
  const FlomartHeaderLoggedIn({super.key});

  static const String headerLogoAsset = 'assets/img/system/logoFlomart.png';
  static const String headerWhatsappAsset = 'assets/img/system/logoChat.png';
  static const String headerShopAsset = 'assets/img/system/logoKeranjang.png';
  static const String headerNotificationAsset ='assets/img/system/logoNotif.png';
  static const String headerCartAsset = 'assets/img/system/logPesanan.png';
  static const String headerProfileAsset = 'assets/img/system/pengguna_login.png';

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
          child: _headerActionAsset(context, headerWhatsappAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(context, headerShopAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(context, headerNotificationAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _headerActionAsset(context, headerCartAsset),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 4),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
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

  Widget _headerActionAsset(BuildContext context, String path) {
    return IconButton(
      onPressed: () {
        if (path == headerWhatsappAsset) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChatPage(),
            ),
          );
        } else if (path == headerShopAsset) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CartPage(),
            ),
          );
        } else if (path == headerNotificationAsset) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationPage(),
            ),
          );
        } else if (path == headerCartAsset) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PesananSayaPage(),
            ),
          );
        }
      },
      splashRadius: 20,
      icon: path == headerShopAsset
          ? ListenableBuilder(
              listenable: AppState(),
              builder: (context, child) {
                final count = AppState().cartItems.length;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _assetImage(
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
                    if (count > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          : _assetImage(
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
      errorBuilder: (_, _, _) {
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
