import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/database/models/user.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'message': 'Use POST for verifivation'},
    );
  }
  final body = jsonDecode(await context.request.body()) as Map;
  final code = body['code'].toString();
  final email = body['email'].toString();

  final result = await verifyUsersCode(email, code);
  return Response.json(
    body: {'message': result ? 'Verified successfully' : 'Error Verifyig '},
  );
}

Future<bool> verifyUsersCode(String email, String code) async {
  try {
    final user = User.fromMap(
      await Collection<User>().findBy({'email': email, 'code': code}),
    );
    if (user.isVerified) return true;
    final updated = user.toMap()
      ..update('is_verified', (value) => true, ifAbsent: () => true)
      ..update('code', (value) => '-----');

    await Collection<User>().update(user.toMap(), updated);
    return true;
  } on Exception {
    return false;
  }
}
