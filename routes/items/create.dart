import 'package:app_models/app_models.dart';

import 'package:dart_frog/dart_frog.dart';
import '../../app/database/db.dart';

import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.post) {
      throw AppExceptions(
        message: 'use POST for create',
      );
    }
    final user = await context.read<Future<User>>();
    final body = await context.request.body();
    return successResponse(json: (await _createNewProduct(body)).toMap());
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<Items> _createNewProduct(String body) async {
  Items item;

  try {
    item = Items.fromJson(body);
  } on Exception {
    throw AppExceptions(
      json: Items.dummy().toMap(),
      message: 'Payload is not valid!',
    );
  }
  // for (Image element in item.image ?? []) {
  //   element.hash = await networkImageToHash(element.url!);
  // }
  return item = Items.fromMap(await Collection<Items>().save(item));
}
