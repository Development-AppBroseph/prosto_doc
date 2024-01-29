import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_page_route.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/models/client_model.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/add_document_view.dart';
import 'package:prosto_doc/features/home/views/navigation/client_info_view.dart';
import 'package:prosto_doc/features/home/views/navigation/client_profile_view.dart';

class ClientsView extends StatefulWidget {
  ClientsView({super.key});

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  int currentIndex = 0;

  List<UserModel> clients = [];

  bool info = true;

  @override
  void initState() {
    // TODO: implement initState
    getClients();
    super.initState();
  }

  getClients() async {
    var result = await context.read<MainCubit>().getClients();
    if (result != null) {
      setState(() {
        clients = result;
      });
    }
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
                      padding: EdgeInsets.only(left: 29.h, top: 16.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 20.h,
                          width: 20.w,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/arrow.svg',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        'Мои клиенты',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24.h,
                          fontWeight: FontWeight.w700,
                          color: AppColors.buttonBlueColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 29.h, top: 16.h),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      return currentCategory(
                        clients[index].name.toString(),
                        clients[index],
                      );
                    }),
                // currentCategory(
                //   'Виктор Степанов',
                //   0,
                // ),
                // currentCategory(
                //   'Виктор Степанов',
                //   1,
                // ),
                // currentCategory(
                //   'Виктор Степанов',
                //   2,
                // ),
                // currentCategory(
                //   'Виктор Степанов',
                //   3,
                // ),
                SizedBox(height: 100.h)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 120.h),
              child: CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    createRoute(
                      ClientProfileView(),
                    ),
                  ).then((value) {
                    getClients();
                  });
                },
                title: 'Добавить нового клиента',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currentCategory(String title, UserModel userModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          createRoute(
            ClientInfoView(
              clientModel: userModel,
            ),
          ),
        ).then((value) async {
          // if (value != null) {
          clients = (await context.read<MainCubit>().getClients()) ?? clients;
          setState(() {});
          // if (value is ClientModel) {
          //   clients.elementAt(index).dateBirth = value.dateBirth;
          //   clients.elementAt(index).name = value.name;
          //   clients.elementAt(index).lastname = value.lastname;
          //   clients.elementAt(index).dateBirth = value.dateBirth;
          //   clients.elementAt(index).dateBirth = value.dateBirth;
          // }
          // }
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
          color: Colors.white,
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
              title,
              style: GoogleFonts.poppins(
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
              ),
            ),
            const Expanded(child: SizedBox()),
            if (userModel.avatarPath != null)
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(docUrl + userModel.avatarPath!),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(10.0),
                // child: Image.network(
                //   docUrl + userModel.avatarPath!,
                //   fit: BoxFit.cover,
                // ),
              )
            else
              Container(
                color: Colors.transparent,
                margin: EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  'assets/icons/person.svg',
                  height: 40,
                  width: 40,
                  color: AppColors.greyColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
