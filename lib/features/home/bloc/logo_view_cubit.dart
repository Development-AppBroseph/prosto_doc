import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';

class LogoViewState {
  final String base64;
  final String name;

  const LogoViewState({
    required this.base64,
    required this.name,
  });
}

class LogoViewCubit extends Cubit<LogoViewState?> {
  LogoViewCubit({
    required this.authCubit,
  }) : super(null);

  final AuthCubit authCubit;

  Future<String?> uploadLogo() async {
    if (state == null) {
      return 'Файл не выбран';
    }
    authCubit.setLogo(state!.base64);
    try {
      authCubit.updateUser();
      return null;
    } on Object catch (e) {
      return e.toString();
    }
  }

  void setLogo(String base64, String name) {
    emit(
      LogoViewState(base64: 'data:image/jpg;base64,$base64', name: name),
    );
  }
}
