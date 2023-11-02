import 'dart:convert';

import 'albam.dart';

class PlayList {
  List<MusicTrack>? albams;

  PlayList({this.albams});

  factory PlayList.fromMap(Map<String, dynamic> data) => PlayList(
        albams: (data['albams'] as List<dynamic>?)
            ?.map((e) => MusicTrack.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'albams': albams?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory PlayList.fromJson(String data) {
    return PlayList.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());
}
