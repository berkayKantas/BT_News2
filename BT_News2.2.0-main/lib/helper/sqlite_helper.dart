import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static Database? _db;

  // Veritabanını başlatır ve bağlantıyı döner (singleton olarak çalışır)
  static Future<Database> initDb() async {
    if (_db != null) return _db!; // Eğer veritabanı zaten açıksa onu döner

    // Veritabanı dosyasının yolu
    final path = join(await getDatabasesPath(), 'users.db');

    // Veritabanını oluştur veya aç
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // İlk oluşturma sırasında 'users' tablosunu oluştur
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Otomatik artan ID
            email TEXT NOT NULL,                   -- Zorunlu alan
            name TEXT,                             -- Kullanıcı adı
            surname TEXT,                          -- Kullanıcı soyadı
            password TEXT                          -- Şifre (şifreleme önerilir)
          )
        ''');
      },
    );
    return _db!;
  }

  // Yeni kullanıcı verisini 'users' tablosuna ekler
  static Future<void> insertUser({
    required String email,
    required String name,
    required String surname,
    required String password,
  }) async {
    final db = await initDb();
    await db.insert('users', {
      'email': email,
      'name': name,
      'surname': surname,
      'password': password,
    });
  }

  // Belirli bir e-posta adresine göre kullanıcıyı getirir
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await initDb();
    final result = await db.query(
      'users',
      where: 'email = ?', // Eşleşecek alan
      whereArgs: [email], // Sorguya bağlanacak argüman
    );
    return result.isNotEmpty
        ? result.first
        : null; // Veri varsa ilk kaydı döner
  }
}
