import 'dart:convert';

import 'package:medyo/features/core/models/play_list_model/albam.dart';

class Data {
  List<MusicTrack>? playList;

  Data({this.playList});

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        playList: (data['playList'] as List<dynamic>?)
            ?.map((e) => MusicTrack.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'playList': playList?.map((e) => e.toMap()).toList(),
      };

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
