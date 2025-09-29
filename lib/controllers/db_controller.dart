// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DbController extends GetxController {
  static Database? _database;
  final RxList<Map<String, dynamic>> mealHistories =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meal_calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create meal_histories table
        await db.execute('''
          CREATE TABLE meal_histories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total_paid INTEGER,
            total_meals INTEGER,
            meal_rate REAL,
            created_at TEXT
          )
        ''');

        // Create members table
        await db.execute('''
          CREATE TABLE members(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            history_id INTEGER,
            name TEXT,
            meals INTEGER,
            paid INTEGER,
            balance REAL,
            FOREIGN KEY (history_id) REFERENCES meal_histories(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<int> insertMealHistory({
    required int totalPaid,
    required int totalMeals,
    required double mealRate,
  }) async {
    final db = await database;
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final data = {
      'total_paid': totalPaid,
      'total_meals': totalMeals,
      'meal_rate': mealRate,
      'created_at': formattedDate,
    };

    return await db.insert('meal_histories', data);
  }

  Future<int> insertMember({
    required int historyId,
    required String name,
    required int meals,
    required int paid,
    required double balance,
  }) async {
    final db = await database;

    final data = {
      'history_id': historyId,
      'name': name,
      'meals': meals,
      'paid': paid,
      'balance': balance,
    };

    return await db.insert('members', data);
  }

  Future<void> loadMealHistories() async {
    try {
      isLoading.value = true;
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'meal_histories',
        orderBy: 'created_at DESC',
      );

      mealHistories.value = maps;
    } catch (e) {
      print('Error loading meal histories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> getMembersForHistory(int historyId) async {
    final db = await database;
    return await db.query(
      'members',
      where: 'history_id = ?',
      whereArgs: [historyId],
    );
  }

  Future<bool> deleteMealHistory(int id) async {
    try {
      isLoading.value = true;
      final db = await database;

      await db.delete(
        'members',
        where: 'history_id = ?',
        whereArgs: [id],
      );

      await db.delete(
        'meal_histories',
        where: 'id = ?',
        whereArgs: [id],
      );

      await loadMealHistories();
      return true;
    } catch (e) {
      print('Error deleting history: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadMealHistories();
  }

  Future<void> shareHistoryDetails(int historyId) async {
    try {
      final members = await getMembersForHistory(historyId);
      final history = mealHistories.firstWhere(
        (h) => h['id'] == historyId,
        orElse: () => {},
      );

      if (history.isEmpty || members.isEmpty) return;

      final totalPaid = history['total_paid'];
      final totalMeals = history['total_meals'];
      final mealRate = history['meal_rate'];
      final date = DateTime.parse(history['created_at']);
      final formattedDate = DateFormat('MMMM dd, yyyy - hh:mm a').format(date);

      // Create formatted text for sharing
      StringBuffer shareText = StringBuffer();
      shareText.writeln('🍽️ Meal Calculation History');
      shareText.writeln('=' * 30);
      shareText.writeln('📅 Date: $formattedDate');
      shareText.writeln();

      // Summary section
      shareText.writeln('📊 SUMMARY:');
      shareText.writeln('💰 Total Cost: ৳$totalPaid');
      shareText.writeln('🍽️ Total Meals: $totalMeals');
      shareText.writeln('📈 Meal Rate: ৳${mealRate.toStringAsFixed(2)}');
      shareText.writeln();

      // Individual balances section
      shareText.writeln('👥 INDIVIDUAL BALANCES:');
      shareText.writeln('-' * 25);

      for (var member in members) {
        final balance = member['balance'] as double;
        final isPositive = balance >= 0;
        final name = member['name'];
        final meals = member['meals'];
        final paid = member['paid'];

        shareText.writeln();
        shareText.writeln('👤 $name');
        shareText.writeln('   Meals: $meals | Paid: ৳$paid');

        if (isPositive) {
          shareText
              .writeln('   ✅ Received: ৳${balance.abs().toStringAsFixed(2)}');
        } else {
          shareText.writeln('   ❌ Paid: ৳${balance.abs().toStringAsFixed(2)}');
        }
      }

      shareText.writeln();
      shareText.writeln('Generated by Meal Calculator App 📱');

      // Share the formatted text
      Share.share(
        shareText.toString(),
        subject: 'Meal History - $formattedDate',
      );
    } catch (e) {
      print('Error sharing history: $e');
    }
  }
}
