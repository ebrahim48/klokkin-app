class WorkingDaysModel {
  final String? id;
  final String? user;
  final String? caption;
  final List<String>? tags;
  final String? status;
  final String? thumbnail;
  final String? duration;
  final String? medianame;
  final int? shared;
  final int? viewCount;
  final String? description;
  final List<String>? mediaUrl;
  final String? type;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final int? v;

  WorkingDaysModel({
    this.id,
    this.user,
    this.caption,
    this.tags,
    this.status,
    this.thumbnail,
    this.duration,
    this.medianame,
    this.shared,
    this.viewCount,
    this.description,
    this.mediaUrl,
    this.type,
    this.expiresAt,
    this.createdAt,
    this.v,
  });

  factory WorkingDaysModel.fromJson(Map<String, dynamic> json) => WorkingDaysModel(
    id: json["_id"],
    user: json["user"],
    caption: json["caption"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    status: json["status"],
    thumbnail: json["thumbnail"],
    duration: json["duration"],
    medianame: json["medianame"],
    shared: json["shared"],
    viewCount: json["viewCount"],
    description: json["description"],
    mediaUrl: json["mediaUrl"] == null ? [] : List<String>.from(json["mediaUrl"]!.map((x) => x)),
    type: json["type"],
    expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "caption": caption,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "status": status,
    "thumbnail": thumbnail,
    "duration": duration,
    "medianame": medianame,
    "shared": shared,
    "viewCount": viewCount,
    "description": description,
    "mediaUrl": mediaUrl == null ? [] : List<dynamic>.from(mediaUrl!.map((x) => x)),
    "type": type,
    "expiresAt": expiresAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}
