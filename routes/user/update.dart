import 'dart:convert';

import 'package:app_models/app_models.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../app/error/errors.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    return Response.json(
      body: (await context.read<Future<User>>()).toSecureMap(),
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<bool> _update(String body) async {
  Map<String, dynamic> newBody;
  try {
    newBody = jsonDecode(body) as Map<String, dynamic>;
    User.fromMap(newBody);
  } on FormatException {
    throw AppExceptions(
      message: 'Payload is not Valid',
    );
  }

  return true;
}
