import 'dart:convert';

import 'subscription.dart';

class Data {
  List<Subscription>? subscriptions;

  Data({this.subscriptions});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        subscriptions: (data['subscriptions'] as List<dynamic>?)
            ?.map((e) => Subscription.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'subscriptions': subscriptions?.map((e) => e.toMap()).toList(),
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
