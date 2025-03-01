// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      activeRole: json['active_role'] as String?,
      addressRegistration: json['address_registration'] as String?,
      avatarPath: json['avatar_path'] as String?,
      dateOfBirth: _$JsonConverterFromJson<String, DateTime>(
          json['date_of_birth'], const DateTimeConverter().fromJson),
      email: json['email'] as String?,
      inn: json['inn'] as String?,
      logoInDocument: json['logo_in_document'] as bool?,
      name: json['name'] as String?,
      patronymic: json['patronymic'] as String?,
      phoneNumber: json['phone_number'] as String?,
      surname: json['surname'] as String?,
      surnameDeclines: json['surname_declines'] as bool?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'active_role': instance.activeRole,
      'address_registration': instance.addressRegistration,
      'avatar_path': instance.avatarPath,
      'date_of_birth': _$JsonConverterToJson<String, DateTime>(
          instance.dateOfBirth, const DateTimeConverter().toJson),
      'email': instance.email,
      'inn': instance.inn,
      'logo_in_document': instance.logoInDocument,
      'name': instance.name,
      'patronymic': instance.patronymic,
      'phone_number': instance.phoneNumber,
      'surname': instance.surname,
      'surname_declines': instance.surnameDeclines,
      'logo': instance.logo,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
