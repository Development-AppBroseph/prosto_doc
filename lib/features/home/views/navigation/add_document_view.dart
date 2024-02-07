import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/alert_toast.dart';
import 'package:prosto_doc/core/helpers/back_button.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/models/category_model.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';

class AddDocumentView extends StatefulWidget {
  const AddDocumentView({super.key});

  @override
  State<AddDocumentView> createState() => _AddDocumentViewState();
}

class _AddDocumentViewState extends State<AddDocumentView> {
  FocusNode categoryFocus = FocusNode();

  FocusNode avaibilityFocus = FocusNode();

  FocusNode nameFocus = FocusNode();

  final ValueNotifier<bool> isOpenCategories = ValueNotifier(false);
  final ValueNotifier<bool> isOpenAvaibility = ValueNotifier(false);

  // bool isOpenCategories = false;
  // bool isOpenAvaibility = false;

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 27),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 9),
                    child: CustomBackButton(),
                  ),
                  Text(
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
                  const Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: CustomBackButton.fake(),
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
                          CupertinoSwitch(
                            activeColor: AppColors.textColor,
                            value: switchValue,
                            onChanged: (value) {
                              setState(() {
                                switchValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 49.h),
                    CustomButton(
                      onTap: () {
                        setState(() {
                          if (switchValue) {
                            context.read<AuthCubit>().setInstruction('true');
                          }
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
                      height: isOpenCategories.value ? 205.h : 52.h,
                      duration: const Duration(milliseconds: 200),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: AnimatedContainer(
                              height: isOpenCategories.value ? 205.h : 12.h,
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
                                border: isOpenCategories.value
                                    ? Border.all(
                                        width: 2.w,
                                        color: AppColors.buttonBlueColor,
                                      )
                                    : null,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 22),
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
                                            top: 40,
                                            bottom: 20.h,
                                          ),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  currentIndex = index;
                                                  categoryController.text =
                                                      categories[index].name ??
                                                          '';

                                                  isOpenCategories.value =
                                                      !isOpenCategories.value;
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
                                                      categories[index].name ??
                                                          '',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14.h,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blackColor,
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
                                isOpenCategories.value =
                                    !isOpenCategories.value;
                                categoryFocus.requestFocus();
                              });
                              // });
                            },
                            listenable: isOpenCategories,
                            focusNode: categoryFocus,
                            textEditingController: categoryController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AnimatedContainer(
                      height: isOpenAvaibility.value ? 155.h : 52.h,
                      duration: const Duration(milliseconds: 200),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: AnimatedContainer(
                              height: isOpenAvaibility.value ? 205.h : 12.h,
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
                                border: isOpenAvaibility.value
                                    ? Border.all(
                                        width: 2.w,
                                        color: AppColors.buttonBlueColor,
                                      )
                                    : null,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // SizedBox(height: 55),
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
                                                  isOpenAvaibility.value =
                                                      !isOpenAvaibility.value;
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
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14.h,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .blackColor,
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
                                isOpenAvaibility.value =
                                    !isOpenAvaibility.value;
                                categoryFocus.requestFocus();
                              });
                              // });
                            },
                            listenable: isOpenAvaibility,
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
                    DocumentBlock(
                      hasFile: selectedFile != null,
                      onAddFile: () async {
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
                              nameFocus.unfocus();
                              Navigator.pop(context);
                              var result =
                                  await context.read<MainCubit>().addDocument(
                                        categories[currentIndex!].id,
                                        avaibilityController.text,
                                        selectedFile!,
                                        nameController.text,
                                      );

                              if (result != null) {
                                // nameFocus.unfocus();
                              } else {
                                // nameFocus.unfocus();
                                showAlertToast('Ошибка сервера');
                              }
                            } else {
                              nameFocus.unfocus();
                              showAlertToast(
                                  'Необходимо выбрать документ Word');
                            }
                          } else {
                            nameFocus.unfocus();
                            showAlertToast('Проверьте заполнение всех полей');
                          }
                          // Navigator.pop(context);
                        }
                      },
                      title: 'Далее',
                    ),
                    SizedBox(height: 100.h),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentBlock extends StatelessWidget {
  final Future<void> Function() onAddFile;
  final bool hasFile;

  const DocumentBlock(
      {required this.onAddFile, required this.hasFile, super.key});

  @override
  Widget build(BuildContext context) {
    if (!hasFile) {
      return BigAddDocButton(
        onBigTap: onAddFile,
      );
    } else {
      return Row(
        children: [
          SizedBox(width: 22),
          DocIcon(),
          SizedBox(width: 16),
          SmallAddDocButton(
            onSmallTap: onAddFile,
          ),
        ],
      );
    }
  }
}

class DocIcon extends StatelessWidget {
  const DocIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
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
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/doc2.svg',
          width: 39,
          height: 49,
        ),
      ),
    );
  }
}

class SmallAddDocButton extends StatelessWidget {
  const SmallAddDocButton({required this.onSmallTap, super.key});

  final Future<void> Function() onSmallTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSmallTap,
      child: Container(
        height: 90,
        width: 90,
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
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/add.svg',
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}

class BigAddDocButton extends StatelessWidget {
  const BigAddDocButton({
    required this.onBigTap,
    super.key,
  });

  final Future<void> Function() onBigTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBigTap,
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
    );
  }
}
