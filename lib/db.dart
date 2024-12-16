import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  
  static Database? _database;
  static const String tableName = 'students';

  // هنا بكريت الداتا بيز بتاعتي
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'student_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT)");
      },
      version: 1,
    );
  }

  // هنا بحط الداتا الجديده
  Future<void> insertStudent(Map<String, dynamic> student) async {
    final db = await database;
    await db.insert(tableName, student);
  }

  // بجيب الداتا
  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await database;
    return db.query(tableName);
  }

  // بحدث الداتا
  Future<void> updateStudent(int id, Map<String, dynamic> student) async {
    final db = await database;
    await db.update(tableName, student, where: 'id = ?', whereArgs: [id]);
  }

  // بحذف الداتا
  Future<void> deleteStudent(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}