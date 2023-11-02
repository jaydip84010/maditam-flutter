import 'dart:convert';

import 'data.dart';

class PrivacyAndPolicyModel {
  String? message;
  Data? data;

  PrivacyAndPolicyModel({this.message, this.data});

  factory PrivacyAndPolicyModel.fromMap(Map<String, dynamic> data) {
    return PrivacyAndPolicyModel(
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
  /// Parses the string and returns the resulting Json object as [PrivacyAndPolicyModel].
  factory PrivacyAndPolicyModel.fromJson(String data) {
    return PrivacyAndPolicyModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PrivacyAndPolicyModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
