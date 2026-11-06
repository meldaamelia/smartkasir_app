// Mengimpor pustaka deteksi platform Flutter (untuk memeriksa peramban web kIsWeb)
import 'package:flutter/foundation.dart';
// Mengimpor pustaka inti SQLite untuk Flutter
import 'package:sqflite/sqflite.dart';
// Mengimpor pustaka penggabungan path direktori berkas lokal
import 'package:path/path.dart';
// Mengimpor implementasi SQLite FFI khusus peramban Web Google Chrome
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Mengimpor model data produk
import '../models/produk.dart';

// Kelas pengelola koneksi dan operasi basis data SQLite lokal SmartKasir
class DatabaseHelper {
  // --- 1. PENERAPAN DESIGN PATTERN SINGLETON ---
  // Deklarasi instansi statis tunggal kelas DatabaseHelper yang diakses dari seluruh widget
  static final DatabaseHelper instance = DatabaseHelper._init();

  // Variabel penampung objek koneksi database aktif (Nullable '?' sebelum diinisialisasi)
  static Database? _database;

  // Konstruktor privat: Mengunci kelas agar tidak dapat diinstansiasi dengan 'DatabaseHelper()' secara bebas
  DatabaseHelper._init();

  // --- 2. GETTER DATABASE ASINKRON ---
  // Mengembalikan koneksi database aktif yang sudah ada, atau menginisialisasi baru jika belum pernah dibuka
  Future<Database> get database async {
    // KONTROL PERCABANGAN LOGIKA: Jika objek database sudah hidup di memori, langsung kembalikan
    if (_database != null) return _database!;

    // Jika belum ada, inisialisasi berkas basis data baru
    _database = await _initDB('smartkasir.db');
    return _database!;
  }

  // --- 3. INISIALISASI BERKAS BASIS DATA (DUAL-PLATFORM CHROME & ANDROID) ---
  Future<Database> _initDB(String filePath) async {
    // KONTROL PERCABANGAN DUAL PLATFORM:
    // Jika aplikasi berjalan di Google Chrome (Flutter Web), gunakan web database factory
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        filePath,
        version: 1,
        onCreate:
            _createDB, // Callback pembentukan tabel saat pertama kali dibuat
      );
    }

    // Jika berjalan di smartphone Android fisik / emulator:
    final dbPath = await getDatabasesPath(); // Mengambil jalur folder basis data internal OS
    final path = join(
      dbPath,
      filePath,
    ); // Menggabungkan direktori dengan nama berkas 'smartkasir.db'

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // --- 4. DDL: PEMBUATAN STRUKTUR TABEL & SEEDING DATA AWAL ---
  Future _createDB(Database db, int version) async {
    // Eksekusi kueri DDL CREATE TABLE produk di database SQLite
    await db.execute('''
      CREATE TABLE produk (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode_produk TEXT UNIQUE,
        nama_produk TEXT NOT NULL,
        kategori TEXT NOT NULL,
        harga_beli REAL NOT NULL,
        harga_jual REAL NOT NULL,
        stok INTEGER NOT NULL,
        gambar_path TEXT,
        diskon_persen INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // --- KONTROL PERULANGAN: SEEDING OTOMATIS DATA AWAL KE SQLITE ---
    for (final produk in produkAwalSQLite) {
      await db.insert('produk', produk.toMap());
    }
  }

  // --- 5. DML CREATE: MENAMBAHKAN PRODUK BARU KE SQLITE ---
  Future<int> insertProduk(Produk produk) async {
    final db = await instance.database; // Mengambil koneksi database aktif
    // Mengeksekusi kueri INSERT dan mengembalikan auto-generated row ID
    final id = await db.insert(
      'produk',
      produk.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Jika kode produk duplikat, timpa data lama
    );
    return id;
  }

  // --- 6. DML READ: MENGAMBIL SELURUH DAFTAR PRODUK (KATALOG UTAMA) ---
  Future<List<Produk>> getAllProduk() async {
    final db = await instance.database;
    // Mengeksekusi kueri SELECT * FROM produk ORDER BY id DESC (Urutan produk terbaru di atas)
    final result = await db.query('produk', orderBy: 'harga_jual ASC');

    // Mengonversi List of Map menjadi List of Produk menggunakan perulangan .map()
    return result.map((json) => Produk.fromMap(json)).toList();
  }

  // --- 7. DML READ DENGAN FILTER KATEGORI: MENYARING PRODUK SESUAI CHIP ---
  Future<List<Produk>> getProdukByKategori(String kategori) async {
    final db = await instance.database;

    // KONTROL PERCABANGAN LOGIKA: Jika kategori 'Semua', ambil seluruh data
    if (kategori == 'Semua') {
      return await getAllProduk();
    }

    // Eksekusi kueri berparameter aman dari SQL Injection menggunakan where & whereArgs
    final result = await db.query(
      'produk',
      where: 'kategori = ?', // Klausa kondisi penyaringan
      whereArgs: [
        kategori,
      ], // Argumen nilai parameter yang disubstitusikan ke '?'
      orderBy: 'id DESC',
    );
    return result.map((json) => Produk.fromMap(json)).toList();
  }

  // --- 8. DML SEARCH: PENCARIAN PRODUK BERDASARKAN KATA KUNCI (SQL LIKE) ---
  Future<List<Produk>> searchProduk(String keyword) async {
    final db = await instance.database;
    // Eksekusi kueri SELECT dengan klausa LIKE untuk pencarian sebagian nama produk
    final result = await db.query(
      'produk',
      where: 'nama_produk LIKE ?',
      whereArgs: [
        '%$keyword%',
      ], // Wildcard '%' mencocokkan kata di awal, tengah, atau akhir
      orderBy: 'id DESC',
    );
    return result.map((json) => Produk.fromMap(json)).toList();
  }

  // --- 9. DML UPDATE: MEMPERBARUI DATA PRODUK DI SQLITE ---
  Future<int> updateProduk(Produk produk) async {
    final db = await instance.database;
    // Mengeksekusi kueri UPDATE produk SET ... WHERE id = ?
    return await db.update(
      'produk',
      produk.toMap(),
      where: 'id = ?', // Kondisi spesifik baris yang akan diperbarui
      whereArgs: [produk.id], // ID produk yang menjadi target perubahan
    );
  }

  // --- 10. DML DELETE: MENGHAPUS PRODUK DARI SQLITE BERDASARKAN ID ---
  Future<int> deleteProduk(int id) async {
    final db = await instance.database;
    // Mengeksekusi kueri DELETE FROM produk WHERE id = ?
    return await db.delete(
      'produk',
      where: 'id = ?', // Kondisi spesifik baris yang dihapus
      whereArgs: [id], // Parameter ID yang ditargetkan
    );
  }
}
