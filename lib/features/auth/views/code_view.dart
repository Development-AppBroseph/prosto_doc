import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/current.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/models/token_model.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/auth/views/create_name_view.dart';

class CodeView extends StatefulWidget {
  final String username;
  const CodeView({super.key, required this.username});

  @override
  State<CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  TextEditingController codeController = TextEditingController();

  bool onError = false;

  @override
  void initState() {
    addListener();
    super.initState();
  }

  getUser() async {
    print(20202020);
    var user = await context.read<AuthCubit>().getUser();

    print('user: ' + user.toString());

    if (user != null) {
      if (user.name != null) {
        Navigator.pushAndRemoveUntil(
          context,
          createRoute(CurrentScreen()),
          (route) => false,
        );
      } else {
        Navigator.push(context, createRoute(const CreateNameView()));
      }
    } else {
      setState(() {
        onError = true;
      });
    }
  }

  addListener() {
    codeController.addListener(() async {
      String code = codeController.text;
      // if (code.length == 4 && code != widget.code) {
      //   setState(() {
      //     onError = true;
      //   });
      // } else if (code.length == 4 && widget.code == code) {
      //   // Navigator.push(context, createRoute(const CreateNameView()));
      // }
      if (code.length == 4) {
        TokenModel? result =
            await context.read<AuthCubit>().login(widget.username, code);
        if (result != null) {
          await storage.write(
            key: "PD_app_access_token",
            value: result.accessToken,
          );
          await storage.write(
            key: "PD_refresh_token",
            value: result.refreshToken,
          );
          getUser();
        } else {
          setState(() {
            onError = true;
          });
        }
      } else {
        setState(() {
          onError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SizedBox(
        height: 348,
        child: Column(
          children: [
            const SizedBox(height: 49),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                'Введите код,\nкоторый мы\nотправили по СМС',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: AppColors.textColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            CustomTextField(
              hint: '1234',
              isPhone: false,
              expand: false,
              isCode: true,
              textEditingController: codeController,
              onError: onError,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                'СМС код не пришёл,\n позвоните мне',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.h,
                  fontFamily: 'Poppins',
                  height: 1.3,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
