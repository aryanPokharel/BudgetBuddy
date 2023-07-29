import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "budget_buddy.db";
  static const _databaseVersion = 1;

  static const table = 'categories';

  static const colId = '_id';
  static const colTitle = 'title';
  static const colIcon = 'icon';

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

  // Creates the tasks table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $colId INTEGER PRIMARY KEY,
        $colTitle TEXT NOT NULL,
        $colIcon Text NOT NULL
      )
    ''');
  }

  // Insert a new task into the database
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  // Update a task in the database
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[colId];
    return await db!.update(table, row, where: '$colId = ?', whereArgs: [id]);
  }

  // Delete a task from the database
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$colId = ?', whereArgs: [id]);
  }

  // Delete the table
  Future<int> deleteAll() async {
    Database? db = await instance.database;
    return await db!.delete(table);
  }

  // Get all tasks from the database
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }
}
