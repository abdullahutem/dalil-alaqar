import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dalil_alaqar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version for migration
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        // Verify the slides table exists and has the correct schema
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='slides'",
        );

        if (tables.isEmpty) {
          print('⚠️ Slides table does not exist, creating it...');
          await _createDB(db, 2);
        } else {
          print('✅ Slides table exists');
        }
      },
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop old slides table if it exists
      await db.execute('DROP TABLE IF EXISTS slides');

      // Create new slides table with updated schema
      await db.execute('''
        CREATE TABLE slides (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          image TEXT NOT NULL,
          link TEXT NOT NULL,
          position TEXT NOT NULL,
          "order" INTEGER NOT NULL,
          office_id INTEGER,
          start_date TEXT NOT NULL,
          end_date TEXT NOT NULL,
          views_count INTEGER NOT NULL,
          clicks_count INTEGER NOT NULL,
          is_active INTEGER NOT NULL,
          status TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE slides (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL,
        link TEXT NOT NULL,
        position TEXT NOT NULL,
        "order" INTEGER NOT NULL,
        office_id INTEGER,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        views_count INTEGER NOT NULL,
        clicks_count INTEGER NOT NULL,
        is_active INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        cached_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> clearAllData() async {}

  Future close() async {
    final db = await database;
    db.close();
  }
}
