part of 'auth_cubit.dart';

abstract class AuthMainState {}

class AuthState extends AuthMainState {
  String? name;
  String? phone;

  String? token;

  AuthState({
    this.name,
    this.phone,
    this.token,
  });

  AuthState copyWith({
    String? name,
    String? phone,
    String? email,
    String? token,
  }) {
    return AuthState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }
}

class AuthLogin extends AuthMainState {}

class GetUserSuccess extends AuthMainState {}

class AuthInitial extends AuthMainState {}

class AuthLogout extends AuthMainState {}
