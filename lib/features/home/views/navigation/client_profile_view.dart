import 'dart:convert';
import 'dart:io';

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
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';
import 'package:prosto_doc/core/helpers/validators.dart';
import 'package:prosto_doc/core/models/client_model.dart';
import 'package:prosto_doc/core/models/user_model.dart';
import 'package:prosto_doc/features/auth/bloc/auth_cubit.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';

class ClientProfileView extends StatefulWidget {
  UserModel? clientModel;
  ClientProfileView({super.key, this.clientModel});

  @override
  State<ClientProfileView> createState() => _ClientProfileViewState();
}

class _ClientProfileViewState extends State<ClientProfileView> {
  XFile? currentImage;

  FocusNode nameFocus = FocusNode();

  FocusNode lastNameFocus = FocusNode();

  FocusNode surnameFocus = FocusNode();

  FocusNode phoneFocus = FocusNode();

  FocusNode addressFocus = FocusNode();

  FocusNode dateFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late DateTime _currentdate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.clientModel != null) {
      setState(() {
        nameController.text = widget.clientModel?.name ?? '';
        lastnameController.text = widget.clientModel?.surname ?? '';
        surnameController.text = widget.clientModel?.patronymic ?? '';
        // phoneController.text = widget.clientModel!;
        phoneController.text = widget.clientModel?.phoneNumber ?? '';
        addressController.text = widget.clientModel?.addressRegistration ?? '';
        if (widget.clientModel?.dateOfBirth != null) {
          _currentdate = widget.clientModel!.dateOfBirth!;
          dateController.text =
              DateFormat('dd.MM.yyyy').format(widget.clientModel!.dateOfBirth!);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                ],
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
                      currentImage = value;
                    });
                  });
                },
                child: Container(
                  height: 200.h,
                  width: 200.w,
                  child: Stack(
                    children: [
                      // AppImages(height: 200.h, width: 200.w)
                      //     .assetImage('assets/images/man.png'),
                      Container(
                        height: 200.h,
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
                      if (currentImage != null)
                        Container(
                          height: 200.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greyColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.file(
                              File(currentImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget.clientModel?.avatarPath != null)
                        Container(
                          height: 200.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.greyColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.network(
                              docUrl + widget.clientModel!.avatarPath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
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
                validator: nonEmpty,
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
                                      DateFormat('dd.MM.yyyy').format(newdate);
                                });
                              },
                              use24hFormat: true,
                              maximumDate: DateTime(2050, 12, 30),
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
                textEditingController: dateController,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: AddressTextField(
                  addressController,
                  'Адрес',
                  // nonEmpty,
                ),
              ),
              SizedBox(height: 58.h),
              CustomButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // if (nameController.text.isEmpty) {
                    //   return;
                    // }
                    String? img64;
                    if (currentImage != null) {
                      final bytes = File(currentImage!.path).readAsBytesSync();

                      img64 = base64Encode(bytes);
                      // await authCubit.setAvatar(img64);
                    }
                    final address = addressController.text;
                    final name = nameController.text;
                    final surname = lastnameController.text;
                    final patronymic = surnameController.text;
                    final phone = phoneController.text;
                    UserModel userModel = UserModel(
                      id: widget.clientModel == null
                          ? 0
                          : widget.clientModel!.id,
                      activeRole: null,
                      addressRegistration: address.isEmpty ? null : address,
                      avatarPath: img64 != null
                          ? 'data:image/jpg;base64,' + img64
                          : widget.clientModel?.avatarPath,
                      dateOfBirth:
                          dateController.text.isNotEmpty ? _currentdate : null,
                      email: null,
                      inn: null,
                      logoInDocument: false,
                      name: name.isEmpty ? null : name,
                      patronymic: patronymic.isEmpty ? null : patronymic,
                      phoneNumber: phone.isEmpty
                          ? null
                          : phone.replaceAll('-', '').replaceAll(' ', ''),
                      surname: surname.isEmpty ? null : surname,
                      surnameDeclines: false,
                    );
                    if (widget.clientModel == null) {
                      await context.read<MainCubit>().addClient(userModel);
                    } else {
                      await context.read<MainCubit>().updateClient(userModel);
                    }
                    Navigator.pop(context);
                  }
                },
                title: 'Сохранить',
              ),
              SizedBox(height: 140.h),
            ],
          ),
        ),
      ),
    );
  }
}
