import 'dart:developer';
import 'dart:io';

import 'package:app_models/app_models.dart';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      throw AppExceptions(message: 'use POST for create');
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();
    return successResponse(
      json: (await _createNewCategory(body)).toMap(),
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<Category> _createNewCategory(String body) async {
  Category category;

  try {
    category = Category.fromJson(body);
    await category.image?.setHash();
  } on Exception {
    throw AppExceptions(
      json: Category.dummy().toMap(),
      message: 'Payload is not valid!',
    );
  }

  return category =
      Category.fromMap(await Collection<Category>().save(category));
}
