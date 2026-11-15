// Model data representasi entitas Karyawan pada SmartKasir
class Karyawan {
  // 1. ATRIBUT ENTITAS KARYAWAN
  // ID unik karyawan (auto increment di SQLite, bernilai null saat staf baru belum disimpan)
  final int? id;
  // Nama lengkap atau nama panggilan staf kasir
  final String namaKaryawan;
  // PIN pengaman 4 digit angka untuk otentikasi giliran shift kasir
  final String pin;
  // Peran tanggung jawab kerja: 'Kasir', 'Admin', atau 'Manajer'
  final String peran;

  // 2. KONSTRUKTOR MODEL KARYAWAN
  const Karyawan({
    this.id,
    required this.namaKaryawan,
    required this.pin,
    required this.peran,
  });

  // 3. METODE SERIALISASI (Dart Object -> Map<String, dynamic>)
  // Digunakan saat menyimpan data ke baris tabel SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_karyawan': namaKaryawan,
      'pin': pin,
      'peran': peran,
    };
  }

  // 4. METODE DESERIALISASI (Map<String, dynamic> -> Dart Object)
  // Digunakan saat merekonstruksi baris hasil kueri SQLite menjadi objek Dart
  factory Karyawan.fromMap(Map<String, dynamic> map) {
    return Karyawan(
      id: map['id'] as int?,
      namaKaryawan: map['nama_karyawan'] as String,
      pin: map['pin'] as String,
      peran: map['peran'] as String,
    );
  }
}

