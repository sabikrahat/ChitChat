import 'dart:io';
import 'package:chitchat/models/user_profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  static final _dbName = 'chitchat.db';
  static final _dbVersion = 1;

  static final _tableName = 'users';

  static final columnUid = '_uid';
  static final columnProfileName = 'profileName';
  static final columnUsername = 'username';
  static final columnPhotoUrl = 'photoUrl';
  static final columnEmail = 'email';
  static final columnIntro = 'intro';
  static final columnLocation = 'location';
  static final columnTimeStamp = 'timeStamp';
  static final columnType = 'type';
  static final columnStatus = 'status';
  static final columnTokenId = 'tokenId';
  static final columnTotalPost = 'totalPost';
  static final columnTotalStar = 'totalStar';
  static final columnTotalPoint = 'totalPoint';

  //making it a singleton class
  SQLiteHelper._privateConstructor();
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<dynamic> _onCreate(Database db, int version) {
    return db.execute('''
    CREATE TABLE $_tableName (
        $columnUid TEXT PRIMARY KEY,
        $columnProfileName TEXT NOT NULL,
        $columnUsername TEXT NOT NULL,
        $columnPhotoUrl TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnIntro TEXT,
        $columnLocation TEXT,
        $columnTimeStamp TEXT NOT NULL,
        $columnType TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnTokenId TEXT NOT NULL,
        $columnTotalPost INT NOT NULL,
        $columnTotalStar INT NOT NULL,
        $columnTotalPoint INT NOT NULL,
      )
      ''');
  }

  Future<dynamic> insert(UserProfile userProfile) async {
    Database db = await instance.database;
    var valuesMap = ({
      "uid": userProfile.uid,
      "profileName": userProfile.profileName,
      "username": userProfile.username,
      "photoUrl": userProfile.photoUrl,
      "email": userProfile.email,
      "intro": userProfile.intro,
      "location": userProfile.location,
      "timeStamp": userProfile.timeStamp,
      "type": userProfile.type,
      "status": userProfile.status,
      "tokenId": userProfile.tokenId,
      "totalPost": userProfile.totalPost,
      "totalStar": userProfile.totalStar,
      "totalPoint": userProfile.totalPoint,
    });
    return await db.insert(_tableName, valuesMap);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<dynamic> update(Map<String, dynamic> valuesUpdatedMap) async {
    Database db = await instance.database;
    return await db.update(_tableName, valuesUpdatedMap,
        where: '$columnUid = ?', whereArgs: [valuesUpdatedMap[columnUid]]);
  }

  Future<dynamic> delete(String uid) async {
    Database db = await instance.database;
    return await db
        .delete(_tableName, where: '$columnUid = ?', whereArgs: [uid]);
  }
}
