import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? thumbnail;
  bool? isVerified;

  User({this.id, this.name, this.email, this.thumbnail, this.isVerified});

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        thumbnail: data['thumbnail'] as String?,
        isVerified: data['is_verified'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'thumbnail': thumbnail,
        'is_verified': isVerified,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
