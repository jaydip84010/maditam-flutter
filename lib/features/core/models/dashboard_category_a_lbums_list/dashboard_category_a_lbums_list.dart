import 'dart:convert';

import 'data.dart';

class DashboardCategoryALbumsList {
  String? message;
  Data? data;

  DashboardCategoryALbumsList({this.message, this.data});

  factory DashboardCategoryALbumsList.fromMap(Map<String, dynamic> data) {
    return DashboardCategoryALbumsList(
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
  /// Parses the string and returns the resulting Json object as [DashboardCategoryALbumsList].
  factory DashboardCategoryALbumsList.fromJson(String data) {
    return DashboardCategoryALbumsList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DashboardCategoryALbumsList] to a JSON string.
  String toJson() => json.encode(toMap());
}
