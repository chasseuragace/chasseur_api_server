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
          body: {'message': 'use POST for delete'});
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();
    await _deleteItem(body);
    return successResponse(
      message: 'Deleted!',
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<bool> _deleteItem(String body) async {
  final newBody = jsonDecode(body) as Map;
  if (newBody['id'] == null)
    throw AppExceptions(message: "id should not be null");
  final result = Collection<Category>().delete(newBody['id'].toString());
  return result;
}
