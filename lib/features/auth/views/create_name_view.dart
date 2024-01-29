import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/current.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/auth/views/help_view.dart';

class CreateNameView extends StatefulWidget {
  const CreateNameView({super.key});

  @override
  State<CreateNameView> createState() => _CreateNameViewState();
}

class _CreateNameViewState extends State<CreateNameView> {
  TextEditingController nameController = TextEditingController();

  bool onError = false;

  @override
  void initState() {
    // getUser();
    super.initState();
  }

  // getUser() async {
  //   var user = await context.read<AuthCubit>().getUser();

  //   if (user?.name != null) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       createRoute(CurrentScreen()),
  //       (route) => false,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // onPressDone: () {
      //   Navigator.push(context, createRoute(const HelpView()));
      // },
      body: SizedBox(
        // height: 242.h,
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                'Давайте знакомиться! \n  Как Вас зовут?',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.h,
                  color: AppColors.textColor,
                  height: 1.2.h,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h),
            CustomTextField(
              hint: 'Введите ваше имя',
              isPhone: false,
              textEditingController: nameController,
              isName: true,
              onError: onError,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      setState(() {
                        onError = true;
                      });
                    } else {
                      context.read<AuthCubit>().setName(nameController.text);
                      context.read<AuthCubit>().updateUser();
                      Navigator.push(context, createRoute(const HelpView()));
                      setState(() {
                        onError = false;
                      });
                    }
                  },
                  title: 'Далее',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
