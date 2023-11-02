import 'dart:convert';

import 'package:medyo/features/core/models/album_list_model/albam.dart';

class MusicTrack {
  int? id;
  String? name;
  String? description;
  String? duration;
  String? thumbnail;
  String? audio;
  bool? isfavorite;
  bool? isPaid;
  Albam? albam;
  bool? hasReadMore;

  MusicTrack({
    this.id,
    this.name,
    this.description,
    this.duration,
    this.thumbnail,
    this.audio,
    this.isfavorite,
    this.isPaid,
    this.albam,
    this.hasReadMore,
  });

  factory MusicTrack.fromMap(Map<String, dynamic> data) => MusicTrack(
        id: data['id'] as int?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        duration: data['duration'] as String?,
        thumbnail: data['thumbnail'] as String?,
        audio: data['audio'] as String?,
        isfavorite: data['is_favorite'] as bool?,
        isPaid: data['is_paid'] as bool?,
        albam: data['albam'] == null
            ? null
            : Albam.fromMap(data['albam'] as Map<String, dynamic>),
        hasReadMore: data['has_readmore'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'duration': duration,
        'thumbnail': thumbnail,
        'audio': audio,
        'is_favorite': isfavorite,
        'is_paid': isPaid,
        'albam': albam?.toMap(),
        'has_readmore': hasReadMore,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Albam].
  factory MusicTrack.fromJson(String data) {
    return MusicTrack.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Albam] to a JSON string.
  String toJson() => json.encode(toMap());
}
