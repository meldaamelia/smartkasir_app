import 'package:flutter/material.dart';

// Mengimpor halaman DashboardPage untuk tab pertama (Beranda)
import 'dashboard_page.dart';

// Widget MainNavigationPage: mengelola tab menu yang aktif
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

// Pengelola state dan logika navigasi bawah
class _MainNavigationPageState extends State<MainNavigationPage> {
  // Indeks tab yang aktif (nilai awal 0 = Beranda)
  int _currentIndex = 0;

  // Daftar layar untuk 4 tab menu
  final List<Widget> _pages = [
    const DashboardPage(), // Indeks 0: Dashboard Katalog
    const Center(
      child: Text(
        'Menu 2: Transaksi Kasir POS (Modul M14)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 1: POS Kasir
    const Center(
      child: Text(
        'Menu 3: Riwayat Penjualan & Laporan (Modul M12)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 2: Riwayat
    const Center(
      child: Text(
        'Menu 4: Profil Toko & Pengaturan (Modul M12)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 3: Pengaturan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan halaman sesuai nilai _currentIndex
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Kasir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Toko',
            ),
          ],
        ),
      ),
    );
  }
}
