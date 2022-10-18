import 'package:app_models/app_models.dart';
import 'package:dart_frog/dart_frog.dart';

import '../../app/database/db.dart';
import '../../app/error/errors.dart';
import '../../app/response_model/generic_response.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    if (context.request.method != HttpMethod.get) {
      throw AppExceptions(message: "Use GET");
    }

    final asTree = context.request.uri.queryParameters['tree'] == 'true';

    return successResponse(
      json: await getAll(tree: asTree),
    );
  } on Exception catch (e) {
    return handelError(e);
  }
}

Future<dynamic> getAll({bool tree = false}) async {
  final cat = <String, List<dynamic>>{};
  final result = await Collection<Category>().getAll();
  final catList = result.map(Category.fromMap).toList();
  if (tree) {
    cat['tree'] = Category.listToTree(catList).map((e) => e.toMap()).toList();
  }
  cat['flat'] = catList.map((e) => e.toMap()).toList();
  return cat;
}
