import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prosto_doc/core/helpers/big_title.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/current.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/new_scaffold.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  TextEditingController nameController = TextEditingController();

  bool onError = false;

  int selectedRole = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NewScaffold(
      cardHeight: 152,
      cardBody: const Center(
        child: BigTitle(text: 'Чем мы можем\nвам помочь?'),
      ),
      // emptyPadding: 27,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flexible(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              children: [
                const SizedBox(width: 22),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print('role 1');
                      selectedRole = 1;
                    });
                  },
                  child: Container(
                    height: 150.w,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: selectedRole == 1
                          ? AppColors.textColor
                          : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(48, 48, 48, 0.05),
                          offset: const Offset(0, 8),
                          blurRadius: 16.r,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 26.h),
                        SvgPicture.asset(
                          'assets/icons/doc.svg',
                          color: selectedRole == 1
                              ? AppColors.whiteColor
                              : AppColors.textColor,
                          width: 44,
                          height: 55,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Мне нужен \n документ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poopins',
                            fontSize: 14.h,
                            color: selectedRole == 1
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fontWeight: selectedRole == 1
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print('role 2');
                      selectedRole = 2;
                    });
                  },
                  child: Container(
                    height: 150.w,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: selectedRole == 2
                          ? AppColors.textColor
                          : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(48, 48, 48, 0.05),
                          offset: const Offset(0, 8),
                          blurRadius: 16.r,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 28.h),
                        SvgPicture.asset(
                          'assets/icons/man.svg',
                          color: selectedRole == 2
                              ? AppColors.whiteColor
                              : AppColors.textColor,
                          width: 85,
                          height: 66,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Я специалист',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poopins',
                            fontSize: 14.h,
                            color: selectedRole == 2
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fontWeight: selectedRole == 2
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          ),
          // Flexible(
          //   child: SizedBox(),
          //   flex: 2,
          // ),

          Padding(
            padding: const EdgeInsets.only(bottom: NewScaffold.bottomPadding),
            child: CustomButton(
              onTap: () async {
                if (selectedRole != 0) {
                  final auth = context.read<AuthCubit>();

                  auth.setUserType(
                      selectedRole == 1 ? 'is_client' : 'is_lawyer');
                  // print('new user ${auth.user?.toJson()}');
                  auth.updateUser();
                  // await context
                  //     .read<AuthCubit>()
                  //     .setToken(selectedRole == 1 ? 'is_client' : 'is_laywer');

                  Navigator.pushAndRemoveUntil(
                    context,
                    createRoute(const CurrentScreen()),
                    (route) => false,
                  );
                }
              },
              title: 'Далее',
            ),
          ),
        ],
      ),
    );
  }
}
