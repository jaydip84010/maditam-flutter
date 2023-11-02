import 'dart:convert';

import 'package:medyo/features/auth/models/login_model/user.dart';

class Data {
  User? user;
  bool? hasSubscribed;

  Data({this.user, this.hasSubscribed});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        hasSubscribed: data['has_subscribed'] as bool?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() =>
      {'user': user?.toMap(), 'has_subscribed': hasSubscribed};

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
