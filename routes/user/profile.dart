import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    return Response.json(
        body: (await context.read<Future<User>>()).toSecureMap());
  } on AppExceptions catch (e) {
    return Response.json(
        statusCode: HttpStatus.unauthorized, body: {"message": e.toString()});
  }
}
