import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase._init();

  static Database? _database;

  ExpenseDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('expenses.db');

    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        order_index INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertExpense(Expense expense,  int orderIndex,) async {
    final db = await database;

    return await db.insert(
      'expenses',
      {
        'id': expense.id,
        'title': expense.tital,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category.name,
        'order_index': orderIndex,
      },
    );
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;

    final result = await db.query(
      'expenses',
      orderBy: 'order_index ASC',
    );

    return result.map((map) {
      return Expense(
        id: map['id'] as String,
        tital: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        category: Category.values.firstWhere(
              (category) => category.name == map['category'],
        ),
      );
    }).toList();
  }

  Future<int> deleteExpense(String id) async {
    final db = await database;

    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}