import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../app/auth/authentication.dart';
import '../../app/database/db.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Use POST for login'},
      );
    }
    final body = jsonDecode(await context.request.body()) as Map;
    final email = body['email'] as String;
    final password = body['password'].toString();

    final validity = await Collection<User>().findBy({
      'email': email,
      "hashed_password":
          JWTTokenHandler.generateHash(email: email, password: password)
    });

    return Response.json(
        body: {'token': JWTTokenHandler.generatetokenForUser(email)});
  } on Exception catch (e) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'message': "Username and/or password combination doesn't match"},
    );
  }
}
