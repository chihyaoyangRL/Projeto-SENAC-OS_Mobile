import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ordem_services/utils/Strings.dart';

class Databases {
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "os.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $loginTable($idLoginColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nomeLoginColumn TEXT, $emailLoginColumn TEXT, $passwordLoginColumn TEXT,$telefoneLoginColumn TEXT,$cpfLoginColumn TEXT,$statusLoginColumn INT, $tokenLoginColumn TEXT);");
      await db.execute(
          "CREATE TABLE $logadoTable ($idLogadoColumn INTEGER PRIMARY KEY AUTOINCREMENT,$nomeLogadoColumn TEXT,$emailLogadoColumn TEXT,$login_idLogadoColumn INT,$statusColumn INT, $tokenColumn TEXT);");
    });
  }
}
