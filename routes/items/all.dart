import 'package:app_models/app_models.dart';

import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.get) {
      throw AppExceptions(message: 'Use GET');
    }

    return successResponse(
      json: await getAll(),
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<List<dynamic>> getAll() async {
  final result = await Collection<Items>().getAll();

  return result;
}
