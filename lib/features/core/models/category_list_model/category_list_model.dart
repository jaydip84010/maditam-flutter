import 'dart:convert';

import 'data.dart';

class CategoryListModel {
  String? message;
  Data? data;

  CategoryListModel({this.message, this.data});

  factory CategoryListModel.fromMap(Map<String, dynamic> data) {
    return CategoryListModel(
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
  /// Parses the string and returns the resulting Json object as [CategoryListModel].
  factory CategoryListModel.fromJson(String data) {
    return CategoryListModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CategoryListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
