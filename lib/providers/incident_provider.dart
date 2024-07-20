import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incident.dart';

class IncidentProvider with ChangeNotifier {
  late Database _database;

  Future<void> initialize() async {
    _database = await _initDB();
    notifyListeners();
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

  Future<void> insertIncident(Incident incident) async {
    await initialize();
    final db = _database;
    await db.insert('incidents', incident.toMap());
    notifyListeners();
  }

  Future<List<Incident>> getIncidents() async {
    await initialize();
    final db = _database;
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

  Future<void> deleteAllIncidents() async {
    await initialize();
    final db = _database;
    await db.delete('incidents');
    notifyListeners();
  }
}
