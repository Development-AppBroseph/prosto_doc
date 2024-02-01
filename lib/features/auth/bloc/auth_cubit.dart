import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/custom_interceptor.dart';
import 'package:prosto_doc/core/models/email_code.dart';
import 'package:prosto_doc/core/models/send_code_phone.dart';
import 'package:prosto_doc/core/models/token_model.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/core/models/verifed_email.dart';

part 'auth_state.dart';

final dio = Dio()..interceptors.add(DatasourceInterceptor());

const storage = FlutterSecureStorage();

class AuthCubit extends Cubit<AuthMainState> {
  AuthCubit() : super(AuthInitial());

  UserModel? user;

  // setName(String name) {
  //   state.name = name;
  //   emit(state.copyWith(name: state.name));
  // }

  // setPhone(String phone) {
  //   state.phone = phone;
  //   emit(state.copyWith(phone: state.phone));
  // }

  setToken(String value) async {
    // try {
    await storage.write(key: "PD_app_access_token", value: value);
    // state.token = value;
    // print(123);
    // emit(state.copyWith(token: state.token));
    emit(AuthLogin());
    // } catch (e) {

    //   inspect(e);
    // }
  }

  setInstruction(String? value) async {
    await storage.write(key: "instruction", value: value);
  }

  Future<String?> getInstruction() async {
    try {
      var instruction = await storage.read(key: "instruction");
      if (instruction != null) {
        return instruction;
        // emit(AuthLogout());
      }
    } catch (e) {
      inspect(e);
    }
  }

  Future<String?> getToken() async {
    try {
      var token = await storage.read(key: "PD_app_access_token");
      if (token != null) {
        emit(AuthLogin());
        return token;
        // emit(AuthLogout());
      } else {
        emit(AuthLogout());
      }
    } catch (e) {
      inspect(e);
    }
  }

  Future<SendCodePhone?> sendCodePhone(String phone) async {
    try {
      Response response =
          await dio.post('$baseUrl/api/v1/auth/send-code-phone', data: {
        "phone": phone,
      });

      if (response.statusCode == 200) {
        return SendCodePhone.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "Bad sendCodePhone";
    }
  }

  Future<TokenModel?> login(String username, String password) async {
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/auth/login/',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status! <= 500,
        ),
        data: {
          "username": username.toString(),
          "password": password.toString(),
        },
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
      // throw "${e.message}";
    }
  }

  Future<UserModel?> getUser() async {
    try {
      Response response = await dio.get('$baseUrl/api/v1/auth/me');

      if (response.statusCode == 200) {
        print(response.data);
        user = UserModel.fromJson(response.data);
        emit(GetUserSuccess());
        return user;
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
      // throw "${e.message}";
    }
  }

  Future<UserModel?> updateUser() async {
    print('updateUser()');
    print('Local user:');
    print(user?.toJson());
    try {
      Response response = await dio.put(
        // options: Options(contentType: Headers.formUrlEncodedContentType),
        '$baseUrl/api/v1/users/update/',
        data: user?.toJson(),
      );

      if (response.statusCode == 200) {
        emit(GetUserSuccess());
        user = UserModel.fromJson(response.data);
        return user;
      } else {
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw "Bad updateUser";
    }
  }

  Future<EmailCode?> sendEmailCode(String email) async {
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/users/email/',
        // options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "email": email,
        },
      );

      if (response.statusCode == 200) {
        return EmailCode.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw "${e.message}";
    }
  }

  Future<VerifedEmailCode?> checkEmailCode(String code, String email) async {
    try {
      Response response = await dio.post(
        '$baseUrl/api/v1/users/email/verifed/',
        // options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "code": code,
          "email": email,
        },
      );

      if (response.statusCode == 200) {
        return VerifedEmailCode.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    }
  }

  setLastname(String lastame) {
    user = user?.copyWith(surname: lastame);
  }

  setPatronomic(String patronomic) {
    user = user?.copyWith(patronymic: patronomic);
  }

  setSurnameDeclines(bool surnameDeclines) {
    user = user?.copyWith(surnameDeclines: surnameDeclines);
  }

  setLogoInDocument(bool logoInDocument) {
    user = user?.copyWith(logoInDocument: logoInDocument);
  }

  setPhone(String phone) {
    user = user?.copyWith(
      phoneNumber: phone.replaceAll(' ', '').replaceAll('-', ''),
    );
  }

  setEmail(String email) {
    user = user?.copyWith(email: email);
  }

  setInn(String inn) {
    user = user?.copyWith(inn: inn);
  }

  setAddress(String address) {
    user = user?.copyWith(addressRegistration: address);
  }

  setAvatar(String avatar) {
    user = user?.copyWith(avatarPath: 'data:image/jpg;base64,$avatar');
  }

  setDateBirth(DateTime dateOfBirth) {
    print(dateOfBirth);
    user = user?.copyWith(dateOfBirth: dateOfBirth);
  }

  setName(String name) {
    user = user?.copyWith(name: name);
    print(user?.name);
  }

  void setUserType(String type) {
    user = user?.copyWith(activeRole: type);
    print(user?.activeRole);
  }

  // Future login({required String emailOrPhone, required String pinCode}) async {
  //   try {
  //     Response response = await dio.post('$baseUrl/user/login',
  //         data: {"email_or_phone": emailOrPhone, "pin_code": pinCode});
  //     return response;
  //   } on DioException catch (e) {
  //     state.codeError = true;
  //     emit(state.copyWith(codeError: state.codeError));
  //     throw "${e.message}";
  //   }
  // }

  logout() async {
    try {
      await storage.deleteAll();
      // await dio.post(
      //   '$baseUrl/user/logout',
      // );
      // await storage.delete(key: 'TB_access_token');
      emit(AuthLogout());
      // return response;
    } catch (e) {
      inspect(e);
    }
  }

  deleteAccount() async {
    try {
      print('Account delete request');
      Response response = await dio.delete(
        '$baseUrl/api/v1/users/',
      );

      if (response.statusCode == 200) {
        print('Account deleted');
      } else {
        print(response?.statusCode);
        print(response?.data);
        return null;
      }
    } on DioException catch (e) {
      print(e.response?.statusCode);
      print(e.response?.data);
      return null;
    }
    logout();
  }

  // Future register(
  //     {required String first_name,
  //     required String email,
  //     required String phone,
  //     String? hash,
  //     bool? isMale}) async {
  //   try {
  //     String? gender;
  //     if (isMale != null) {
  //       if (isMale) {
  //         gender = 'Мужской';
  //       } else {
  //         gender = 'Женский';
  //       }
  //     }
  //     Response response = await dio.post('$baseUrl/user/register', data: {
  //       "first_name": first_name,
  //       "email": email,
  //       "gender": gender,
  //       "hash": hash,
  //       "phone": phone.replaceAll(' ', '')
  //     });
  //     return response;
  //   } on DioException catch (e) {
  //     if (e.response!.data['data']['phone'] != null) {
  //       state.errorField = LoginMethod.phone;
  //       state.errorMessage = e.response!.data['data']['phone'][0];
  //     } else if (e.response!.data['data']['email'] != null) {
  //       state.errorField = LoginMethod.email;
  //       state.errorMessage = e.response!.data['data']['email'][0];
  //     }
  //     emit(state.copyWith(
  //       errorField: state.errorField,
  //       errorMessage: state.errorMessage,
  //     ));
  //     throw "${e.message}";
  //   }
  // }
}
