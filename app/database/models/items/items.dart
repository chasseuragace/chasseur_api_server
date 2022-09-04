import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../base/collections.dart';
import 'image.dart';

class Items extends Coll {
  final String? name;
  final List<String>? colors;
  final List<int>? sizes;
  final double? price;
  final String? brand;
  final List<Image>? image;
  final ObjectId? oid;
  const Items(
      {this.name,
      this.colors,
      this.sizes,
      this.price,
      this.brand,
      this.image,
      this.oid});

  factory Items.fromMap(Map<String, dynamic> data) => Items(
        oid: data['_id'] != null ? data['_id'] as ObjectId : null,
        name: data['name'] as String?,
        colors: (data['colors'] as List).cast<String>(),
        sizes: (data['sizes'] as List).cast<int>(),
        price: (data['price'] as num?)?.toDouble(),
        brand: data['brand'] as String?,
        image: (data['image'] as List<dynamic>?)
            ?.map((e) => Image.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': oid,
        'name': name,
        'colors': colors,
        'sizes': sizes,
        'price': price,
        'brand': brand,
        'image': image?.map((e) => e.toMap()).toList(),
      }..removeWhere((key, value) => value == null);

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Items].
  factory Items.fromJson(String data) {
    return Items.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Items] to a JSON string.
  String toJson() => json.encode(toMap());
}
