// Models for the subscription feature.
// Backend wraps payloads as { data: { attributes: <payload> } }; these
// model the <payload> shapes produced by the subscription module.

class SubscriptionPlanModel {
  final String? id;
  final String? key; // basic | pro | premium
  final String? name;
  final num? price;
  final String? currency;
  final int? monthlyStoryLimit; // -1 = unlimited
  final int? durationDays;
  final String? description;
  final List<String> features;
  final List<String> appleProductIds;
  final List<String> googleProductIds;
  final bool isActive;

  SubscriptionPlanModel({
    this.id,
    this.key,
    this.name,
    this.price,
    this.currency,
    this.monthlyStoryLimit,
    this.durationDays,
    this.description,
    this.features = const [],
    this.appleProductIds = const [],
    this.googleProductIds = const [],
    this.isActive = true,
  });

  bool get unlimited => monthlyStoryLimit == -1;

  String get priceLabel {
    final c = (currency ?? 'USD').toUpperCase();
    final p = price ?? 0;
    return '${c == 'USD' ? '\$' : '$c '}$p';
  }

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json["_id"],
        key: json["key"],
        name: json["name"],
        price: json["price"],
        currency: json["currency"],
        monthlyStoryLimit: json["monthlyStoryLimit"],
        durationDays: json["durationDays"],
        description: json["description"],
        features: json["features"] == null
            ? const []
            : List<String>.from(json["features"].map((x) => x.toString())),
        appleProductIds: json["appleProductIds"] == null
            ? const []
            : List<String>.from(
                json["appleProductIds"].map((x) => x.toString())),
        googleProductIds: json["googleProductIds"] == null
            ? const []
            : List<String>.from(
                json["googleProductIds"].map((x) => x.toString())),
        isActive: json["isActive"] ?? true,
      );
}

class SubscriptionUsage {
  final int? limit;
  final bool unlimited;
  final int used;
  final int? remaining;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  SubscriptionUsage({
    this.limit,
    this.unlimited = false,
    this.used = 0,
    this.remaining,
    this.periodStart,
    this.periodEnd,
  });

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) =>
      SubscriptionUsage(
        limit: json["limit"],
        unlimited: json["unlimited"] ?? false,
        used: json["used"] ?? 0,
        remaining: json["remaining"],
        periodStart: json["periodStart"] == null
            ? null
            : DateTime.tryParse(json["periodStart"].toString()),
        periodEnd: json["periodEnd"] == null
            ? null
            : DateTime.tryParse(json["periodEnd"].toString()),
      );
}

class MySubscriptionModel {
  final bool active;
  final SubscriptionPlanModel? plan;
  final String? planKey;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final SubscriptionUsage? usage;
  final bool alreadyProcessed;

  MySubscriptionModel({
    this.active = false,
    this.plan,
    this.planKey,
    this.status,
    this.startDate,
    this.endDate,
    this.usage,
    this.alreadyProcessed = false,
  });

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) {
    final sub = json["subscription"];
    return MySubscriptionModel(
      active: json["active"] ?? false,
      plan: json["plan"] == null
          ? null
          : SubscriptionPlanModel.fromJson(
              Map<String, dynamic>.from(json["plan"])),
      planKey: sub?["planKey"],
      status: sub?["status"],
      startDate: sub?["startDate"] == null
          ? null
          : DateTime.tryParse(sub["startDate"].toString()),
      endDate: sub?["endDate"] == null
          ? null
          : DateTime.tryParse(sub["endDate"].toString()),
      usage: sub?["usage"] == null
          ? null
          : SubscriptionUsage.fromJson(
              Map<String, dynamic>.from(sub["usage"])),
      alreadyProcessed: json["alreadyProcessed"] ?? false,
    );
  }
}

class SubscriptionTransactionModel {
  final String? id;
  final String? planKey;
  final String? type; // purchase | renewal
  final num? amount;
  final String? currency;
  final String? store;
  final String? platform;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? createdAt;

  SubscriptionTransactionModel({
    this.id,
    this.planKey,
    this.type,
    this.amount,
    this.currency,
    this.store,
    this.platform,
    this.periodStart,
    this.periodEnd,
    this.createdAt,
  });

  factory SubscriptionTransactionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionTransactionModel(
        id: json["_id"],
        planKey: json["planKey"],
        type: json["type"],
        amount: json["amount"],
        currency: json["currency"],
        store: json["store"],
        platform: json["platform"],
        periodStart: json["periodStart"] == null
            ? null
            : DateTime.tryParse(json["periodStart"].toString()),
        periodEnd: json["periodEnd"] == null
            ? null
            : DateTime.tryParse(json["periodEnd"].toString()),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
      );
}
