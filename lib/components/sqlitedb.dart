import 'package:path/path.dart';
import 'package:rentalcar/models/carride.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase(); //place where dabacase should be build and initializing it
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'sakshi.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE CarRide (
        id TEXT PRIMARY KEY,
        carName TEXT,
        price REAL,
        fromAddress TEXT,
        toAddress TEXT,
        distance REAL,
        name TEXT,
        email TEXT,
        phoneNumber TEXT,
        carImage TEXT
      )
    ''');
  }

  Future<int> insertCarRide(CarRide carRide) async {
    Database db = await instance.database;
    return await db.insert('CarRide', carRide.toMap());
  }

  Future<List<CarRide>> getAllCarRides() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('CarRide');
    return List.generate(maps.length, (i) {
      return CarRide(
        id: maps[i]['id'],
        carName: maps[i]['carName'],
        price: maps[i]['price'],
        fromAddress: maps[i]['fromAddress'],
        toAddress: maps[i]['toAddress'],
        distance: maps[i]['distance'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        phoneNumber: maps[i]['phoneNumber'],
        carImage: maps[i]['carImage'],
      );
    });
  }
}