import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""CREATE TABLE user_info(
    userId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    firstName TEXT, 
    lastName TEXT, 
    mobile TEXT, 
    email TEXT, 
    dateTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    // isEdit TEXT,
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      'UserInfo.db',
      version: 1,
      onCreate: (sql.Database database,int version) async{
        print('table created');
        await createTables(database);
      }
    );
  }

  static Future<int> createData(String firstName,String lastName,String mobile,String email) async{
    final db = await SQLHelper.db();
    final data = {'firstName':firstName,'lastName':lastName,'mobile':mobile,'email':email};
    final id = await db.insert('user_info',data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('data inserted');
    return id;
  }

  static Future<List<Map<String,dynamic>>> getDataItems() async{
    final db = await SQLHelper.db();
    print('all fetch');
    return db.query('user_info',orderBy: 'userId');
  }

  static Future<List<Map<String,dynamic>>> getDataItem(int userId) async{
    final db = await SQLHelper.db();
    print('1 item fetch');
    return db.query('user_info',where: 'userId = ?',whereArgs: [userId],limit: 1);
  }

  static Future<int> updateDataItem(int userId, String firstName,String lastName,String mobile,String email) async{
    final db = await SQLHelper.db();
    final data = {'firstName':firstName,'lastName':lastName,'mobile':mobile,'email':email,'dateTime':DateTime.now().toString()};
    final result = await db.update('user_info',data,where: 'userId = ?',whereArgs: [userId]);
    print('record updated');
    return result;
  }

  static Future<void> deleteDataItem(int userId)async{
    final db = await SQLHelper.db();
    try{
      await db.delete('user_info',where: 'userId = ?',whereArgs: [userId]);
      print('record deleted');
    }catch(error){
      debugPrint('Something went wrong while deleting an data record: $error');
    }
  }
}