import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/alert_toast.dart';
import 'package:prosto_doc/core/helpers/api_constants.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_scaffold.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/dialogs.dart';
import 'package:prosto_doc/core/helpers/images.dart';
import 'package:prosto_doc/core/helpers/lists.dart';
import 'package:prosto_doc/core/models/category_model_old.dart';
import 'package:prosto_doc/core/models/email_code.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/core/models/verifed_email.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/auth/views/auth_view.dart';
import 'dart:math' as math;

import 'package:prosto_doc/features/auth/views/code_view.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/add_document_view.dart';
import 'package:prosto_doc/features/home/views/navigation/choose_user_view.dart';
import 'package:prosto_doc/features/home/views/navigation/clients_view.dart';
import 'package:prosto_doc/features/home/views/navigation/edit_profile_view.dart';

import '../../../../core/helpers/custom_page_route.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<CategoryModel> searchedCategories = [];
  bool searching = false;
  bool isUser = true;

  bool logo = true;
  bool familyName = true;
  bool onError = false;
  String email = '';
  String inn = '';
  String address = '';

  @override
  void initState() {
    _getUserProfile();
    super.initState();
  }

  _getUserProfile() async {
    if (context.read<AuthCubit>().user?.activeRole != 'is_client') {
      setState(() {
        isUser = false;
      });
    }
    if (context.read<AuthCubit>().user?.logoInDocument != null) {
      logo = context.read<AuthCubit>().user!.logoInDocument!;
    }
    if (context.read<AuthCubit>().user?.surnameDeclines != null) {
      familyName = context.read<AuthCubit>().user!.surnameDeclines!;
    }
    setState(() {});
  }

  sendEmailCode(String currentEmail, BuildContext mainDialogContext) async {
    EmailCode? emailCode =
        await context.read<AuthCubit>().sendEmailCode(currentEmail);

    if (emailCode != null) {
      if (emailCode.send) {
        // ignore: use_build_context_synchronously
        await confirmDialog(
          context: context,
          title: 'Введите код,\nкоторый мы отправили\nна ваш email',
          confirmBtnText: 'Готово',
          buttonTitle: 'Готово',
          hint: 'Введите код',
          isCode: true,
          onConfirm: (value, {dialogContext}) {
            checkEmailCode(value, currentEmail, dialogContext ?? context);
          },
        );
      }
    }
  }

  checkEmailCode(
      String code, String currentEmail, BuildContext mainDialogContext) async {
    VerifedEmailCode? verifedEmailCode =
        await context.read<AuthCubit>().checkEmailCode(code, currentEmail);

    if (verifedEmailCode != null) {
      if (verifedEmailCode.verifed) {
        setState(() {
          context.read<AuthCubit>().setEmail(currentEmail);
        });
        Navigator.pop(mainDialogContext);
      } else {
        setState(() {
          onError = true;
        });
        showAlertToast('Неверный код');
      }
    } else {
      print(123);
      showAlertToast('Неверный код');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthMainState>(builder: (context, snapshot) {
      AuthCubit authCubit = context.read<AuthCubit>();
      return Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 397.w,
                child: Stack(
                  children: [
                    Positioned(
                      top: -10,
                      left: -10,
                      right: -10,
                      child: SvgPicture.asset(
                        'assets/icons/background_beranda.svg',
                        // height: 397.52.h,
                        fit: BoxFit.fitHeight,
                        color: const Color.fromRGBO(78, 130, 234, 1),
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Image.asset(
                      'assets/images/background_berand.png',
                      height: 397.52.h,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, createRoute(EditProfileView()));
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(top: 102.h, right: 104.5.w),
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            height: 26.w,
                            width: 26.w,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, createRoute(EditProfileView()));
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 112.h),
                          if (authCubit.user?.avatarPath != null)
                            if (authCubit.user!.avatarPath!
                                .contains('data:image/jpg;base64'))
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 135.w,
                                  height: 135.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greyColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Image.memory(
                                      base64Decode(authCubit.user!.avatarPath!
                                          .replaceAll(
                                              'data:image/jpg;base64,', '')),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 135.w,
                                  height: 135.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greyColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Image.network(
                                      docUrl + authCubit.user!.avatarPath!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                          else
                            Center(
                              child: Container(
                                width: 135.w,
                                height: 135.w,
                                // margin: EdgeInsets.symmetric(horizontal: 132.w),
                                child: SvgPicture.asset(
                                  'assets/icons/person.svg',
                                  width: 135.w,
                                  height: 135.h,
                                ),
                              ),
                            ),
                          SizedBox(height: 10.h),
                          Text(
                            ' ${authCubit.user?.name ?? ''} ${authCubit.user?.surname ?? ''} ${authCubit.user?.patronymic ?? ''}',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.h,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            authCubit.user?.phoneNumber ?? 'Телефон не указано',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.h,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // SizedBox(height: 61.h),
              // CustomButton(onTap: () {}, title: 'Чат с поддержкой'),
              // if (!isUser) SizedBox(height: 20.h),
              if (!isUser)
                CustomButton(
                  onTap: () async {
                    if (authCubit.user?.inn == null) {
                      await confirmDialog(
                        context: context,
                        title:
                            'Секунду!\nЗаполните ИНН\nчтобы создать этот\nдокумент',
                        confirmBtnText: 'Добавить',
                        hint: 'Введите ваш ИНН',
                        buttonTitle: 'Добавить',
                        onConfirm: (value, {dialogContext}) {
                          setState(() {
                            authCubit.setInn(value);
                            authCubit.updateUser();
                            inn = value;
                          });
                        },
                      );
                    }
                    if (authCubit.user?.addressRegistration == null) {
                      // ignore: use_build_context_synchronously
                      await confirmDialog(
                        context: context,
                        title:
                            'Секунду!\nЗаполните адрес\nчтобы создать этот\nдокумент',
                        confirmBtnText: 'Добавить',
                        hint: 'Введите ваш адрес',
                        buttonTitle: 'Добавить',
                        onConfirm: (value, {dialogContext}) {
                          setState(() {
                            authCubit.setAddress(value);
                            authCubit.updateUser();
                            address = value;
                          });
                          Navigator.push(
                              context, createRoute(AddDocumentView()));
                        },
                      );
                    } else {
                      Navigator.push(context, createRoute(AddDocumentView()));
                    }
                  },
                  title: 'Добавить документ',
                ),
              if (!isUser) SizedBox(height: 20.h),
              if (!isUser)
                CustomButton(
                  onTap: () {
                    Navigator.push(context, createRoute(ClientsView()));
                  },
                  title: 'Мои клиенты',
                ),
              if (!isUser) SizedBox(height: 40.h),
              if (!isUser)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Добавлять логотип в\nсформированные\nдокументы?',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.h,
                          color: AppColors.greyColor,
                        ),
                      ),
                      Switch.adaptive(
                        value: logo,
                        onChanged: (value, {dialogContext}) {
                          setState(() {
                            logo = value;
                            authCubit.setLogoInDocument(value);
                            authCubit.updateUser();
                          });
                        },
                        activeColor: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 50.h),
              Container(
                height: 35.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ваша фамилия склоняется?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.h,
                        color: AppColors.greyColor,
                      ),
                    ),
                    Switch.adaptive(
                      value: familyName,
                      onChanged: (value, {dialogContext}) {
                        setState(() {
                          authCubit.setSurnameDeclines(value);
                          authCubit.updateUser();
                          familyName = value;
                        });
                      },
                      activeColor: AppColors.textColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              if (authCubit.user?.email != null ||
                  authCubit.user?.inn != null ||
                  authCubit.user?.addressRegistration != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: double.infinity),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Ваши данные',
                        style: GoogleFonts.poppins(
                          fontSize: 18.h,
                          fontWeight: FontWeight.w700,
                          color: AppColors.buttonBlueColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 31.h),
                    if (authCubit.user?.email != null)
                      if (authCubit.user!.email!.isNotEmpty)
                        infoWidget('Ваш email: ', authCubit.user!.email!),
                    if (authCubit.user?.email != null)
                      if (authCubit.user!.email!.isNotEmpty)
                        SizedBox(height: 25.h),
                    if (authCubit.user?.inn != null)
                      if (authCubit.user!.inn!.isNotEmpty)
                        infoWidget('Ваш ИНН: ', authCubit.user!.inn!),
                    if (authCubit.user?.inn != null)
                      if (authCubit.user!.inn!.isNotEmpty)
                        SizedBox(height: 25.h),
                    if (authCubit.user?.addressRegistration != null)
                      if (authCubit.user!.addressRegistration!.isNotEmpty)
                        infoWidget('Ваш адрес: ',
                            authCubit.user!.addressRegistration!),
                    if (authCubit.user?.addressRegistration != null)
                      if (authCubit.user!.addressRegistration!.isNotEmpty)
                        SizedBox(height: 25.h),
                  ],
                ),
              if (authCubit.user?.email == null)
                CustomButton(
                  onTap: () async {
                    BuildContext mainDialogContext = context;
                    String emailValue = '';
                    await confirmDialog(
                      context: mainDialogContext,
                      title: 'Добавьте email',
                      confirmBtnText: 'Далее',
                      buttonTitle: 'Далее',
                      hint: 'prostodoc@doc.ru',
                      onConfirm: (value, {dialogContext}) {
                        emailValue = value;
                        if (emailValue != '' &&
                            emailValue.contains('@') &&
                            emailValue.contains('.')) {
                          Navigator.pop(dialogContext ?? context);
                          // ignore: use_build_context_synchronously
                          sendEmailCode(value, mainDialogContext);
                        } else {
                          showAlertToast('E-Mail указан неверно');
                        }
                      },
                    );
                  },
                  title: 'Добавить email',
                  accent: false,
                ),
              if (authCubit.user?.inn == null) SizedBox(height: 25.h),
              if (authCubit.user?.inn == null)
                CustomButton(
                  onTap: () {
                    confirmDialog(
                      context: context,
                      title: 'Добавьте ИНН',
                      confirmBtnText: 'Далее',
                      hint: 'NNNNXXXXXXCC',
                      isCode: true,
                      buttonTitle: 'Далее',
                      isInn: true,
                      onConfirm: (value, {dialogContext}) {
                        setState(() {
                          authCubit.setInn(value);
                          authCubit.updateUser();
                          inn = value;
                        });
                        Navigator.pop(dialogContext!);
                      },
                    );
                  },
                  title: 'Добавить ИНН',
                  accent: false,
                ),
              if (authCubit.user?.addressRegistration == null)
                SizedBox(height: 25.h),
              if (authCubit.user?.addressRegistration == null)
                CustomButton(
                  onTap: () {
                    confirmDialog(
                      context: context,
                      title: 'Добавьте адрес',
                      confirmBtnText: 'Далее',
                      buttonTitle: 'Далее',
                      hint: 'г. Москва, ул Пушкина дом 9',
                      onConfirm: (value, {dialogContext}) {
                        authCubit.setAddress(value);
                        authCubit.updateUser();
                        setState(() {
                          address = value;
                        });
                        Navigator.pop(dialogContext!);
                      },
                    );
                  },
                  title: 'Добавить адрес',
                  accent: false,
                ),
              SizedBox(height: 66.h),
              GestureDetector(
                onTap: () {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const AuthView(),
                  //   ),
                  //   (_) => false,
                  // );
                  context.read<AuthCubit>().logout();
                },
                child: Container(
                  height: 23.h,
                  color: Colors.transparent,
                  // margin: EdgeInsets.symmetric(horizontal: 103.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/logout.svg',
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'Выйти из аккаунта',
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
              SizedBox(height: 45.h),
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
              SizedBox(height: 157.h),
            ],
          ),
        ),
      );
    });
  }

  Column infoWidget(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.h,
              fontWeight: FontWeight.w700,
              color: AppColors.buttonBlueColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.h,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(31, 31, 31, 1),
            ),
          ),
        ),
      ],
    );
  }
}
