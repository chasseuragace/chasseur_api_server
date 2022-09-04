import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

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
    final result = await _deleteItem(body);
    return Response.json(
      body: {
        'message': 'Success!',
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

Future<bool> _deleteItem(String body) async {
  final newBody = jsonDecode(body) as Map;
  if (newBody['id'] == null)
    throw AppExceptions(messgae: "id should not be null");
  final result = Collection<Items>().delete(newBody['id'].toString());
  return result;
}
