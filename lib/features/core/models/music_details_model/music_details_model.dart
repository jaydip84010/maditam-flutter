import 'dart:convert';

import 'data.dart';

class MusicDetailsModel {
  String? message;
  Data? data;

  MusicDetailsModel({this.message, this.data});

  factory MusicDetailsModel.fromMap(Map<String, dynamic> data) {
    return MusicDetailsModel(
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
  /// Parses the string and returns the resulting Json object as [MusicDetailsModel].
  factory MusicDetailsModel.fromJson(String data) {
    return MusicDetailsModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MusicDetailsModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
