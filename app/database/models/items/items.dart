import 'dart:convert';

import '../base/collections.dart';
import 'image.dart';

class Items extends Coll {
  final String? name;
  final List<String>? colors;
  final List<int>? sizes;
  final double? price;
  final String? brand;
  final List<Image>? image;

  const Items({
    this.name,
    this.colors,
    this.sizes,
    this.price,
    this.brand,
    this.image,
  });

  factory Items.fromMap(Map<String, dynamic> data) => Items(
        name: data['name'] as String?,
        colors: data['colors'] as List<String>?,
        sizes: data['sizes'] as List<int>?,
        price: (data['price'] as num?)?.toDouble(),
        brand: data['brand'] as String?,
        image: (data['image'] as List<dynamic>?)
            ?.map((e) => Image.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
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
