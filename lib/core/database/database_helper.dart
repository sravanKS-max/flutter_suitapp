import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'customer_db.db');

    // bump version when schema changes so existing DBs get upgraded
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            address TEXT,
            type TEXT,
            email TEXT,
            mobile TEXT,
            city TEXT,
            country TEXT,
            phone TEXT,
            rateType TEXT,
            pinNo TEXT,
            gstinNo TEXT,
            place TEXT,
            customerType TEXT,
            discountPercentage TEXT,
            creditDays TEXT,
            imagePath TEXT,
            additionalImages TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // If the app previously created the DB without image columns,
        // add them when upgrading. Use try/catch to ignore if column exists.
        if (oldVersion < 2) {
          try {
            await db.execute('ALTER TABLE customers ADD COLUMN imagePath TEXT');
          } catch (_) {}
          try {
            await db.execute('ALTER TABLE customers ADD COLUMN additionalImages TEXT');
          } catch (_) {}
        }
      },
    );
  }
}
