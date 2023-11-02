import 'dart:convert';

class SubscriptionPlan {
  int? id;
  String? name;
  String? thumbnail;
  List<dynamic>? features;
  String? duration;
  double? amount;

  SubscriptionPlan({
    this.id,
    this.name,
    this.thumbnail,
    this.features,
    this.duration,
    this.amount,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> data) {
    return SubscriptionPlan(
      id: data['id'] as int?,
      name: data['name'] as String?,
      thumbnail: data['thumbnail'] as String?,
      features: data['features'] as List<dynamic>?,
      duration: data['duration'] as String?,
      amount: (data['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
        'features': features,
        'duration': duration,
        'amount': amount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SubscriptionPlan].
  factory SubscriptionPlan.fromJson(String data) {
    return SubscriptionPlan.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SubscriptionPlan] to a JSON string.
  String toJson() => json.encode(toMap());
}
