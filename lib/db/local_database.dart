import 'package:contact_app/db/cached_contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;

  factory LocalDatabase() {
    return getInstance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("contacts.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";
    const boolType = 'BOOLEAN NOT NULL';
//TODO 2 Create table

    await db.execute('''
      CREATE TABLE $contactsTable(
      ${CachedContactsFields.id} $idType,
      ${CachedContactsFields.phone} $textType,
      ${CachedContactsFields.fullName} $textType
      )
      ''');
  }

  LocalDatabase._init();

//-------------------------------------------Cached Contacts Table------------------------------------

  static Future<CachedContact> insertCachedContacts(
      CachedContact cachedContact) async {
    final db = await getInstance.database;
    final id = await db.insert(contactsTable, cachedContact.toJson());
    return cachedContact.copyWith(id: id);
  }

  static Future<CachedContact> getSingleContactsById(int id) async {
    final db = await getInstance.database;
    final results = await db.query(
      contactsTable,
      columns: CachedContactsFields.values,
      where: '${CachedContactsFields.id} = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return CachedContact.fromJson(results.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<List<CachedContact>> getAllCachedContacts() async {
    final db = await getInstance.database;
    final result = await db.query(
      contactsTable,
    );
    return result.map((json) => CachedContact.fromJson(json)).toList();
  }

  static Future<int> deleteCachedConactsById(int id) async {
    final db = await getInstance.database;
    var t = await db.delete(contactsTable,
        where: "${CachedContactsFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedCategory(
      {required CachedContact cachedContact}) async {
    Map<String, dynamic> row = {
      CachedContactsFields.phone: cachedContact.phone,
      CachedContactsFields.fullName: cachedContact.fullName,
    };
    final db = await getInstance.database;
    return await db.update(contactsTable, row,
        where: '${CachedContactsFields.id} = ?', whereArgs: [cachedContact.id]);
  }

  static Future<int> deleteAllCachedCategories() async {
    final db = await getInstance.database;
    return await db.delete(contactsTable);
  }

  static Future<int> updateCachedContacts(CachedContact cachedContact) async {
    Map<String, dynamic> row = {
      CachedContactsFields.fullName: cachedContact.fullName,
      CachedContactsFields.phone: cachedContact.phone,
    };

    final db = await getInstance.database;
    return await db.update(
      contactsTable,
      row,
      where: '${CachedContactsFields.id} = ?',
      whereArgs: [cachedContact.id],
    );
  }

  Future close() async {
    final db = await getInstance.database;
    db.close();
  }
}
