import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/auth/views/auth_view.dart';
import 'package:prosto_doc/features/auth/views/create_name_view.dart';
import 'package:prosto_doc/features/auth/views/help_view.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/bottom_view_new.dart';

class CurrentScreen extends StatefulWidget {
  const CurrentScreen({Key? key}) : super(key: key);

  @override
  State<CurrentScreen> createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  bool appStarted = false;
  bool isHome = false;
  @override
  void initState() {
    context.read<AuthCubit>().getToken();
    super.initState();
  }

  startApp() async {
    appStarted = true;
    await context.read<AuthCubit>().getUser();
    context.read<MainCubit>().role =
        context.read<AuthCubit>().user?.activeRole ?? '';
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isHome = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthMainState>(
      buildWhen: (previous, current) {
        if (current is AuthLogin) {
          startApp();
        }
        return current != previous;
      },
      builder: (context, state) {
        print(state);
        print(state is AuthLogin);
        return HelpView();
        if (state is AuthLogin || state is GetUserSuccess) {
          return Stack(
            children: [
              if (isHome) HomePage(),
              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: isHome ? 0 : 1,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOutQuint,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100.w),
                        child: Image.asset('assets/images/Group 14251.png'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        } else if (state is AuthLogout) {
          return const AuthView();
        }
        return Container();
      },
    );
  }
}
