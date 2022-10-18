import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';

import '../response_model/generic_response.dart';

Response handelError(Exception e) {
  log(e.toString());
  if (e is AppExceptions) {
    return e.toResponse();
  } else {
    return AppExceptions(
      message: 'Unknown error',
      json: {'error': e.toString()},
    ).toResponse();
  }
}

class AppExceptions implements Exception {
  AppExceptions({required this.message, this.json, this.code = 500});
  final String message;
  final dynamic json;
  final int code;
  @override
  String toString() {
    return message;
  }

  Response toResponse() {
    return errorResponse(this);
  }
}
