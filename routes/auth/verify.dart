import 'dart:convert';
import 'dart:io';

import 'package:app_models/app_models.dart';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Use POST for verifivation'},
      );
    }
    final body = jsonDecode(await context.request.body()) as Map;
    final code = body['code'].toString();
    final email = body['email'].toString();

    await verifyUsersCode(email, code);
    return successResponse();
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<bool> verifyUsersCode(String email, String code) async {
  final user = User.fromMap(
    await Collection<User>().findBy({'email': email, 'code': code}).onError(
      (error, stackTrace) => throw AppExceptions(message: 'Validation failed'),
    ),
  );
  if (user.isVerified) return true;
  final updated = user.toMap()
    ..update('is_verified', (value) => true, ifAbsent: () => true)
    ..update('code', (value) => '-----');

  await Collection<User>().update(user.toMap(), updated);
  return true;
}
