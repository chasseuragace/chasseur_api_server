import 'dart:convert';

import 'package:app_models/app_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      throw AppExceptions(message: 'use POST for update');
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();
    return successResponse(json: await _update(body));
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<Map<String, dynamic>> _update(String body) async {
  Map<String, dynamic> newBody;
  try {
    newBody = jsonDecode(body) as Map<String, dynamic>;
  } on Exception {
    throw AppExceptions(
      message: 'Payload is not Valid',
    );
  }
  if (newBody['id'] == null) {
    throw AppExceptions(
      message: 'Include id with expected item payload ',
      json: Category.dummy().toMap(),
    );
  }
//remove nodes not present  in payload
  final update = (Category.fromMap(newBody).toMap()
    ..removeWhere((key, value) => !newBody.keys.contains(key)));

  return Collection<Category>()
      .update({'_id': ObjectId.fromHexString(newBody['id'] as String)}, update);
}
