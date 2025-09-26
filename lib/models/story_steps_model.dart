class StoryStepsModel {
  final String? id;
  final User? user;
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

  StoryStepsModel({
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

  factory StoryStepsModel.fromJson(Map<String, dynamic> json) => StoryStepsModel(
    id: json["_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
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
    "user": user?.toJson(),
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

class User {
  final String? id;
  final String? email;
  final String? role;
  final bool? isEmailVerified;
  final String? phone;
  final bool? isResetPassword;
  final int? failedLoginAttempts;
  final String? provider;
  final String? fname;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  User({
    this.id,
    this.email,
    this.role,
    this.isEmailVerified,
    this.phone,
    this.isResetPassword,
    this.failedLoginAttempts,
    this.provider,
    this.fname,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    email: json["email"],
    role: json["role"],
    isEmailVerified: json["isEmailVerified"],
    phone: json["phone"],
    isResetPassword: json["isResetPassword"],
    failedLoginAttempts: json["failedLoginAttempts"],
    provider: json["provider"],
    fname: json["fname"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "role": role,
    "isEmailVerified": isEmailVerified,
    "phone": phone,
    "isResetPassword": isResetPassword,
    "failedLoginAttempts": failedLoginAttempts,
    "provider": provider,
    "fname": fname,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
