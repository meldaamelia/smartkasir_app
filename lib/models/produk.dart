// Blueprint / Struktur Data (Model) untuk merepresentasikan entitas barang dagangan kasir
class Produk {
  // --- DEKLARASI VARIABEL ATRIBUT MODEL (PROPERTIES) ---
  final int id; // Deklarasi variabel identitas unik produk (Tipe: Integer, Immutable/Tetap)
  final String nama; // Deklarasi variabel nama barang dagangan (Tipe: String)
  final String kategori; // Deklarasi variabel kelompok kategori: Makanan/Minuman/Snack (Tipe: String)
  final double harga; // Deklarasi variabel harga jual satuan dalam Rupiah (Tipe: Double/Desimal)
  final int stok; // Deklarasi variabel sisa jumlah persediaan unit barang di toko (Tipe: Integer)
  final String gambarUrl; // Deklarasi variabel tautan URL foto produk dari internet (Tipe: String)
  final int diskonPersen; // Deklarasi variabel nilai promo potongan harga dalam persen (Tipe: Integer)

  // Konstruktor konstan: Membuat objek Produk baru dengan parameter wajib (required) dan nilai default
  const Produk({
    required this.id, // Parameter wajib: ID unik tidak boleh kosong saat membuat produk
    required this.nama, // Parameter wajib: Nama produk harus diisi
    required this.kategori, // Parameter wajib: Kategori produk harus diisi
    required this.harga, // Parameter wajib: Harga produk harus diisi
    required this.stok, // Parameter wajib: Stok produk harus diisi
    required this.gambarUrl, // Parameter wajib: Tautan foto produk harus diisi
    this.diskonPersen = 0, // Parameter opsional: Nilai default 0 (jika produk tidak memiliki diskon promo)
  });
}

// --- DEKLARASI VARIABEL LIST KOLEKSI DATA DUMMY PRODUK ---
// Variabel kumpulan objek produk (Array of Objects) untuk simulasi transaksi katalog kasir tanpa database
final List<Produk> daftarProdukDummy = [
  const Produk(
    id: 1,
    nama: 'Kopi Susu Gula Aren 250ml',
    kategori: 'Minuman',
    harga: 18000,
    stok: 24, // Persediaan aman (> 5) -> Logika badge akan menampilkan warna hijau
    gambarUrl:
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=300',
    diskonPersen: 20, // Menambahkan diskon promo 20% khusus produk ini
  ),
  const Produk(
    id: 2,
    nama: 'Roti Bakar Cokelat Keju',
    kategori: 'Makanan',
    harga: 15000,
    stok: 5, // Persediaan menipis/kritis (<= 5) -> Logika badge akan menampilkan warna kuning
    gambarUrl:
        'https://images.unsplash.com/photo-1584776296944-ab6fb57b0bdd?w=300',
  ),
  const Produk(
    id: 3,
    nama: 'Matcha Latte Ice',
    kategori: 'Minuman',
    harga: 22000,
    stok: 0, // Persediaan habis (== 0) -> Logika badge merah dan tombol dinonaktifkan
    gambarUrl:
        'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=300',
  ),
  const Produk(
    id: 4,
    nama: 'Nasi Goreng Banjar Spesial',
    kategori: 'Makanan',
    harga: 25000,
    stok: 12, // Persediaan aman
    gambarUrl:
        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300',
    diskonPersen: 10, // Memiliki promo diskon 10% -> Logika percabangan akan menampilkan badge diskon
  ),
  const Produk(
    id: 5,
    nama: 'Kentang Goreng Crispy',
    kategori: 'Snack',
    harga: 12000,
    stok: 18,
    gambarUrl:
        'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=300',
  ),
  const Produk(
    id: 6,
    nama: 'Air Mineral Botol 600ml',
    kategori: 'Minuman',
    harga: 5000,
    stok: 40,
    gambarUrl:
        'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=300',
  ),
];
