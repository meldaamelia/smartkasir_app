import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/produk.dart';

// Komponen/Widget DashboardPage turunan StatefulWidget: Memiliki state dinamis yang dapat berubah saat berinteraksi
class DashboardPage extends StatefulWidget {
  // Konstruktor konstan dengan parameter key
  const DashboardPage({super.key});

  // Method createState: Menghubungkan widget antarmuka dengan kelas pengelola state internalnya
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// Kelas pengelola state dan logika bisnis tampilan halaman Dashboard Beranda
class _DashboardPageState extends State<DashboardPage> {
  // --- DEKLARASI VARIABEL STATE & KONFIGURASI TAMPILAN ---
  int _kategoriTerpilih = 0;

  final List<String> _kategoriList = ['Semua', 'Makanan', 'Minuman', 'Snack'];

  // --- FUNGSI FORMAT MATA UANG RUPIAH ---
  String _formatRupiah(double nominal) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(nominal);
  }

  // --- FUNGSI PEMBUAT WIDGET BADGE INDIKATOR STOK ---
  Widget _buildBadgeStok(int stok) {
    Color warnaLatar;
    Color warnaTeks;
    String label;

    // Jika stok barang bernilai 0 (Habis Total)
    if (stok == 0) {
      warnaLatar = Colors.red.shade100;
      warnaTeks = Colors.red.shade900;
      label = 'Habis';
    }
    // Jika stok barang tersisa 1 hingga 5 unit
    else if (stok <= 5) {
      warnaLatar = Colors.amber.shade100;
      warnaTeks = Colors.amber.shade900;
      label = 'Sisa $stok';
    }
    // Jika stok barang lebih dari 5 unit
    else {
      warnaLatar = Colors.green.shade100;
      warnaTeks = Colors.green.shade900;
      label = 'Stok $stok';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: warnaTeks,
        ),
      ),
    );
  }

  // Method build: Merender seluruh hierarki antarmuka Dashboard
  @override
  Widget build(BuildContext context) {
    // --- KONTROL PERCABANGAN LOGIKA PENYARINGAN KATALOG PRODUK ---
    final listTampil = _kategoriTerpilih == 0
        ? daftarProdukDummy
        : daftarProdukDummy
              .where((p) => p.kategori == _kategoriList[_kategoriTerpilih])
              .toList();

    return Scaffold(
      // Komponen/Widget AppBar: Bilah navigasi bagian atas halaman beranda
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.point_of_sale, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text(
              'SmartKasir',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifikasi Penjualan',
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      // Komponen/Widget Column: Tata letak linier vertikal
      body: Column(
        children: [
          // BLOK 1: BANNER RINGKASAN PENJUALAN TOKO HARI INI
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Penjualan Hari Ini',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRupiah(845000),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '34 Transaksi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // BLOK 2: FILTER KATEGORI CEPAT
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _kategoriList.length,
              itemBuilder: (context, index) {
                final isSelected = _kategoriTerpilih == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_kategoriList[index]),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1E3A8A),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _kategoriTerpilih = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // BLOK 3: GRIDVIEW KATALOG PRODUK KASIR 2 KOLOM
          Expanded(
            child: listTampil.isEmpty
                ? const Center(
                    child: Text('Tidak ada produk pada kategori ini'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.90,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: listTampil.length,
                    itemBuilder: (context, index) {
                      final produk = listTampil[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // BAGIAN 1: FOTO PRODUK DAN BADGE PROMO
                            Stack(
                              children: [
                                Image.network(
                                  produk.gambarUrl,
                                  height: 125,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 125,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 125,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 36,
                                          ),
                                        ),
                                      ),
                                ),

                                // BADGE PROMO DISKON
                                if (produk.diskonPersen > 0)
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade700,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'PROMO ${produk.diskonPersen}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // BAGIAN 2: INFORMASI NAMA, STOK, DAN HARGA PRODUK
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    produk.nama,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 3),

                                  _buildBadgeStok(produk.stok),

                                  const SizedBox(height: 3),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatRupiah(produk.harga),
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),

                                      // TOMBOL TAMBAH PRODUK
                                      InkWell(
                                        onTap: produk.stok == 0 ? null : () {},
                                        borderRadius: BorderRadius.circular(15),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: produk.stok == 0
                                              ? Colors.grey.shade300
                                              : const Color(0xFF1E3A8A),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
