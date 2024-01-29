import 'dart:convert';

class SendCodePhone {
  final int id;
  final String phone;
  final String code;
  final dynamic key;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  SendCodePhone({
    required this.id,
    required this.phone,
    required this.code,
    required this.key,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory SendCodePhone.fromRawJson(String str) =>
      SendCodePhone.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendCodePhone.fromJson(Map<String, dynamic> json) => SendCodePhone(
        id: json["id"],
        phone: json["phone"],
        code: json["code"],
        key: json["key"],
        dateCreated: DateTime.parse(json["date_created"]),
        dateUpdated: DateTime.parse(json["date_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "code": code,
        "key": key,
        "date_created": dateCreated.toIso8601String(),
        "date_updated": dateUpdated.toIso8601String(),
      };
}
