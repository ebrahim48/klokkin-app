

class UserProfileModel {
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
  final Profile? profile;

  UserProfileModel({
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
    this.profile,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
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
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
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
    "profile": profile?.toJson(),
  };
}

class Profile {
  final String? id;
  final String? user;
  final String? aboutself;
  final String? gender;
  final String? avatar;
  final String? nickname;
  final DateTime? dateofBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Profile({
    this.id,
    this.user,
    this.aboutself,
    this.gender,
    this.avatar,
    this.nickname,
    this.dateofBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["_id"],
    user: json["user"],
    aboutself: json["aboutself"],
    gender: json["gender"],
    avatar: json["avatar"],
    nickname: json["nickname"],
    dateofBirth: json["dateofBirth"] == null ? null : DateTime.parse(json["dateofBirth"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "aboutself": aboutself,
    "gender": gender,
    "avatar": avatar,
    "nickname": nickname,
    "dateofBirth": dateofBirth?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
