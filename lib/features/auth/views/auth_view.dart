import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/helpers/input_formatters.dart';
import 'package:prosto_doc/core/models/send_code_phone.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/auth/views/code_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  TextEditingController phoneController = TextEditingController();
  bool onError = false;

  @override
  void initState() {
    addListener();
    super.initState();
  }

  addListener() {
    phoneController.addListener(() async {
      String phone =
          phoneController.text.replaceAll(' ', '').replaceAll('-', '');
      // if (phone != '70000000000' && phone.length == 11) {
      //   setState(() {
      //     onError = true;
      //   });
      // } else
      if (phone.length == 12) {
        SendCodePhone? result =
            await context.read<AuthCubit>().sendCodePhone(phone);
        if (result != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            createRoute(
              CodeView(
                username: result.phone,
              ),
            ),
          );
        } else {
          setState(() {
            onError = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SizedBox(
        height: 322.h,
        child: Column(
          children: [
            SizedBox(height: 49.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                'Введите ваш \n номер телефона',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.h,
                  color: AppColors.textColor,
                  height: 1.2.h,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 60.h),
            CustomTextField(
              hint: '+7 900 000 00-00',
              isPhone: true,
              textEditingController: phoneController,
              onError: onError,
            ),
            SizedBox(height: 25.h),
            if (onError)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 52.w),
                child: Text(
                  'Данный пользователь\n заблокирован',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.h,
                    color: AppColors.errorColor,
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
