import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/back_button.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/add_document_view.dart';

class ChooseUserView extends StatefulWidget {
  ChooseUserView({super.key});

  @override
  State<ChooseUserView> createState() => _ChooseUserViewState();
}

class _ChooseUserViewState extends State<ChooseUserView> {
  UserModel? currentModel;
  List<UserModel> clients = [];

  bool info = true;

  @override
  void initState() {
    getClients();
    super.initState();
  }

  getClients() async {
    clients = await context.read<MainCubit>().getClients() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 77.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 9.h, top: 16.h),
                      child: CustomBackButton(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        'Для кого формируем\nдокумент?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24.h,
                          fontWeight: FontWeight.w700,
                          color: AppColors.buttonBlueColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 9.h, top: 16.h),
                      child: CustomBackButton.fake(),
                    ),
                  ],
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      return currentCategory(
                        clients[index].name.toString(),
                        clients[index] == currentModel,
                        clients[index],
                      );
                    }),
                SizedBox(height: 170.h),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100.h),
              child: CustomButton(
                onTap: () {
                  if (currentModel != null) {
                    Navigator.push(
                      context,
                      createRoute(
                        AddDocumentView(),
                      ),
                    );
                  }
                },
                title: 'Далее',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currentCategory(String title, bool current, UserModel model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentModel = model;
        });
      },
      child: Container(
        height: 55.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 22.w).add(
          EdgeInsets.only(top: 20.h),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.r),
          color: current ? AppColors.buttonBlueColor : Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4.r,
              color: const Color.fromRGBO(0, 0, 0, 0.25),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 22.w),
            Text(
              model.name ?? '',
              style: GoogleFonts.poppins(
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
                color: current ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset('assets/images/Ellipse123.png'),
            ),
          ],
        ),
      ),
    );
  }
}
