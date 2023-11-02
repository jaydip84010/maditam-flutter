import 'dart:convert';

import 'banner.dart';

class Data {
  List<AppBanner>? banner;

  Data({this.banner});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        banner: (data['banner'] as List<dynamic>?)
            ?.map((e) => AppBanner.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'banner': banner?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
