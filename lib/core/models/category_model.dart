import 'dart:convert';

class Categories {
  final int id;
  final String? color;
  final String? icon;
  final String? name;
  final int? parentId;

  Categories({
    required this.id,
    required this.color,
    required this.icon,
    required this.name,
    required this.parentId,
  });

  Categories copyWith({
    String? color,
    String? icon,
    String? name,
    int? parentId,
  }) =>
      Categories(
        id: id,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        name: name ?? this.name,
        parentId: parentId ?? this.parentId,
      );

  factory Categories.fromRawJson(String str) =>
      Categories.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        color: json["color"],
        icon: json["icon"],
        name: json["name"],
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "icon": icon,
        "name": name,
        "parent_id": parentId,
      };
}
