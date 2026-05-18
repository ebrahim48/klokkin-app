class LatestFormModel {
  final String? id;
  final User? user;
  final String? caption;
  final List<String>? tags;
  final String? status;
  final String? thumbnail;
  final int? shared;
  final String? description;
  final List<String>? mediaUrl;
  final String? type;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final int? v;

  LatestFormModel({
    this.id,
    this.user,
    this.caption,
    this.tags,
    this.status,
    this.thumbnail,
    this.shared,
    this.description,
    this.mediaUrl,
    this.type,
    this.expiresAt,
    this.createdAt,
    this.v,
  });

  factory LatestFormModel.fromJson(Map<String, dynamic> json) => LatestFormModel(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    caption: json["caption"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    status: json["status"],
    thumbnail: json["thumbnail"],
    shared: json["shared"],
    description: json["description"],
    mediaUrl: json["mediaUrl"] == null ? [] : List<String>.from(json["mediaUrl"]!.map((x) => x)),
    type: json["type"],
    expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "caption": caption,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "status": status,
    "thumbnail": thumbnail,
    "shared": shared,
    "description": description,
    "mediaUrl": mediaUrl == null ? [] : List<dynamic>.from(mediaUrl!.map((x) => x)),
    "type": type,
    "expiresAt": expiresAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}

class User {
  final String? id;
  final String? fname;

  User({
    this.id,
    this.fname,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    fname: json["fname"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fname": fname,
  };
}
