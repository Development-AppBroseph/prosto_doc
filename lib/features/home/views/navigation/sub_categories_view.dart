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

import '../../../../core/helpers/custom_page_route.dart';

class SubCategoriesView extends StatefulWidget {
  final Categories category;
  const SubCategoriesView({super.key, required this.category});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
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
    categories =
        await context.read<MainCubit>().getSubcategories(widget.category.id) ??
            [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: HexColor(widget.category.color!),
      main: true,
      body: SizedBox(
        // height: 152.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 33.h),
            Padding(
              padding: EdgeInsets.only(left: 19.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 24.h,
                      width: 16.w,
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        height: 14.h,
                        width: 16.w,
                        color: HexColor(widget.category.color!),
                      ),
                    ),
                  ),
                  SizedBox(width: 11.w),
                  Text(
                    widget.category.name ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.h,
                      color: HexColor(widget.category.color!),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            CustomTextField(
              hint: 'Поиск документов...',
              isPhone: false,
              textEditingController: searchController,
            ),
            SizedBox(height: 30.h),
            if (searchedCategories.isEmpty && searching)
              Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 49.w),
                    child: Text(
                      'Мы не нашли не одной категории по вашему запросу',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24.h,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 33.h),
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
                  SizedBox(height: 34.h),
                ],
              )
            else
              SizedBox(
                height: 423.h,
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            CurrentCategoryView(
                              categoryModel: currentModel,
                              categoryColor: HexColor(widget.category.color!),
                            ),
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
                                height: 56.h,
                                width: 56.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundColor,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.network(
                                  docUrl + currentModel.icon!,
                                  height: 30.h,
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
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/doc.svg',
                                  height: 30.h,
                                  width: 30.h,
                                  color: HexColor(widget.category.color!),
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
