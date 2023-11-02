import 'dart:convert';

import 'data.dart';

class PlayListModel {
  String? message;
  PlayList? data;

  PlayListModel({this.message, this.data});

  factory PlayListModel.fromMap(Map<String, dynamic> data) => PlayListModel(
        message: data['message'] as String?,
        data: data['data'] == null
            ? null
            : PlayList.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PlayListModel].
  factory PlayListModel.fromJson(String data) {
    return PlayListModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PlayListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
