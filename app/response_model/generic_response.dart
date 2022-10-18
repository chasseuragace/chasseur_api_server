import 'package:dart_frog/dart_frog.dart';

import '../database/db.dart';
import '../error/errors.dart';

Response successResponse({
  dynamic json,
  String? message,
}) {
  return Response.json(
    body: <String, dynamic>{
      'success': true,
    }
      ..putIfAbsent('message', () => message)
      ..putIfAbsent('data', () => json)
      ..removeWhere((key, value) => value == null),
  );
}

Response errorResponse(AppExceptions exception) {
  return Response.json(
    statusCode: exception.code,
    body: <String, dynamic>{
      'success': false,
    }
      ..putIfAbsent('message', () => exception.message)
      ..putIfAbsent('data', () => exception.json)
      ..removeWhere((key, value) => value == null),
  );
}
