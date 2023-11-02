import 'dart:convert';

import 'plan.dart';

class Data {
  List<Plan>? plans;

  Data({this.plans});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        plans: (data['plans'] as List<dynamic>?)
            ?.map((e) => Plan.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'plans': plans?.map((e) => e.toMap()).toList(),
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
