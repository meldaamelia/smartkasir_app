// Mengimpor pustaka dasar antarmuka Flutter Material 3
import 'package:flutter/material.dart';

// Mengimpor layar Tab 0: Beranda & Katalog Produk (Modul M11)
import 'dashboard_page.dart';

// Mengimpor layar Tab 3: Profil Toko & Kelola Staf Karyawan (Modul M12)
import 'profil_toko_page.dart';

// Widget berstatus untuk mengelola kerangka navigasi bawah (BottomNavigationBar)
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  // Variabel penyimpan indeks tab menu yang sedang aktif dipilih pengguna (default: 0 = Beranda)
  int _currentIndex = 0;

  // Daftar 4 layar menu utama aplikasi SmartKasir yang terhubung ke bilah navigasi
  final List<Widget> _pages = [
    // Indeks 0: Tab Beranda (Katalog Produk & Operasi CRUD SQLite)
    const DashboardPage(),

    // Indeks 1: Tab Kasir POS (Placeholder antarmuka transaksi penjualan Modul M14)
    const Center(
      child: Text(
        'Menu 2: Transaksi Kasir POS (Modul M14)',
        style: TextStyle(fontSize: 16),
      ),
    ),

    // Indeks 2: Tab Riwayat (Placeholder laporan penjualan & rekap omzet Modul M14)
    const Center(
      child: Text(
        'Menu 3: Riwayat Penjualan & Laporan (Modul M14)',
        style: TextStyle(fontSize: 16),
      ),
    ),

    // Indeks 3: Tab Toko (Layar Profil Toko SharedPreferences & Kelola Staf Karyawan M12)
    const ProfilTokoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan widget layar sesuai tab menu yang sedang aktif dipilih pada _currentIndex
      body: _pages[_currentIndex],

      // Wadah dekorasi bilah navigasi bawah dengan efek elevasi bayangan halus
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            // Memberikan bayangan lembut pemisah visual antara konten body dan bilah navigasi
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        // Komponen bilah navigasi bawah resmi Flutter
        child: BottomNavigationBar(
          // Menetapkan indeks tombol navigasi yang sedang aktif tersorot
          currentIndex: _currentIndex,

          // Fungsi callback yang dipicu secara otomatis saat mahasiswa/pengguna menyentuh tab
          onTap: (index) {
            setState(() {
              // Memperbarui variabel indeks aktif untuk memicu render ulang Scaffold body
              _currentIndex = index;
            });
          },

          // Memastikan seluruh 4 label dan ikon menu tetap statis dan terlihat jelas tanpa bergeser
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          // Warna tema utama Navy (#1E3A8A) saat tab dalam kondisi aktif dipilih
          selectedItemColor: const Color(0xFF1E3A8A),

          // Warna abu-abu netral untuk tab yang sedang tidak aktif
          unselectedItemColor: Colors.grey.shade500,

          // Format tipografi label teks tab yang sedang aktif
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),

          // Format tipografi label teks tab yang tidak aktif
          unselectedLabelStyle: const TextStyle(fontSize: 10),

          // Daftar 4 tombol navigasi beserta ikon dan label teksnya
          items: const [
            // Item Tab 0: Menu Beranda
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Beranda',
            ),

            // Item Tab 1: Menu Kasir
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Kasir',
            ),

            // Item Tab 2: Menu Riwayat Transaksi
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Riwayat',
            ),

            // Item Tab 3: Menu Toko & Staf Karyawan
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
