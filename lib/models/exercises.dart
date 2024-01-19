import 'dart:convert';

class ExerciseData {
  int id;
  String name;
  String improvement;
  String type;
  String explanation;
  // IVAN SI LEES ESTO AVISAME
  String image;
  String? audio;
  String? video;
  int? made;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExerciseData({
    required this.id,
    required this.name,
    required this.improvement,
    required this.type,
    required this.explanation,
    required this.image,
    this.audio,
    this.video,
    this.made,
    this.createdAt,
    this.updatedAt,
  });

  factory ExerciseData.fromRawJson(String str) =>
      ExerciseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExerciseData.fromJson(Map<String, dynamic> json) => ExerciseData(
        id: json["id"],
        name: json["name"],
        improvement: json["improvement"],
        type: json["type"],
        explanation: json["explanation"],
        image: json["image"],
        made: json["made"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "improvement": improvement,
        "type": type,
        "explanation": explanation,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "update_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'ExerciseData(id: $id, name: $name, improvement: $improvement, type: $type, explanation: $explanation, image: $image, audio: $audio, video: $video, made: $made)';
  }
}
