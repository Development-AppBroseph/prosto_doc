import 'dart:convert';

class EmailCode {
  final bool send;

  EmailCode({
    required this.send,
  });

  factory EmailCode.fromRawJson(String str) =>
      EmailCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EmailCode.fromJson(Map<String, dynamic> json) => EmailCode(
        send: json["send"],
      );

  Map<String, dynamic> toJson() => {
        "send": send,
      };
}
