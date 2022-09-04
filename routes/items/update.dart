import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../app/database/db.dart';

import '../../app/database/models/items/items.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
          statusCode: HttpStatus.badRequest,
          body: {'message': 'use POST for delete'});
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();

    return Response.json(
      body: {
        'message': await _update(body) ? 'Success!' : 'Failed!',
      },
    );
  } on AppExceptions catch (e) {
    return Response.json(
        statusCode: HttpStatus.expectationFailed,
        body: {'message': e.toString()});
  } on LogicEception {
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'message': 'Action not permitted!'});
  } on FormatException {
    return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'message': 'payload is not a valid json'});
  } on Exception catch (e) {
    return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'message': 'Something went wrong $e'});
  }
}

Future<bool> _update(String body) async {
  final newBody = jsonDecode(body) as Map<String, dynamic>;
  if (newBody['id'] == null)
    throw AppExceptions(messgae: "id should not be null");
  final result = await Collection<Items>().update(
      Items(oid: ObjectId.fromHexString(newBody['id'] as String)).toMap(),
      Items.fromMap(newBody).toMap());
  return true;
}
