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
      version: 2, // Incremented version
      onCreate: (db, version) async {
        await _createUsersTable(db);
        await _createDiseaseHistoryTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createDiseaseHistoryTable(db); // Create the new table
        }
      },
    );
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute(
      'CREATE TABLE users ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'username TEXT, '
          'email TEXT UNIQUE, '
          'password TEXT, '
          'profile_image TEXT)', // Added profile_image column
    );
  }

  Future<void> _createDiseaseHistoryTable(Database db) async {
    await db.execute(
      'CREATE TABLE disease_history ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'disease TEXT, '
          'confidence REAL, '
          'timestamp TEXT)',
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

  Future<void> insertDiseaseHistory(String disease, double confidence) async {
    final db = await database;
    await db.insert(
      'disease_history',
      {
        'disease': disease,
        'confidence': confidence,
        'timestamp': DateTime.now().toIso8601String(),
      },
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

  Future<List<Map<String, dynamic>>> getDiseaseHistory() async {
    final db = await database;
    return await db.query('disease_history', orderBy: 'timestamp DESC');
  }

  Future<void> clearDiseaseHistory() async {
    final db = await database;
    await db.delete('disease_history'); // Deletes all records from the table
  }

  Future<void> saveProfileImagePath(String username, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profile_image': imagePath}, // Updates the profile_image column
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}