import 'dart:convert';

import 'package:collection/collection.dart';

class Image {
  final String? url;
  final String? hash;

  const Image({this.url, this.hash});

  factory Image.fromMap(Map<String, dynamic> data) => Image(
        url: data['url'] as String?,
        hash: data['hash'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'url': url,
        'hash': hash,
      }..removeWhere((key, value) => value == null);

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Image].
  factory Image.fromJson(String data) {
    return Image.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Image] to a JSON string.
  String toJson() => json.encode(toMap());
}
