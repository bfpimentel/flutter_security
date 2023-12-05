library security;

import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class SecurityClient {

  static const String _keysTable = "keys";
  static const String _keysTableIdField = "id";
  static const String _keysTableValueField = "value";

  final Database _database;

  SecurityClient._(final Database database) : _database = database;

  static Future<SecurityClient> create(final String name, final String password) async {
    final database = await openDatabase(
        join(await getDatabasesPath(), "$name.db"),
        password: password,
        version: 1,
        onCreate: (database, version) {
          return database.execute(
              "CREATE TABLE $_keysTable($_keysTableIdField TEXT PRIMARY KEY, $_keysTableValueField TEXT)",
          );
        },
    );
    return SecurityClient._(database);
  }

  Future<void> add(final String key, final String value) async {
    final database = _database;
    await database.insert(
        _keysTable,
        {_keysTableIdField: key, _keysTableValueField: value},
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<String> get(final String key) async {
    final database = _database;
    final List<Map<String, dynamic>> values = await database.query(
        _keysTable,
        where: "$_keysTableIdField = ?",
        whereArgs: [key],
        limit: 1
    );

    return values[0][_keysTableIdField];
  }
}
