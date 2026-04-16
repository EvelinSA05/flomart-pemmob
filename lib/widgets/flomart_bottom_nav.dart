import 'package:flutter/material.dart';

import '../app_routes.dart';

enum FlomartTab { home, shop, sell, blog, about }

class FlomartBottomNav extends StatelessWidget {
  const FlomartBottomNav({super.key, required this.currentTab});

  final FlomartTab currentTab;

  static const Color _green = Color(0xFF178246);
  static const Color _labelColor = Color(0xFF181818);
  static const Color _shellColor = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: _shellColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Beranda',
                active: currentTab == FlomartTab.home,
                onTap: () => _goTo(context, FlomartTab.home),
              ),
              _NavItem(
                icon: Icons.local_offer_outlined,
                label: 'Toko',
                active: currentTab == FlomartTab.shop,
                onTap: () => _goTo(context, FlomartTab.shop),
              ),
              _NavItem(
                icon: Icons.storefront_outlined,
                label: 'Mulai Berjualan',
                active: currentTab == FlomartTab.sell,
                onTap: () => _goTo(context, FlomartTab.sell),
              ),
              _NavItem(
                icon: Icons.article_outlined,
                label: 'Blog',
                active: currentTab == FlomartTab.blog,
                onTap: () => _goTo(context, FlomartTab.blog),
              ),
              _NavItem(
                icon: Icons.info_outline_rounded,
                label: 'Tentang Kami',
                active: currentTab == FlomartTab.about,
                onTap: () => _goTo(context, FlomartTab.about),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goTo(BuildContext context, FlomartTab tab) {
    final destination = _routeFor(tab);
    if (tab == currentTab ||
        ModalRoute.of(context)?.settings.name == destination) {
      return;
    }
    Navigator.of(context).pushReplacementNamed(destination);
  }

  String _routeFor(FlomartTab tab) {
    switch (tab) {
      case FlomartTab.home:
        return homeRoute;
      case FlomartTab.shop:
        return shopRoute;
      case FlomartTab.sell:
        return sellRoute;
      case FlomartTab.blog:
        return blogRoute;
      case FlomartTab.about:
        return aboutRoute;
    }
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  static const Color _green = Color(0xFF178246);
  static const Color _labelColor = Color(0xFF181818);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: active ? const Color(0x22178246) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 26, color: _green),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.5,
                  height: 1.15,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? _green : _labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
