import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post)
      return Response.json(
          statusCode: HttpStatus.badRequest,
          body: {'message': 'use POST for create'});
    final user = await context.read<Future<User>>();
    return Response.json(body: {'message': "k xa"});
  } on AppExceptions catch (e) {
    return Response.json(
        statusCode: HttpStatus.unauthorized, body: {"message": e.toString()});
  } on LogicEception {
    return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {"message": "Action not permitted"});
  }
}
