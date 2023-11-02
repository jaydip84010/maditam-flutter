import 'dart:convert';

import 'data.dart';

class FavouriteListModel {
  String? message;
  Data? data;

  FavouriteListModel({this.message, this.data});

  factory FavouriteListModel.fromMap(Map<String, dynamic> data) {
    return FavouriteListModel(
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
  /// Parses the string and returns the resulting Json object as [FavouriteListModel].
  factory FavouriteListModel.fromJson(String data) {
    return FavouriteListModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [FavouriteListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
