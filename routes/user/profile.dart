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
