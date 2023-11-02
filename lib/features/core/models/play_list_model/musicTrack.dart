import 'dart:convert';
import 'package:medyo/features/core/models/album_list_model/albam.dart';

class MusicTrack {
  int? id;
  String? name;
  String? description;
  String? duration;
  String? thumbnail;
  String? audio;
  bool? isFavorite;
  bool? isPaid;
  Albam? albam;

  MusicTrack({
    this.id,
    this.name,
    this.description,
    this.duration,
    this.thumbnail,
    this.audio,
    this.isFavorite,
    this.isPaid,
    this.albam,
  });

  factory MusicTrack.fromMap(Map<String, dynamic> data) => MusicTrack(
        id: data['id'] as int?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        duration: data['duration'] as String?,
        thumbnail: data['thumbnail'] as String?,
        audio: data['audio'] as String?,
        isFavorite: data['is_favorite'] as bool?,
        isPaid: data['is_paid'] as bool?,
        albam: data['albam'] == null
            ? null
            : Albam.fromMap(data['albam'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'duration': duration,
        'thumbnail': thumbnail,
        'audio': audio,
        'is_favorite': isFavorite,
        'is_paid': isPaid,
        'albam': albam?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MusicTrack].
  factory MusicTrack.fromJson(String data) {
    return MusicTrack.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MusicTrack] to a JSON string.
  String toJson() => json.encode(toMap());
}
