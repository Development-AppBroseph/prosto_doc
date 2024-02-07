import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosto_doc/core/helpers/current.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ru_RU', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => AuthCubit())),
        BlocProvider(create: ((context) => MainCubit())),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Prosto Doc',
            home: child,
            // theme: ThemeData(primaryColor: AppColors.textColor),
            // routes: {
            //   '/': (context) => const MainCategoriesView(),
            //   '/docs': (context) => const DocumentsView(),
            //   '/profile': (context) => const ProfileView(),
            // },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('ru'),
            ],
          );
        },
        // child: AuthView(),
        child: const CurrentScreen(),
      ),
    );
  }
}
