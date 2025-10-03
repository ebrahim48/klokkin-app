class LibraryResponse {
  final int? code;
  final String? message;
  final LibraryData? data;

  LibraryResponse({this.code, this.message, this.data});

  factory LibraryResponse.fromJson(Map<String, dynamic> json) =>
      LibraryResponse(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : LibraryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.toJson(),
  };
}

class LibraryData {
  final LibraryAttributes? attributes;

  LibraryData({this.attributes});

  factory LibraryData.fromJson(Map<String, dynamic> json) => LibraryData(
    attributes: json["attributes"] == null
        ? null
        : LibraryAttributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes?.toJson(),
  };
}

class LibraryAttributes {
  final LibraryContent? data;

  LibraryAttributes({this.data});

  factory LibraryAttributes.fromJson(Map<String, dynamic> json) =>
      LibraryAttributes(
        data: json["data"] == null
            ? null
            : LibraryContent.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class LibraryContent {
  final StoryGroup? audio;
  final StoryGroup? video;
  final StoryGroup? image;

  LibraryContent({this.audio, this.video, this.image});

  factory LibraryContent.fromJson(Map<String, dynamic> json) => LibraryContent(
    audio:
    json["audio"] == null ? null : StoryGroup.fromJson(json["audio"]),
    video:
    json["video"] == null ? null : StoryGroup.fromJson(json["video"]),
    image:
    json["image"] == null ? null : StoryGroup.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "audio": audio?.toJson(),
    "video": video?.toJson(),
    "image": image?.toJson(),
  };
}

class StoryGroup {
  final Meta? meta;
  final List<StoryLibraryDataModel>? results;

  StoryGroup({this.meta, this.results});

  factory StoryGroup.fromJson(Map<String, dynamic> json) => StoryGroup(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    results: json["results"] == null
        ? []
        : List<StoryLibraryDataModel>.from(
        json["results"].map((x) => StoryLibraryDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}

class StoryLibraryDataModel {
  final String? id;
  final String? user;
  final String? caption;
  final String? duration;
  final List<String>? tags;
  final String? status;
  final String? thumbnail;
  final int? shared;
  final int? view;
  final String? description;
  final List<String>? mediaUrl;
  final String? type;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final int? v;

  StoryLibraryDataModel({
    this.id,
    this.user,
    this.thumbnail,
    this.duration,
    this.caption,
    this.tags,
    this.status,
    this.view,
    this.shared,
    this.description,
    this.mediaUrl,
    this.type,
    this.expiresAt,
    this.createdAt,
    this.v,
  });

  factory StoryLibraryDataModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags = [];
    if (json["tags"] != null) {
      parsedTags = (json["tags"] as List)
          .expand((t) => (t as String).split(",")) // split comma-separated tags
          .map((t) => t.trim())
          .toList();
    }

    return StoryLibraryDataModel(
      id: json["_id"],
      user: json["user"],
      caption: json["caption"],
      duration: json["duration"],
      tags: parsedTags,
      status: json["status"],
      shared: json["shared"],
      view: json["view"],
      thumbnail: json["thumbnail"],
      description: json["description"],
      mediaUrl: json["mediaUrl"] == null
          ? []
          : List<String>.from(json["mediaUrl"].map((x) => x)),
      type: json["type"],
      expiresAt: json["expiresAt"] == null
          ? null
          : DateTime.parse(json["expiresAt"]),
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.parse(json["createdAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "caption": caption,
    "duration": duration,
    "tags": tags ?? [],
    "status": status,
    "thumbnail": thumbnail,
    "shared": shared,
    "view": view,
    "description": description,
    "mediaUrl": mediaUrl ?? [],
    "type": type,
    "expiresAt": expiresAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "__v": v,
  };
}
