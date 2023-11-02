import 'dart:convert';

import 'package:medyo/features/core/models/category_list_model/category.dart';

class Albam {
  int? id;
  String? name;
  String? description;
  String? thumbnail;
  bool? isPaid;
  Category? category;

  Albam({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.category,
    this.isPaid,
  });

  factory Albam.fromMap(Map<String, dynamic> data) => Albam(
        id: data['id'] as int?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        thumbnail: data['thumbnail'] as String?,
        isPaid: data['is_paid'] as bool?,
        category: data['category'] == null
            ? null
            : Category.fromMap(data['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'thumbnail': thumbnail,
        'is_paid': isPaid,
        'category': category?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Albam].
  factory Albam.fromJson(String data) {
    return Albam.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Albam] to a JSON string.
  String toJson() => json.encode(toMap());
}
