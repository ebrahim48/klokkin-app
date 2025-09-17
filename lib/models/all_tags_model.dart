class AllTagsModel {
  String? id;
  String? name;
  List<String>? tag;
  int? v;

  AllTagsModel({
    this.id,
    this.name,
    this.tag,
    this.v,
  });


  AllTagsModel.empty()
      : id = null,
        name = null,
        tag = null,
        v = null;

  AllTagsModel copyWith({
    String? id,
    String? name,
    List<String>? tag,
    int? v,
  }) =>
      AllTagsModel(
        id: id ?? this.id,
        name: name ?? this.name,
        tag: tag ?? this.tag,
        v: v ?? this.v,
      );

  factory AllTagsModel.fromJson(Map<String, dynamic> json) =>
      AllTagsModel(
        id: json["_id"] as String?,
        name: json["name"] as String?,
        tag: json["tag"] != null
            ? List<String>.from(json["tag"].map((x) => x.toString()))
            : null,
        v: json["__v"] as int?,
      );

  Map<String, dynamic> toJson() =>
      {
        "_id": id,
        "name": name,
        "tag": tag != null ? List<dynamic>.from(tag!.map((x) => x)) : null,
        "__v": v,
      };

  bool get isEmpty => id == null && name == null && (tag?.isEmpty ?? true);


  List<String> get tagList => tag ?? [];


}