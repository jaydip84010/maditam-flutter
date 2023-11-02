import 'dart:convert';

class AppBanner {
  int? id;
  String? title;
  String? description;
  int? status;
  String? thumbnail;

  AppBanner({
    this.id,
    this.title,
    this.description,
    this.status,
    this.thumbnail,
  });

  factory AppBanner.fromMap(Map<String, dynamic> data) => AppBanner(
        id: data['id'] as int?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        status: data['status'] as int?,
        thumbnail: data['thumbnail'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'thumbnail': thumbnail,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AppBanner].
  factory AppBanner.fromJson(String data) {
    return AppBanner.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AppBanner] to a JSON string.
  String toJson() => json.encode(toMap());
}
