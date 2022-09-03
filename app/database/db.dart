import 'package:mongo_dart/mongo_dart.dart';

import '../../routes/auth/register.dart';
import '../locator.dart';
import 'models/base/collections.dart';

class AppExceptions implements Exception {
  AppExceptions({required this.messgae});
  final String messgae;
  @override
  String toString() {
    return messgae;
  }
}

class LogicEception implements Exception {}

class AppDatabase {
  Db? _db;
  Db get db => _db ?? Db('h');
  Future<bool> initDatabase() async {
    try {
      //s
      print('Sd');
      _db ??= await Db.create(
          'mongodb+srv://chasseuragaceDB1:2KhB8cKuHG94sjC@cluster0.guoul.mongodb.net/myFirstDatabase?retryWrites=true');
      await _db?.open();
      print('connected to database');
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Collection<T> {
  Coll? data;

  Future<Map<String, dynamic>?> save(Coll data,
      {Map<String, dynamic>? check}) async {
    final collection = appDb.db.collection(T.toString());
    if (check != null) {
      final alreadyExists = await collection.findOne(check);
      if (alreadyExists != null) throw LogicEception();
    }
    try {
      final baka = await collection.insertOne(data.toMap());

      return baka.document;
    } on LogicEception catch (e) {
      rethrow;
    } on Exception catch (e) {
      throw AppExceptions(messgae: 'Operation failed $e');
    }
  }

  Future<Map<String, dynamic>> findBy(Map<String, dynamic> data) async {
    try {
      final collection = appDb.db.collection(T.toString());
      final result = await collection.findOne(data);
      if (result == null) throw LogicEception();

      return result;
    } on LogicEception {
      rethrow;
    } catch (e) {
      throw AppExceptions(messgae: e.toString());
    }
  }

  Future<Map<String, dynamic>?> update(
    Map<String, dynamic> old,
    Map<String, dynamic> newData,
  ) async {
    try {
      print("$old $newData");
      final collection = appDb.db.collection(T.toString());
      return collection.findAndModify(
        query: old,
        update: newData,
        returnNew: true,
      );
    } on Exception catch (e) {
      throw AppExceptions(messgae: e.toString());
    }
  }

/*
  update(Map<String, dynamic> old, dynamic data) async {
    var update = data.toJson() as Map<String, dynamic>;
    var oldSaved = Map<String, dynamic>.from(old);
    old.updateAll((key, value) => update[key] ?? value);
    update.forEach((key, value) {
      old.putIfAbsent(key, () => value);
    });
    String collectionName = data.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    return await collections[collectionName]
        ?.findAndModify(query: oldSaved, update: old, returnNew: true);
  }

  delete(dynamic type, dynamic data) async {
    String collectionName = type.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    var result = await collections[collectionName]?.deleteOne(data);

    return result;
  }

  getAll(dynamic data) async {
    String collectionName = data.runtimeType.toString();
    collections.putIfAbsent(
        collectionName, () => database._db.collection(collectionName));
    var result =
        await collections[collectionName]?.find(data.toJson()).toList();

    return result;
  }

  

  findById(dynamic data, String id) async {
    try {
      String collectionName = data.runtimeType.toString();
      collections.putIfAbsent(
          collectionName, () => database._db.collection(collectionName));
      var result = await collections[collectionName]
          ?.findOne({"_id": ObjectId.fromHexString(id)});

      return result;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
*/
}
