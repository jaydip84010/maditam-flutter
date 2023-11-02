import 'dart:convert';

import 'albam.dart';

class Data {
  int? total;
  List<Albam>? albams;

  Data({this.total, this.albams});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        total: data['total'] as int?,
        albams: (data['albams'] as List<dynamic>?)
            ?.map((e) => Albam.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'total': total,
        'albams': albams?.map((e) => e.toMap()).toList(),
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
