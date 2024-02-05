import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/new_scaffold.dart';
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
    return NewScaffold(
      // emptyPadding: 200,
      cardHeight: 320,
      cardBody: SizedBox(
        height: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52.w),
              child: Text(
                'Давайте знакомиться! \n\n Как Вас зовут?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.h,
                  fontFamily: 'Poopins',
                  color: AppColors.textColor,
                  height: 1.2.h,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            CustomTextField(
              hint: 'Введите ваше имя',
              // expand: false,
              isPhone: false,
              textEditingController: nameController,
              isName: true,
              onError: onError,
            ),
            // SizedBox(height: 76),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: NewScaffold.bottomPadding),
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
    );
  }
}
