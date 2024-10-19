import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar a tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    // Criar a tabela de chamados
    await db.execute('''
      CREATE TABLE calls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        km TEXT,
        license_plate TEXT,
        details TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
  }

  // CRUD operations para tabela users
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations para tabela calls
  Future<int> insertCall(Map<String, dynamic> call) async {
    final db = await database;
    return await db.insert('calls', call);
  }

  // Buscar todos os chamados sem filtro
  Future<List<Map<String, dynamic>>> getAllCalls() async {
    final db = await database;
    return await db.query('calls'); // Retorna todos os chamados
  }

  // Buscar chamados de um usuário específico
  Future<List<Map<String, dynamic>>> getCallsByUser(int userId) async {
    final db = await database;
    return await db.query('calls', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> updateCall(Map<String, dynamic> call) async {
    final db = await database;
    return await db.update('calls', call, where: 'id = ?', whereArgs: [call['id']]);
  }

  Future<int> deleteCall(int id) async {
    final db = await database;
    return await db.delete('calls', where: 'id = ?', whereArgs: [id]);
  }

  // Método para buscar o usuário pelo email e senha
  Future<List<Map<String, dynamic>>> getUsersByEmailAndPassword(String email, String password) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
  }

  // Método para buscar o usuário pelo ID
  Future<List<Map<String, dynamic>>> getUsersById(int id) async {
    final db = await database;
    return await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
