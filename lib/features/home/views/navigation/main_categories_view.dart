import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/helpers/new_main_scaffold.dart';
import 'package:prosto_doc/core/models/category_model.dart';

import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
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
                  .startsWith(searchController.text.toLowerCase()),
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
    return NewMainScaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 33),
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
          const SizedBox(height: 30),
          CustomTextField(
            hint: 'Поиск документов...',
            isPhone: false,
            // padding: 0,
            // expand: false,
            textEditingController: searchController,
          ),
          const SizedBox(height: 30),
          if (searchedCategories.isEmpty && searching)
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // const SizedBox(height: 40),
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
                    const SizedBox(height: 33),
                    Image.asset('assets/images/nothing_found.png'),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: !searching
                      ? categories.length
                      : searchedCategories.length,
                  itemBuilder: (context, index) {
                    Categories currentModel = !searching
                        ? categories[index]
                        : searchedCategories[index];
                    // print(currentModel.color);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            SubCategoriesView(category: currentModel),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        // color: Colors.red,
                        // width: 56.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            Flexible(
                              child: Text(
                                currentModel.name ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // const SizedBox(height: 8),
        ],
      ),
    );
    // return CustomScaffoldCategories(
    //   main: true,
    //   body:
    // );
  }
}
