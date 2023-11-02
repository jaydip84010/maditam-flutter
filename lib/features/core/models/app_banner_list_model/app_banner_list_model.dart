import 'dart:convert';

import 'data.dart';

class AppBannerListModel {
  String? message;
  Data? data;

  AppBannerListModel({this.message, this.data});

  factory AppBannerListModel.fromMap(Map<String, dynamic> data) {
    return AppBannerListModel(
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
  /// Parses the string and returns the resulting Json object as [AppBannerListModel].
  factory AppBannerListModel.fromJson(String data) {
    return AppBannerListModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AppBannerListModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
