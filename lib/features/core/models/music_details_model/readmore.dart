import 'dart:convert';

class Readmore {
  String? title;
  String? subTitle;
  String? content;

  Readmore({this.title, this.subTitle, this.content});

  factory Readmore.fromMap(Map<String, dynamic> data) => Readmore(
        title: data['title'] as String?,
        subTitle: data['sub_title'] as String?,
        content: data['content'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'sub_title': subTitle,
        'content': content,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Readmore].
  factory Readmore.fromJson(String data) {
    return Readmore.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Readmore] to a JSON string.
  String toJson() => json.encode(toMap());
}
