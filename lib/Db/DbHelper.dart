import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "budget_buddy.db";
  static const _databaseVersion = 1;

  static const tableCategories = 'categories';
  static const tableTransactions = 'transactions';
  static const tableAppSettings = 'appSettings';

  static const colId = '_id';
  static const colType = 'type';
  static const colTitle = 'title';
  static const colIcon = 'icon';

  // Add constants for the transactions table
  static const colAmount = 'amount';
  static const colRemarks = 'remarks';
  static const colDateTime = 'dateTime';
  static const colCategory = 'category';
  static const colTime = 'time';

  // Constants to store app Settings
  static const colAppTheme = 'appTheme';
  static const colThemeColor = 'themeColor';
  static const colCurrency = 'currency';
  static const colGetNotifications = 'getNotifications';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Opens the database and creates it if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Creates the categories and transactions and appSettings tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableCategories (
      $colId INTEGER PRIMARY KEY,
      $colType TEXT NOT NULL,
      $colTitle TEXT NOT NULL,
      $colIcon TEXT NOT NULL -- Change the data type to INTEGER for icon
    )
  ''');

    // Initial data for categories
    List<Map<String, dynamic>> initialCategoriesData = [
      {"type": "Expense", "title": "Food & Drinks", "icon": "0xE390"},
      {"type": "Expense", "title": "Transportation", "icon": "0x0E1D5"},
      {"type": "Expense", "title": "Fuel", "icon": "0xF07B7"},
      {"type": "Expense", "title": "Health", "icon": "0x0E0E3"},
      {"type": "Expense", "title": "Household", "icon": "0x0E328"},
      {"type": "Expense", "title": "Lost", "icon": "0x0E517"},
      {"type": "Income", "title": "Salary", "icon": "0x0E6F2"},
      {"type": "Income", "title": "Dakshina", "icon": "0x0E52F"},
      {"type": "Income", "title": "Cashback", "icon": "0xF04DC"},
      {"type": "Income", "title": "Found", "icon": "0x0E04F"},
    ];

    // Insert the initial data into the categories table
    for (var categoryData in initialCategoriesData) {
      await db.insert(tableCategories, categoryData);
    }

    await db.execute('''
      CREATE TABLE $tableTransactions (
        $colId INTEGER PRIMARY KEY,
        $colType TEXT NOT NULL,
        $colTitle TEXT NOT NULL,
        $colAmount TEXT NOT NULL,
        $colRemarks TEXT,
        $colDateTime TEXT,
        $colTime TEXT,
         $colCategory INTEGER NOT NULL, -- The new category column
        FOREIGN KEY ($colCategory) REFERENCES $tableCategories($colId) -- Establish a foreign key constraint
      )
    ''');

    // Create app settings table

    await db.execute('''
    CREATE TABLE $tableAppSettings (
      $colId INTEGER PRIMARY KEY,
      $colAppTheme TEXT NOT NULL,
      $colThemeColor TEXT NOT NULL,
      $colCurrency TEXT NOT NULL,
      $colGetNotifications INTEGER NOT NULL
    )
  ''');
    dynamic initialAppSetting = {
      "appTheme": "Light",
      "themeColor": "Colors.red",
      "currency": "NRS",
      "getNotifications": 1
    };

    await db.insert(tableAppSettings, initialAppSetting);
  }

  // Insert a new category into the database
  Future<int> insertCategory(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableCategories, row);
  }

  // Insert a new transaction into the database
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableTransactions, row);
  }

  // Update a category in the database
  Future<int> updateCategory(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[colId];
    return await db!
        .update(tableCategories, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Update a transaction in the database
  Future<int> updateTransaction(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[colId];
    return await db!
        .update(tableTransactions, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Update the appSettings in the database
  Future<int> updateAppSettings(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[colId];

    return await db!
        .update(tableAppSettings, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Delete a category from the database
  Future<int> deleteCategory(int id) async {
    Database? db = await instance.database;
    return await db!
        .delete(tableCategories, where: '$colId = ?', whereArgs: [id]);
  }

  // Delete a transaction from the database
  Future<int> deleteTransaction(int id) async {
    Database? db = await instance.database;
    return await db!
        .delete(tableTransactions, where: '$colId = ?', whereArgs: [id]);
  }

  // Delete all categories from the database
  Future<int> deleteAllCategories() async {
    Database? db = await instance.database;
    return await db!.delete(tableCategories);
  }

  // Delete all transactions from the database
  Future<int> deleteAllTransactions() async {
    Database? db = await instance.database;
    return await db!.delete(tableTransactions);
  }

  // Get all categories from the database
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    Database? db = await instance.database;
    return await db!.query(tableCategories);
  }

  // Get all transactions from the database
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    Database? db = await instance.database;
    return await db!.query(tableTransactions);
  }

  // Get the appSettings from the database
  Future<List<Map<String, dynamic>>> getAppSettings() async {
    Database? db = await instance.database;
    return await db!.query(tableAppSettings);
  }

  // Add the getCategoryById method
  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(
      tableCategories,
      where: '$colId = ?',
      whereArgs: [categoryId],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Add the getTransactionById method
  Future<Map<String, dynamic>?> getTransactionById(int transactionId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> result = await db!.query(
      tableTransactions,
      where: '$colId = ?',
      whereArgs: [transactionId],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
