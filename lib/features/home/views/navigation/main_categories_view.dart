import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/helpers/lists.dart';
import 'package:prosto_doc/core/models/category_model.dart';
import 'package:prosto_doc/core/models/category_model_old.dart';
import 'dart:math' as math;

import 'package:prosto_doc/features/auth/views/code_view.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/current_category_view.dart';
import 'package:prosto_doc/features/home/views/navigation/sub_categories_view.dart';

import '../../../../core/helpers/custom_page_route.dart';

class MainCategoriesView extends StatefulWidget {
  const MainCategoriesView({super.key});

  @override
  State<MainCategoriesView> createState() => _MainCategoriesViewState();
}

class _MainCategoriesViewState extends State<MainCategoriesView> {
  TextEditingController searchController = TextEditingController();
  List<Categories> searchedCategories = [];
  bool searching = false;
  List<Categories> categories = [];

  @override
  void initState() {
    getCategories();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchedCategories = categories
            .where(
              (element) => element.name!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()),
            )
            .toList();
        searching = true;
      } else {
        searchedCategories = [];
        searching = false;
      }
      setState(() {});
    });
    super.initState();
  }

  getCategories() async {
    categories = await context.read<MainCubit>().getCategories() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      main: true,
      body: SizedBox(
        height: 631,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 33),
            Center(
              child: Text(
                'Категории',
                style: TextStyle(
                  fontFamily: 'Poopins',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.h,
                  color: AppColors.textColor,
                ),
              ),
            ),
            SizedBox(height: 30),
            CustomTextField(
              hint: 'Поиск документов...',
              isPhone: false,
              // expand: false,
              textEditingController: searchController,
            ),
            SizedBox(height: 30),
            if (searchedCategories.isEmpty && searching)
              Column(
                children: [
                  const SizedBox(height: 85),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 49.w),
                    child: Text(
                      'Мы не нашли не одной категории по вашему запросу',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poopins',
                        fontSize: 24.h,
                        color: AppColors.textColor,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 33),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/dino_questions.svg',
                        width: 165.w,
                        height: 171.h,
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/icons/question.svg',
                          width: 10.6.w,
                          height: 16.6.h,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: SvgPicture.asset(
                          'assets/icons/dino.svg',
                          width: 67.w,
                          height: 101.h,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 34),
                ],
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: !searching
                      ? categories.length
                      : searchedCategories.length,
                  itemBuilder: (context, index) {
                    Categories currentModel = !searching
                        ? categories[index]
                        : searchedCategories[index];
                    print(currentModel.color);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            SubCategoriesView(category: currentModel),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 80.h,
                        width: 56.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (currentModel.icon != null)
                              Container(
                                height: 56.w,
                                width: 56.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundColor,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.network(
                                  docUrl + currentModel.icon!,
                                  height: 30.h,
                                  color: !currentModel.color!.contains('rgb')
                                      ? HexColor(
                                          (currentModel.color ?? '0000000'),
                                        )
                                      : null,
                                ),
                              )
                            else
                              Container(
                                height: 56.w,
                                width: 56.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                            // SizedBox(height: 8.h),
                            Text(
                              currentModel.name ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
