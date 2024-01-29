import 'dart:convert';

class VerifedEmailCode {
  final bool verifed;

  VerifedEmailCode({
    required this.verifed,
  });

  factory VerifedEmailCode.fromRawJson(String str) =>
      VerifedEmailCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifedEmailCode.fromJson(Map<String, dynamic> json) =>
      VerifedEmailCode(
        verifed: json["verifed"],
      );

  Map<String, dynamic> toJson() => {
        "verifed": verifed,
      };
}
