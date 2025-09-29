import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meal_calculator.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meal_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        total_meals INTEGER,
        total_paid INTEGER,
        meal_rate REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        history_id INTEGER,
        name TEXT,
        meals INTEGER,
        paid INTEGER,
        balance REAL,
        FOREIGN KEY (history_id) REFERENCES meal_history (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> saveMealHistory(DateTime date, int totalMeals, int totalPaid,
      double mealRate, List<Map<String, dynamic>> members) async {
    final db = await database;

    await db.transaction((txn) async {
      int historyId = await txn.insert('meal_history', {
        'date': date.toIso8601String(),
        'total_meals': totalMeals,
        'total_paid': totalPaid,
        'meal_rate': mealRate,
      });

      for (var member in members) {
        await txn.insert('members', {
          'history_id': historyId,
          'name': member['name'],
          'meals': member['meals'],
          'paid': member['paid'],
          'balance': member['balance'],
        });
      }

      return historyId;
    });

    return 1;
  }

  Future<List<Map<String, dynamic>>> getMealHistories() async {
    final db = await database;
    return await db.query('meal_history', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getMembersForHistory(int historyId) async {
    final db = await database;
    return await db.query(
      'members',
      where: 'history_id = ?',
      whereArgs: [historyId],
    );
  }

  Future<int> deleteHistory(int historyId) async {
    final db = await database;
    return await db.delete(
      'meal_history',
      where: 'id = ?',
      whereArgs: [historyId],
    );
  }
}
