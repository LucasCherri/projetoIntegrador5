import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Db {
  static Future<mongo.Db> getConnection() async {
    final db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.6udflvk.mongodb.net/authentication?retryWrites=true&w=majority");
    await db.open();
    return db;
  }

  static Future<mongo.Db> getConnectionImoveis() async {
    final db = await mongo.Db.create("mongodb+srv://lucascherri:lucascherri@cluster0.6udflvk.mongodb.net/imoveis?retryWrites=true&w=majority");
    await db.open();
    return db;
  }
}