import 'dart:convert';

import 'data.dart';

class MySubscriptionModel {
  String? message;
  Data? data;

  MySubscriptionModel({this.message, this.data});

  factory MySubscriptionModel.fromMap(Map<String, dynamic> data) {
    return MySubscriptionModel(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MySubscriptionModel].
  factory MySubscriptionModel.fromJson(String data) {
    return MySubscriptionModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MySubscriptionModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
