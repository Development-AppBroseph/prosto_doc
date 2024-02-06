import 'package:json_annotation/json_annotation.dart';

// 1994-02-01

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int? id;
  @JsonKey(name: "active_role")
  final String? activeRole;
  @JsonKey(name: "address_registration")
  final String? addressRegistration;
  @JsonKey(name: "avatar_path")
  final String? avatarPath;
  @DateTimeConverter()
  @JsonKey(name: "date_of_birth")
  final DateTime? dateOfBirth;
  final String? email;
  final String? inn;
  @JsonKey(name: "logo_in_document")
  final bool? logoInDocument;
  final String? name;
  final String? patronymic;
  @JsonKey(name: "phone_number")
  final String? phoneNumber;
  final String? surname;
  @JsonKey(name: "surname_declines")
  final bool? surnameDeclines;
  final String? logo;

  UserModel({
    required this.id,
    required this.activeRole,
    required this.addressRegistration,
    required this.avatarPath,
    required this.dateOfBirth,
    required this.email,
    required this.inn,
    required this.logoInDocument,
    required this.name,
    required this.patronymic,
    required this.phoneNumber,
    required this.surname,
    required this.surnameDeclines,
    required this.logo,
  });

  // factory UserModel.fromRawJson(String str) =>
  //     UserModel.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  UserModel copyWith({
    int? id,
    String? activeRole,
    String? addressRegistration,
    String? avatarPath,
    DateTime? dateOfBirth,
    String? email,
    String? inn,
    bool? logoInDocument,
    String? name,
    String? patronymic,
    String? phoneNumber,
    String? surname,
    bool? surnameDeclines,
    String? logo,
  }) =>
      UserModel(
        id: id ?? this.id,
        activeRole: activeRole ?? this.activeRole,
        addressRegistration: addressRegistration ?? this.addressRegistration,
        avatarPath: avatarPath ?? this.avatarPath,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        email: email ?? this.email,
        inn: inn ?? this.inn,
        logoInDocument: logoInDocument ?? this.logoInDocument,
        name: name ?? this.name,
        patronymic: patronymic ?? this.patronymic,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        surname: surname ?? this.surname,
        surnameDeclines: surnameDeclines ?? this.surnameDeclines,
        logo: logo ?? this.logo,
      );

  // factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
  //       id: json["id"],
  //       activeRole: json["active_role"],
  //       addressRegistration: json["address_registration"],
  //       avatarPath: json["avatar_path"],
  //       dateOfBirth: json["date_of_birth"] != null
  //           ? DateTime.parse(json["date_of_birth"])
  //           : null,
  //       email: json["email"],
  //       inn: json["inn"],
  //       logoInDocument: json["logo_in_document"],
  //       name: json["name"],
  //       patronymic: json["patronymic"],
  //       phoneNumber: json["phone_number"],
  //       surname: json["surname"],
  //       surnameDeclines: json["surname_declines"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "active_role": activeRole,
  //       "address_registration": addressRegistration,
  //       "avatar_path": avatarPath,
  //       "date_of_birth": dateOfBirth != null
  //           ? "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}"
  //           : null,
  //       "email": email,
  //       "inn": inn,
  //       "logo_in_document": logoInDocument,
  //       "name": name,
  //       "patronymic": patronymic,
  //       "phone_number": phoneNumber,
  //       "surname": surname,
  //       "surname_declines": surnameDeclines,
  //     };

  bool isLawyer() {
    return activeRole == 'is_lawyer';
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime dateOfBirth) =>
      "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}";
}
