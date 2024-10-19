import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/city_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cities.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE cities (id INTEGER PRIMARY KEY, kode VARCHAR(5), name VARCHAR(255))',
        );
        print('Database created');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('Upgrade database from $oldVersion to $newVersion');
        await db.execute('DROP TABLE IF EXISTS cities');
        await db.execute(
          'CREATE TABLE cities (id INTEGER PRIMARY KEY, kode VARCHAR(5), name VARCHAR(255))',
        );
        print('Database upgraded');
      },
    );
  }

  // Insert city into the database
  Future<void> insertCity(int id, kode, name) async {
    final dbClient = await db;
    await dbClient.insert(
      'cities',
      {'id': id, 'kode': kode, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all cities from the database
  Future<List<City>> getAllCities() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> results = await dbClient.query('cities');
    return results.map((cityMap) => City(
        id: cityMap['id'] as int,
        kode: cityMap['kode'] as String,
        name: cityMap['name'] as String)
    ).toList();
  }

  // Search for cities in the database based on a keyword
  Future<List<City>> searchCity(String keyword) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> results = await dbClient.query(
      'cities',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
    );

    return results.map((cityMap) => City.fromJson(cityMap)).toList(); // Convert to List<City>
  }
}
