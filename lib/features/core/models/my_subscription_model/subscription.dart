import 'dart:convert';

import 'subscription_plan.dart';

class Subscription {
  int? id;
  String? expiredAt;
  double? amount;
  SubscriptionPlan? subscriptionPlan;

  Subscription({
    this.id,
    this.expiredAt,
    this.amount,
    this.subscriptionPlan,
  });

  factory Subscription.fromMap(Map<String, dynamic> data) => Subscription(
        id: data['id'] as int?,
        expiredAt: data['expired_at'] as String?,
        amount: (data['amount'] as num?)?.toDouble(),
        subscriptionPlan: data['subscriptionPlan'] == null
            ? null
            : SubscriptionPlan.fromMap(
                data['subscriptionPlan'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'expired_at': expiredAt,
        'amount': amount,
        'subscriptionPlan': subscriptionPlan?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Subscription].
  factory Subscription.fromJson(String data) {
    return Subscription.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Subscription] to a JSON string.
  String toJson() => json.encode(toMap());
}
