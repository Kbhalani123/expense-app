import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''  
          CREATE TABLE users(  
            id INTEGER PRIMARY KEY AUTOINCREMENT,  
            email TEXT,  
            password TEXT  
          )  
        ''');
        await db.execute('''  
          CREATE TABLE expenses(  
            id INTEGER PRIMARY KEY AUTOINCREMENT,  
            name TEXT,  
            description TEXT,  
            amount REAL,  
            userId INTEGER,  
            FOREIGN KEY (userId) REFERENCES users (id)  
          )  
        ''');
      },
    );
  }

  Future<void> addUser(String email, String password) async {
    final db = await database;
    await db.insert('users', {'email': email, 'password': password});
  }

  Future<int> getUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return users.isNotEmpty ? users.first['id'] : -1;
  }

  Future<void> addExpense(String name, String description, double amount, int userId) async {
    final db = await database;
    await db.insert('expenses', {
      'name': name,
      'description': description,
      'amount': amount,
      'userId': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getExpenses(int userId) async {
    final db = await database;
    return await db.query('expenses', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> updateExpense(int id, String name, String description, double amount) async {
    final db = await database;
    await db.update(
      'expenses',
      {'name': name, 'description': description, 'amount': amount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}