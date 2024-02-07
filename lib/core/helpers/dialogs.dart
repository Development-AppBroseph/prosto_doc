import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/custom_text_field.dart';

Future<void> confirmDialog({
  required BuildContext context,
  required String title,
  required String confirmBtnText,
  required String hint,
  required String buttonTitle,
  bool isCode = false,
  bool isInn = false,
  required dynamic Function(String, {BuildContext? dialogContext}) onConfirm,
  Widget Function(TextEditingController)? customTextField,
}) async {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.blackColor.withOpacity(0.5),
    // barrierDismissible: false,
    builder: (BuildContext context) {
      TextEditingController textEditingController = TextEditingController();
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 47.h,
            left: 16.w,
            right: 16.w,
            bottom: 47.h,
          ),
          // height: 348.h,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.buttonBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 53.h),
              customTextField?.call(textEditingController) ??
                  CustomTextField(
                    hint: hint,
                    isPhone: false,
                    isCode: isCode,
                    isInn: isInn,
                    textEditingController: textEditingController,
                  ),
              // CustomButton(title: confirmBtnText, onTap: onConfirm),
              SizedBox(height: 58.h),
              CustomButton(
                title: buttonTitle,
                onTap: () {
                  if (isCode && textEditingController.text.length == 4) {
                    onConfirm(textEditingController.text,
                        dialogContext: context);
                    // Navigator.pop(context);
                  } else {
                    onConfirm(textEditingController.text,
                        dialogContext: context);
                  }
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<void> deleteDialog({
  required BuildContext context,
  required String title,
  required dynamic Function() onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.blackColor.withOpacity(0.5),
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 47.h,
            left: 16.w,
            right: 16.w,
            bottom: 47.h,
          ),
          // height: 380.h,
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.buttonBlueColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 57.h),
              CustomButton(
                onTap: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                title: 'Да',
                color: const Color.fromRGBO(185, 74, 74, 1),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                onTap: () {
                  // onConfirm();
                  Navigator.pop(context);
                },
                title: 'Нет',
              ),
            ],
          ),
        ),
      );
    },
  );
}

void iconSelectModal(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: AppColors.blackColor.withOpacity(0.1),
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.only(top: offset.dy + 20.h, left: 35.w),
            alignment: Alignment.topLeft,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onTap(1);
              },
              child: Container(
                width: 249.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        height: 40.h,
                        alignment: Alignment.center,
                        child: Text(
                          'Удалить документ',
                          style: GoogleFonts.poppins(
                            color: const Color.fromRGBO(31, 31, 31, 1),
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
