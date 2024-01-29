part of 'main_cubit.dart';

abstract class MainState {}

class AuthState extends MainState {
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

class MainInitial extends MainState {}

class MyDocumentGeted extends MainState {
  List<Item> documents;

  MyDocumentGeted({required this.documents});
}
