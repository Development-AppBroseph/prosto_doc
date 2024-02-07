import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/helpers.dart';
import 'package:prosto_doc/core/helpers/lists.dart';
import 'package:prosto_doc/core/helpers/new_main_scaffold.dart';
import 'package:prosto_doc/core/models/category_model.dart';
import 'package:prosto_doc/core/models/category_model_old.dart';
import 'package:prosto_doc/core/models/document_model.dart';
import 'dart:math' as math;

import 'package:prosto_doc/features/auth/views/code_view.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/current_document_view.dart';

import '../../../../core/helpers/custom_page_route.dart';

class CurrentCategoryView extends StatefulWidget {
  final Color categoryColor;
  final Categories categoryModel;
  const CurrentCategoryView({
    super.key,
    required this.categoryModel,
    required this.categoryColor,
  });

  @override
  State<CurrentCategoryView> createState() => _CurrentCategoryViewState();
}

class _CurrentCategoryViewState extends State<CurrentCategoryView> {
  TextEditingController searchController = TextEditingController();
  List<Item> searchedCategories = [];
  bool searching = false;
  List<Item> documents = [];

  @override
  void initState() {
    // getCurrentCatgegory();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchedCategories = documents
            .where(
              (element) => element.title
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

  // getCurrentCatgegory() async {
  //   documents = (await context
  //               .read<MainCubit>()
  //               .getDocumentsByCategory(widget.categoryModel.id))
  //           ?.items ??
  //       [];
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.categoryColor);
    print(widget.categoryModel.color);
    return NewMainScaffold(
      backgroundColor: widget.categoryColor,
      // main: true,
      body: FutureBuilder<DocumentModel?>(
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            documents = snapshot.data!.items;
            print(documents.length);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 33),
                Padding(
                  padding: EdgeInsets.only(left: 9.w),
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
                          // height: 24.h,
                          // width: 16.w,
                          margin: EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icons/arrow.svg',
                            height: 14.h,
                            width: 16.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 11.w),
                      Text(
                        widget.categoryModel.name ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.h,
                          color: widget.categoryColor,
                        ),
                      ),
                    ],
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
                      SizedBox(height: 85),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 49.w),
                        child: Text(
                          'Мы не нашли ни одного документа по вашему запросу',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poopins',
                            fontSize: 24.h,
                            color: AppColors.textColor,
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: !searching
                          ? snapshot.data!.items.length
                          : searchedCategories.length,
                      itemBuilder: (context, index) {
                        Item currentModel = !searching
                            ? snapshot.data!.items[index]
                            : searchedCategories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              createRoute(
                                  CurrentDocumentView(item: currentModel)),
                            );
                          },
                          child: SizedBox(
                            height: 80.h,
                            width: 56.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 56.w,
                                  width: 56.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.backgroundColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppLists.categories
                                        .firstWhere((element) =>
                                            element.name == 'Договоры')
                                        .assetPath,
                                    height: 30.h,
                                    // color: HexColor(),
                                  ),
                                ),
                                // SizedBox(height: 8.h),
                                Text(
                                  currentModel.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.h,
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
            );
          }
          return Container(
            // height: 610.h,
            alignment: Alignment.center,
            child: CircularProgressIndicator.adaptive(),
          );
        },
        future: context
            .read<MainCubit>()
            .getDocumentsByCategory(widget.categoryModel.id),
      ),
    );
  }
}
