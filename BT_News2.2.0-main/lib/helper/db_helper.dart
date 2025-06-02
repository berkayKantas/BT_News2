import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // SQLite veritabanı nesnesi (singleton olacak şekilde tanımlanıyor)
  static Database? _db;
  // Veritabanını başlatır ve döndürür. Zaten başlatılmışsa mevcut olanı döndürür.
  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    // Veritabanı yolu ve adı birleştirilerek 'user_profile.db' dosyası oluşturulur
    _db = await openDatabase(
      join(await getDatabasesPath(), 'user_profile.db'),
      version: 1,
      // Veritabanı ilk kez oluşturulurken çalışacak fonksiyon
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT, -- Otomatik artan birincil anahtar
            uid TEXT, -- Firebase kullanıcı kimliği
            email TEXT, -- Kullanıcının e-posta adresi
            firstName TEXT, -- Kullanıcının adı
            lastName TEXT  -- Kullanıcının soyadı
          )
        ''');
      },
    );
    return _db!;
  }

  // Kullanıcı verisini tabloya ekler. Önceki kayıt varsa silinir.
  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await getDb();
    await db.delete(
      'user_profile',
    ); // Her eklemeden önce eski kayıt silinir (tek kullanıcı için uygun)
    await db.insert('user_profile', user); // Yeni kullanıcı verisi eklenir
  }

  // Veritabanındaki kullanıcı verisini getirir. Veri varsa ilk kaydı döndürür.
  static Future<Map<String, dynamic>?> getUser() async {
    final db = await getDb();
    final result = await db.query('user_profile');
    if (result.isNotEmpty) return result.first; // Kayıt varsa döndür
    return null; // Kayıt yoksa null döndür
  }
}
