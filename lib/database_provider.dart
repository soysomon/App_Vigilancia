import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incident.dart';

class DatabaseProvider {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await _initDB();
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'incidents.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE incidents(id INTEGER PRIMARY KEY, title TEXT, date TEXT, description TEXT, photoPath TEXT, audioPath TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    await initDatabase(); // Asegúrate de inicializar la base de datos antes de devolverla
    return _database;
  }
  Future<void> insertIncident(Incident incident) async {
    final db = await database;
    await db.insert(
      'incidents',
      incident.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Incident>> getIncidents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incidents');

    return List.generate(maps.length, (i) {
      return Incident(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        description: maps[i]['description'],
        photoPath: maps[i]['photoPath'],
        audioPath: maps[i]['audioPath'],
      );
    });
  }

  Future<void> updateIncident(Incident incident) async {
    final db = await database;
    await db.update(
      'incidents',
      incident.toMap(),
      where: 'id = ?',
      whereArgs: [incident.id],
    );
  }

  Future<void> deleteIncident(int id) async {
    final db = await database;
    await db.delete(
      'incidents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
