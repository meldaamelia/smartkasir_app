import 'package:flutter/material.dart';

// Mengimpor halaman DashboardPage untuk ditampilkan pada tab menu pertama (Beranda)
import 'dashboard_page.dart';

// Komponen/Widget MainNavigationPage turunan StatefulWidget: Mengelola status tab menu yang aktif
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

// Kelas pengelola state dan logika navigasi bawah aplikasi SmartKasir
class _MainNavigationPageState extends State<MainNavigationPage> {
  // --- DEKLARASI VARIABEL STATE NAVIGASI ---
  // Deklarasi variabel indeks tab yang sedang aktif dipilih pengguna (Nilai awal: 0 = Tab Beranda)
  int _currentIndex = 0;

  // Deklarasi variabel koleksi layar halaman menu operasional kasir (Tipe: List of Widget, Immutable)
  final List<Widget> _pages = [
    const DashboardPage(), // Indeks 0: Halaman Dashboard Katalog Kasir
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
    // Komponen/Widget Scaffold: Pondasi visual penyedia slot halaman dan bilah navigasi bawah
    return Scaffold(
      // --- KONTROL PERCABANGAN BERBASIS INDEKS ARRAY (DYNAMIC VIEW SWITCHING) ---
      // Menampilkan widget halaman secara dinamis dari list _pages sesuai nilai indeks variabel _currentIndex
      body: _pages[_currentIndex],

      // Komponen/Widget Container: Pembungkus bilah navigasi bawah dengan efek bayangan elevasi
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            // Efek bayangan halus yang memisahkan area navigasi bawah dengan konten halaman di atasnya
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2), // Bayangan mengarah ke atas
            ),
          ],
        ),

        // Komponen/Widget BottomNavigationBar: Bilah menu navigasi bawah dengan 4 tab
        child: BottomNavigationBar(
          currentIndex: _currentIndex, // Menandai tab yang sedang aktif
          type: BottomNavigationBarType
              .fixed, // Mengunci posisi 4 tab agar tidak bergeser
          // --- EVENT HANDLER PERPINDAHAN TAB MENU ---
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Memperbarui indeks tab aktif berdasarkan menu yang diklik
            });
          },

          backgroundColor:
              Colors.white, // Warna latar belakang bilah navigasi: Putih
          selectedItemColor: const Color(
            0xFF1E3A8A,
          ), // Warna tab dan label saat aktif: Biru Navy Kasir
          unselectedItemColor: Colors
              .grey
              .shade500, // Warna tab dan label saat pasif: Abu-abu netral
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ), // Gaya teks aktif tebal
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
          ), // Gaya teks pasif
          // --- DEKLARASI DAFTAR ITEM NAVIGASI BAWAH (4 TAB MENU UTAMA) ---
          items: const [
            // Tab 1: Menu Beranda Toko
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Beranda',
            ),

            // Tab 2: Menu Kasir POS
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Kasir',
            ),

            // Tab 3: Menu Riwayat Transaksi & Laporan
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Riwayat',
            ),

            // Tab 4: Menu Profil Toko & Pengaturan
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
