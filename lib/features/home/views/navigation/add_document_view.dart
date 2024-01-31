import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/alert_toast.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/models/category_model.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';

class AddDocumentView extends StatefulWidget {
  AddDocumentView({super.key});

  @override
  State<AddDocumentView> createState() => _AddDocumentViewState();
}

class _AddDocumentViewState extends State<AddDocumentView> {
  FocusNode categoryFocus = FocusNode();

  FocusNode avaibilityFocus = FocusNode();

  FocusNode nameFocus = FocusNode();

  bool isOpenCategories = false;
  bool isOpenAvaibility = false;

  bool switchValue = true;
  List<Categories> categories = [];

  int? currentIndex;
  int? currentCategoryIndex;

  String documentName = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController avaibilityController = TextEditingController();
  File? selectedFile;

  bool info = true;

  @override
  void initState() {
    checkInfo();
    getCategories();
    super.initState();
  }

  getCategories() async {
    categories = await context.read<MainCubit>().getSubCategories() ?? [];
    setState(() {});
  }

  checkInfo() async {
    var instruction = await context.read<AuthCubit>().getInstruction();

    if (instruction != null) {
      if (instruction == 'true') {
        setState(() {
          info = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
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
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    info
                        ? 'Добавление\n документа \n \n(Правила загрузки)'
                        : 'Добавление\n документа',
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
            if (info)
              Column(
                children: [
                  SizedBox(height: 66.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Text(
                      'Сложно сказать, почему активно развивающиеся страны третьего мира могут быть функционально разнесены на независимые элементы. В рамках спецификации современных стандартов, акционеры крупнейших компаний будут в равной степени предоставлены сами себе. Принимая во внимание показатели успешности, перспективное планирование требует определения и уточнения как самодостаточных, так и внешне зависимых концептуальных решений.',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 101.h),
                  Container(
                    height: 35.h,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Больше не показывать',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.h,
                            color: AppColors.greyColor,
                          ),
                        ),
                        Switch.adaptive(
                          value: switchValue,
                          onChanged: (value) {
                            setState(() {
                              switchValue = value;
                            });
                          },
                          activeColor: AppColors.textColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 49.h),
                  CustomButton(
                    onTap: () {
                      setState(() {
                        context.read<AuthCubit>().setInstruction('true');
                        info = false;
                      });
                    },
                    title: 'Далее',
                  ),
                ],
              ),
            if (!info)
              Column(
                children: [
                  SizedBox(height: 66.h),
                  AnimatedContainer(
                    height: isOpenCategories ? 205.h : 52.h,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          height: isOpenCategories ? 205.h : 12.h,
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.25),
                                offset: const Offset(0, 0),
                                blurRadius: 2.r,
                              ),
                            ],
                            border: isOpenCategories
                                ? Border.all(
                                    width: 2.w,
                                    color: AppColors.buttonBlueColor,
                                  )
                                : null,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.w).add(
                            EdgeInsets.only(top: 20.h),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // SizedBox(height: 55.h),
                                SizedBox(
                                  height: 200.h,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: categories.length,
                                      padding: EdgeInsets.only(
                                        top: 60.h,
                                        bottom: 20.h,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentIndex = index;
                                              categoryController.text =
                                                  categories[index].name ?? '';

                                              isOpenCategories =
                                                  !isOpenCategories;
                                              categoryFocus.requestFocus();
                                            });
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 25.w),
                                                Text(
                                                  categories[index].name ?? '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                if (currentIndex == index)
                                                  SvgPicture.asset(
                                                      'assets/icons/Vector 13.svg'),
                                                SizedBox(width: 25.w),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomTextField(
                          enabled: false,
                          hint: 'Категория документа',
                          isPhone: false,
                          onTap: () {
                            // Future.delayed(const Duration(milliseconds: 500),
                            //     () {
                            print(123);
                            setState(() {
                              isOpenCategories = !isOpenCategories;
                              categoryFocus.requestFocus();
                            });
                            // });
                          },
                          focusNode: categoryFocus,
                          textEditingController: categoryController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  AnimatedContainer(
                    height: isOpenAvaibility ? 155.h : 52.h,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          height: isOpenAvaibility ? 205.h : 12.h,
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.25),
                                offset: const Offset(0, 0),
                                blurRadius: 2.r,
                              ),
                            ],
                            border: isOpenAvaibility
                                ? Border.all(
                                    width: 2.w,
                                    color: AppColors.buttonBlueColor,
                                  )
                                : null,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.w).add(
                            EdgeInsets.only(top: 20.h),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // SizedBox(height: 55.h),
                                SizedBox(
                                  height: 200.h,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 2,
                                      padding: EdgeInsets.only(
                                          top: 40.h, bottom: 20.h),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentCategoryIndex = index;
                                              avaibilityController.text =
                                                  index == 0
                                                      ? 'Общедоступный'
                                                      : 'Персональный';
                                              isOpenAvaibility =
                                                  !isOpenAvaibility;
                                              categoryFocus.requestFocus();
                                            });
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 25.w),
                                                Text(
                                                  index == 0
                                                      ? 'Общедоступный'
                                                      : 'Персональный',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                if (currentCategoryIndex ==
                                                    index)
                                                  SvgPicture.asset(
                                                      'assets/icons/Vector 13.svg'),
                                                SizedBox(width: 25.w),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomTextField(
                          enabled: false,
                          hint: 'Доступность документа',
                          isPhone: false,
                          onTap: () {
                            // Future.delayed(const Duration(milliseconds: 500),
                            //     () {
                            print(123);
                            setState(() {
                              isOpenAvaibility = !isOpenAvaibility;
                              categoryFocus.requestFocus();
                            });
                            // });
                          },
                          focusNode: categoryFocus,
                          textEditingController: avaibilityController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    hint: 'Название документа',
                    isPhone: false,
                    focusNode: nameFocus,
                    textEditingController: nameController,
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () async {
                      nameFocus.unfocus();
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        selectedFile = File(result.files.single.path!);
                        setState(() {
                          String fileToString =
                              selectedFile!.uri.toString().split('/').last;
                          String fileName = fileToString.replaceAll(
                              '.${fileToString.split('.').last}', '');
                          nameController.text = fileName;
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Container(
                      // height: 153.h,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 22.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.25),
                            blurRadius: 2.r,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 21.h),
                          SvgPicture.asset(
                            'assets/icons/add.svg',
                            height: 30.h,
                            width: 30.w,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Добавление\nдокумента',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.h,
                              color: AppColors.greyColor,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 90.h),
                  CustomButton(
                    onTap: () async {
                      info = false;
                      nameFocus.unfocus();
                      if (!info) {
                        if (currentIndex != null &&
                            avaibilityController.text.isNotEmpty &&
                            selectedFile != null) {
                          if (selectedFile!.path.contains('.docx') ||
                              selectedFile!.path.contains('.doc')) {
                            showAlertToast('Документ добавляется');
                            var result =
                                await context.read<MainCubit>().addDocument(
                                      categories[currentIndex!].id,
                                      avaibilityController.text,
                                      selectedFile!,
                                      nameController.text,
                                    );
                            if (result != null) {
                              nameFocus.unfocus();
                              Navigator.pop(context);
                            } else {
                              nameFocus.unfocus();
                              showAlertToast('Ошибка сервера');
                            }
                          } else {
                            nameFocus.unfocus();
                            showAlertToast('Необходимо выбрать документ Word');
                          }
                        } else {
                          nameFocus.unfocus();
                          showAlertToast('Проверьте заполнение всех полей');
                        }
                        // Navigator.pop(context);
                      }
                      setState(() {});
                    },
                    title: 'Далее',
                  ),
                  SizedBox(height: 100.h),
                ],
              )
          ],
        ),
      ),
    );
  }
}
