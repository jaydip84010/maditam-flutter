import 'dart:convert';

import 'setting.dart';

class Data {
  Setting? setting;

  Data({this.setting});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        setting: data['setting'] == null
            ? null
            : Setting.fromMap(data['setting'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'setting': setting?.toMap(),
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
