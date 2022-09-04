import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../app/database/db.dart';

import '../../app/database/models/items/items.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.get) {
      return Response.json(
          statusCode: HttpStatus.badRequest, body: {'message': 'use GET '});
    }
    // final user = await context.read<Future<User>>();
    final body = await context.request.body();

    return Response.json(
      body: {
        'message': 'success!',
        'items': await getAll(),
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
  } on Exception catch (e) {
    return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'message': 'Something went wrong $e'});
  }
}

Future<List> getAll() async {
  final result = await Collection<Items>().getAll();

  return result;
}
