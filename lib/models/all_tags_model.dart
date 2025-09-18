class AllTagsModel {
  final String? id;
  final String? name;
  final List<String>? tag;
  final int? v;

  AllTagsModel({
    this.id,
    this.name,
    this.tag,
    this.v,
  });

  factory AllTagsModel.fromJson(Map<String, dynamic> json) => AllTagsModel(
    id: json["_id"],
    name: json["name"],
    tag: json["tag"] == null ? [] : List<String>.from(json["tag"]!.map((x) => x)),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "tag": tag == null ? [] : List<dynamic>.from(tag!.map((x) => x)),
    "__v": v,
  };
}
