import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/back_button.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/home/bloc/logo_view_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/add_logo_view/add_logo_error.dart';
import 'package:prosto_doc/features/home/views/navigation/add_logo_view/add_logo_success.dart';

class AddLogoView extends StatelessWidget {
  const AddLogoView({required this.logoExists, super.key});

  final bool logoExists;

  @override
  Widget build(BuildContext oc) {
    return BlocProvider(
      create: (_) => LogoViewCubit(
        authCubit: BlocProvider.of<AuthCubit>(oc),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 9,
                right: 9,
                bottom: 86 + 41, //86 is bottom nav bar height
              ),
              child: Column(
                children: [
                  const SizedBox(height: 27),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBackButton(),
                      Text(
                        logoExists
                            ? 'Изменение\n логотипа'
                            : 'Добавление\n логотипа',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.buttonBlueColor,
                        ),
                      ),
                      CustomBackButton.fake(),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22 - 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Правила размещения логотипа: Ваш логотип должен быть в формате png, jpeg не более 2мб. Фон у логотипа должен отсутствовать (прозрачный фон). Логотип на документ добавляется в правый верхний угол.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          BlocBuilder<LogoViewCubit, LogoViewState?>(
                            builder: (context, state) {
                              String text = '';
                              if (state != null) {
                                text = state.name;
                              } else {
                                text = 'Файл не выбран';
                              }

                              return CustomTextField(
                                hint: '',
                                isPhone: false,
                                textEditingController:
                                    TextEditingController(text: text),
                                enabled: false,
                                padding: 0,
                              );
                            },
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              // nameFocus.unfocus();
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType
                                          .image); //allowedExtensions: ['png', 'jpeg', 'jpg'], type: FileType.image

                              if (result != null) {
                                final selectedFile =
                                    File(result.files.single.path!);
                                // setState(() {
                                String fileToString = selectedFile!.uri
                                    .toString()
                                    .split('/')
                                    .last;
                                String fileName = fileToString.replaceAll(
                                    '.${fileToString.split('.').last}', '');

                                final bytes = selectedFile.readAsBytesSync();
                                String img64 = base64Encode(bytes);

                                BlocProvider.of<LogoViewCubit>(context)
                                    .setLogo(img64, fileToString);

                                print('$fileToString $fileName');
                                //   nameController.text = fileName;
                                // });
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Container(
                              // height: 153.h,
                              width: double.infinity,
                              // margin: const EdgeInsets.symmetric(horizontal: 22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.blackColor.withOpacity(0.25),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 21),
                                  SvgPicture.asset(
                                    'assets/icons/add.svg',
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Добавление\nдокумента',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 53),
                          CustomButton(
                            onTap: () async {
                              final bloc =
                                  BlocProvider.of<LogoViewCubit>(context);
                              final result = await bloc.uploadLogo();
                              showUploadResult(
                                  result, bloc.state?.base64, context);
                            },
                            title: 'Добавить',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showUploadResult(String? msg, String? base64, BuildContext context) {
  try {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 21),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: msg != null
              ? AddLogoError(
                  error: msg,
                )
              : AddLogoSuccess(
                  base64: base64!,
                ),
        );
      },
    ).then((val) {
      if (msg == null) {
        Navigator.pop(context);
      }
    });
  } on Object catch (e) {
    print(e);
  }
}
