import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'username TEXT, '
              'email TEXT UNIQUE, ' // Add UNIQUE constraint
              'password TEXT)',
        );
      },
    );
  }

  Future<void> insertUser(String username, String email, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserByUsernameAndPassword(String username, String password) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty; // Returns true if the email exists
  }
}