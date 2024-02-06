import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prosto_doc/core/helpers/address_textfield.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/back_button.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/dialogs.dart';
import 'package:prosto_doc/core/helpers/validators.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  FocusNode nameFocus = FocusNode();

  FocusNode lastNameFocus = FocusNode();

  FocusNode surnameFocus = FocusNode();

  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode innFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  String? avatarPath;

  FocusNode dateFocus = FocusNode();

  TextEditingController dateController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController innController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late DateTime _currentdate;

  XFile? curentImage;

  bool isUser = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  _getUserProfile() async {
    AuthCubit authCubit = context.read<AuthCubit>();
    if (authCubit.user?.activeRole != 'is_client') {
      isUser = false;
    }
    setState(() {
      nameController.text = authCubit.user?.name ?? '';
      lastnameController.text = authCubit.user?.surname ?? '';
      surnameController.text = authCubit.user?.patronymic ?? '';
      phoneController.text = authCubit.user?.phoneNumber ?? '';
      emailController.text = authCubit.user?.email ?? '';
      if (authCubit.user?.dateOfBirth != null) {
        _currentdate = authCubit.user!.dateOfBirth!;
        dateController.text =
            DateFormat('dd.MM.yyyy').format(authCubit.user!.dateOfBirth!);
      }
      avatarPath = authCubit.user?.avatarPath;
      innController.text = authCubit.user?.inn ?? '';
      addressController.text = authCubit.user?.addressRegistration ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.read<AuthCubit>();
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 36),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 9.h, top: 16.h),
                      child: CustomBackButton(),
                    ),
                    GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 2,
                        )
                            .then((value) {
                          setState(() {
                            curentImage = value;
                          });
                        });
                      },
                      child: Container(
                        height: 200.w,
                        width: 200.w,
                        child: Stack(
                          children: [
                            // AppImages(height: 200.h, width: 200.w)
                            //     .assetImage('assets/images/man.png'),
                            Container(
                              height: 200.w,
                              width: 200.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.greyColor.withOpacity(0.5),
                              ),
                            ),
                            Center(
                              child: SvgPicture.asset(
                                'assets/icons/camera.svg',
                                width: 85.w,
                                height: 66.h,
                              ),
                            ),
                            if (avatarPath != null)
                              if (avatarPath!.contains('data:image/jpg;base64'))
                                Container(
                                  height: 200.h,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greyColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150.r),
                                    child: Image.memory(
                                      base64Decode(avatarPath!.replaceAll(
                                          'data:image/jpg;base64,', '')),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 200.w,
                                  width: 200.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greyColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150.r),
                                    child: Image.network(
                                      docUrl + avatarPath!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            if (curentImage != null)
                              Container(
                                height: 200.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.greyColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(150.r),
                                  child: Image.file(
                                    File(curentImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 9.h, top: 16.h),
                      child: CustomBackButton.fake(),
                    ),
                  ],
                ),
                SizedBox(height: 64.h),
                CustomTextField(
                  hint: 'Имя',
                  isPhone: false,
                  focusNode: nameFocus,
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  },
                  validator: nonEmpty,
                  textEditingController: nameController,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'Фамилия',
                  isPhone: false,
                  focusNode: lastNameFocus,
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  },
                  validator: nonEmpty,
                  textEditingController: lastnameController,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'Отчество',
                  isPhone: false,
                  focusNode: surnameFocus,
                  onTap: () {
                    setState(() {});
                  },
                  textEditingController: surnameController,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'Номер телефона',
                  isPhone: true,
                  focusNode: phoneFocus,
                  onTap: () {
                    setState(() {});
                  },
                  textEditingController: phoneController,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'Дата рождения',
                  isPhone: true,
                  isDate: true,
                  focusNode: dateFocus,
                  onTap: () {
                    // showCupertinoDialog(context: context, builder: )
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Container(
                        height: 325.h,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 250.h,
                              child: CupertinoDatePicker(
                                initialDateTime: dateController.text == ''
                                    ? DateTime.now()
                                    : _currentdate,
                                onDateTimeChanged: (DateTime newdate) {
                                  print(newdate);
                                  setState(() {
                                    _currentdate = newdate;
                                    dateController.text =
                                        DateFormat('dd.MM.yyyy')
                                            .format(newdate);
                                  });
                                },
                                use24hFormat: true,
                                maximumDate: new DateTime(2050, 12, 30),
                                minimumYear: 1950,
                                maximumYear: DateTime.now().year,
                                minuteInterval: 1,
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ),
                            // SizedBox(height: 20.h),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Выбрать дату',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    // showDatePicker(
                    //     context: context,
                    //     initialDate: DateTime.now(),
                    //     firstDate: DateTime(1950, 1, 1),
                    //     lastDate: DateTime.now());
                  },
                  validator: nonEmpty,
                  textEditingController: dateController,
                ),
                if (!isUser)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextField(
                        hint: 'prostodoc@doc.ru',
                        isPhone: false,
                        focusNode: emailFocus,
                        onTap: () {
                          setState(() {});
                        },
                        validator: nonEmpty,
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hint: 'NNNNXXXXXXCC',
                        isPhone: false,
                        focusNode: innFocus,
                        onTap: () {
                          setState(() {});
                        },
                        validator: nonEmpty,
                        textEditingController: innController,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: AddressTextField(
                          addressController,
                          'г. Москва, ул Пушкина дом 9',
                          validator: nonEmpty,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 52),
                GestureDetector(
                  onTap: () async {
                    await deleteDialog(
                      context: context,
                      title: 'Вы действительно\nхотите удалить\fаккаунт?',
                      onConfirm: () async {
                        context.read<AuthCubit>().deleteAccount();
                      },
                    );
                  },
                  child: Container(
                    height: 23.h,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/trash_fill.svg',
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Удалить аккаунт',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.h,
                            color: const Color.fromRGBO(174, 29, 29, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 52),
                CustomButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await authCubit.setName(nameController.text.trim());
                        await authCubit
                            .setLastname(lastnameController.text.trim());
                        await authCubit
                            .setPatronomic(surnameController.text.trim());
                        await authCubit.setEmail(emailController.text.trim());

                        if (dateController.text.isNotEmpty) {
                          await authCubit.setDateBirth(_currentdate);
                        }
                        if (!isUser) {
                          await authCubit.setInn(innController.text);
                          await authCubit.setAddress(addressController.text);
                        }
                        if (curentImage != null) {
                          final bytes =
                              File(curentImage!.path).readAsBytesSync();

                          String img64 = base64Encode(bytes);
                          await authCubit.setAvatar(img64);
                        }

                        authCubit.updateUser();
                        Navigator.pop(context);
                      }
                    },
                    title: 'Сохранить'),
                SizedBox(height: 140.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
