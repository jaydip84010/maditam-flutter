import 'dart:convert';

class Category {
  int? id;
  String? name;
  String? description;
  String? thumbnail;
  String? icon;

  Category({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.icon,
  });

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        id: data['id'] as int?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        thumbnail: data['thumbnail'] as String?,
        icon: data['icon'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'thumbnail': thumbnail,
        'icon': icon,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Category].
  factory Category.fromJson(String data) {
    return Category.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Category] to a JSON string.
  String toJson() => json.encode(toMap());
}
