import 'dart:developer';

import 'package:app_models/models/base/collections.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../error/errors.dart';
import '../locator.dart';

class AppDatabase {
  Db? _db;
  Db get db => _db ?? Db('h');
  Future<bool> initDatabase() async {
    try {
      _db ??= await Db.create(
        'mongodb+srv://chasseuragaceDB1:2KhB8cKuHG94sjC@cluster0.guoul.mongodb.net/myFirstDatabase?retryWrites=true',
      );
      await _db?.open();
      log('connected to database');
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Collection<T> {
  Coll? data;

  Future<Map<String, dynamic>> save(
    Coll data, {
    Map<String, dynamic>? check,
  }) async {
    final collection = appDb.db.collection(T.toString());
    if (check != null) {
      final alreadyExists = await collection.findOne(check);
      if (alreadyExists != null) {
        throw AppExceptions(message: 'Check failed');
      }
    }
    try {
      final result = await collection.insertOne(data.toMap());
      final doc = result.document ?? <String, dynamic>{};
      return Map<String, dynamic>.from(doc);
    } on Exception catch (e) {
      if (e is AppExceptions) rethrow;
      throw AppExceptions(message: 'Operation failed $e');
    }
  }

  Future<Map<String, dynamic>> findBy(Map<String, dynamic> data) async {
    try {
      final collection = appDb.db.collection(T.toString());
      final result = await collection.findOne(data);
      if (result == null) throw AppExceptions(message: 'Not found');

      return result;
    } catch (e) {
      if (e is AppExceptions) rethrow;
      throw AppExceptions(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> update(
    Map<String, dynamic> old,
    Map<String, dynamic> newData,
  ) async {
    try {
      final collection = appDb.db.collection(T.toString());
      final existing = await findBy(old);
      existing.updateAll((key, value) => newData[key] ?? value);
      List<String>.from(newData.keys)
        ..removeWhere((element) => existing.keys.contains(element))
        ..forEach((element) {
          existing.putIfAbsent(
            element,
            () => newData[element],
          );
        });
      final result = await collection.findAndModify(
        query: old,
        update: existing,
        returnNew: true,
      );
      if (result == null) throw AppExceptions(message: 'Action Failed');
      return result;
    } on Exception catch (e) {
      if (e is AppExceptions) rethrow;
      throw AppExceptions(message: e.toString());
    }
  }

  Future<bool> delete(String id) async {
    try {
      final collection = appDb.db.collection(T.toString());

      final result = await collection.deleteOne(
        {'_id': ObjectId.fromHexString(id)},
      );
      if (result.isFailure) throw AppExceptions(message: 'Action Failed');
      return result.isSuccess;
    } on Exception catch (e) {
      if (e is AppExceptions) rethrow;
      throw AppExceptions(message: e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final collection = appDb.db.collection(T.toString());

      final result = await collection.find(<String, dynamic>{}).toList();
      return result;
    } on Exception catch (e) {
      throw AppExceptions(message: e.toString());
    }
  }
}
