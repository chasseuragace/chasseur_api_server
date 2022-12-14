import 'dart:convert';
import 'dart:io';

import 'package:app_models/app_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'use POST for update'},
      );
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();

    return successResponse(
      json: await _update(body),
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<Map<String, dynamic>> _update(String body) async {
  Map<String, dynamic> newBody;
  ObjectId oid;

  newBody = jsonDecode(body) as Map<String, dynamic>;
  if ((newBody['id'] as String).length != 24) {
    throw AppExceptions(
      message: 'Invalid id',
    );
  }
  oid = ObjectId.fromHexString(newBody['id'] as String);

  if (newBody['id'] == null) {
    throw AppExceptions(
      message: 'Include id with expected item payload',
      json: Items.dummy().toMap(),
    );
  }
  return Collection<Items>().update(
    Items(id: oid).toMap(),
    Items.fromMap(newBody).toMap(),
  );
}
