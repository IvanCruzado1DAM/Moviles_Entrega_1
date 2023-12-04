import 'dart:convert';

class ElementData {
  int id;
  String type;
  String name;
  int? userId;
  String description;
  String image;
  DateTime? date;
  DateTime createdAt;
  List<ElementData>? data;

  ElementData({
    required this.id,
    required this.type,
    required this.name,
    this.userId,
    required this.description,
    required this.image,
    this.date,
    required this.createdAt,
  });

  factory ElementData.fromRawJson(String str) =>
      ElementData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ElementData.fromJson(Map<String, dynamic> json) => ElementData(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        userId: json["user_id"],
        description: json["description"],
        image: json["image"],
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "user_id": userId,
        "description": description,
        "image": image,
        "date": date?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
