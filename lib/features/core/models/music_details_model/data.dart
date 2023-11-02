import 'dart:convert';

import 'readmore.dart';

class Data {
  Readmore? readmore;

  Data({this.readmore});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        readmore: data['readmore'] == null
            ? null
            : Readmore.fromMap(data['readmore'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'readmore': readmore?.toMap(),
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
