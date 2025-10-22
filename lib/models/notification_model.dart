class NotificationModel {
  final String? id;
  final String? title;
  final String? role;
  final String? type;
  final String? senderId;
  final bool? viewStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  NotificationModel({
    this.id,
    this.title,
    this.role,
    this.type,
    this.senderId,
    this.viewStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["_id"],
    title: json["title"],
    role: json["role"],
    type: json["type"],
    senderId: json["senderId"],
    viewStatus: json["viewStatus"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "role": role,
    "type": type,
    "senderId": senderId,
    "viewStatus": viewStatus,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
