import 'dart:convert';

class MoodData {
  int id;
  String type;
  String? name;
  int? userId;
  String description;
  String image;
  DateTime? date;
  DateTime createdAt;

  MoodData({
    required this.id,
    required this.type,
    this.name,
    this.userId,
    required this.description,
    required this.image,
    this.date,
    required this.createdAt,
  });

  factory MoodData.fromRawJson(String str) =>
      MoodData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MoodData.fromJson(Map<String, dynamic> json) => MoodData(
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
