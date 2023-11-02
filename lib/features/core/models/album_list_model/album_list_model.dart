import 'dart:convert';

import 'data.dart';

class AlbumListModel {
  String? message;
  Data? data;

  AlbumListModel({this.message, this.data});

  factory AlbumListModel.fromMap(Map<String, dynamic> data) {
    return AlbumListModel(
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
  /// Parses the string and returns the resulting Json object as [AlbumListModel].
  factory AlbumListModel.fromJson(String data) {
    return AlbumListModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AlbumListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
