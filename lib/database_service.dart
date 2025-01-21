
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService _instance = DatabaseService._constructor();
  final String _gigsTableName = 'gigs';
  final String _id = 'id';
  final String _title = 'title';
  final String _imagePath = 'imagePath';
  final String _price = 'price';
  final String _description = 'description';

  DatabaseService._constructor();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_gigsTableName(
          $_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $_title TEXT NOT NULL,
          $_imagePath TEXT NOT NULL,
          $_price TEXT NOT NULL,
          $_description TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  Future<void> addValue({
    required String title,
    required String imagePath,
    required String price,
    required String description,
  }) async {
    try {
      final db = await database;
      await db.insert(
        _gigsTableName,
        {
          _title: title,
          _imagePath: imagePath,
          _price: price,
          _description: description,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error adding gig to the database: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getGigs() async {
    try {
      final db = await database;
      return await db.query(_gigsTableName);
    } catch (e) {
      print("Error fetching gigs: $e");
      return [];
    }
  }

  /// Method to delete a gig by ID
  Future<void> deleteGig(int id) async {
    try {
      final db = await database;
      await db.delete(
        _gigsTableName,
        where: '$_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting gig: $e");
    }
  }

  /// Method to update a gig
  Future<void> updateGig({
    required int id,
    required String title,
    required String imagePath,
    required String price,
    required String description,
  }) async {
    try {
      final db = await database;
      await db.update(
        _gigsTableName,
        {
          _title: title,
          _imagePath: imagePath,
          _price: price,
          _description: description,
        },
        where: '$_id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating gig: $e");
    }
  }

   static Future<void> deleteAllData() async {
    try {
      final db = await _instance.database;
      await db.delete(
        _instance._gigsTableName,
      );
      print("All data deleted from the database.");
    } catch (e) {
      print("Error deleting all data: $e");
    }
  }

}
