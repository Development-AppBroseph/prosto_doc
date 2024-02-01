import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/input_formatters.dart';
import 'package:prosto_doc/core/helpers/textfield_theme.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  bool onError;
  final String hint;
  final bool isPhone;
  bool isCode;
  bool isDate;
  bool isInn;
  bool isName;
  bool enabled;
  // bool expand;
  Function()? onTap;
  FocusNode? focusNode;
  final TextEditingController textEditingController;
  String? Function(String?)? validator;
  double? padding;

  CustomTextField({
    super.key,
    required this.hint,
    required this.isPhone,
    this.isInn = false,
    this.onTap,
    // this.expand = true,
    this.isName = false,
    this.enabled = true,
    this.focusNode,
    this.isDate = false,
    required this.textEditingController,
    this.isCode = false,
    this.onError = false,
    this.validator,
    this.padding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    widget.focusNode?.addListener(
      () {
        setState(() {});
      },
    );
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        // height: widget.expand ? 55.h : 45,
        width: double.infinity,
        // margin: EdgeInsets.symmetric(horizontal: 19.w),
        padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 22),
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       color: widget.onError
        //           ? AppColors.errorColor
        //           : const Color.fromRGBO(0, 0, 0, 0.25),
        //       offset: const Offset(0, 0),
        //       blurRadius: 2.r,
        //     ),
        //   ],
        //   border: widget.focusNode != null
        //       ? widget.focusNode!.hasFocus
        //           ? Border.all(
        //               width: 2.w,
        //               color: AppColors.buttonBlueColor,
        //             )
        //           : !widget.enabled
        //               ? Border.all(
        //                   width: 2.w,
        //                   color: AppColors.buttonBlueColor,
        //                 )
        //               : null
        //       : null,
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(60.r),
        // ),
        // alignment: Alignment.centerLeft,
        child: TextFormField(
          enabled: widget.enabled == false ? false : !widget.isDate,
          controller: widget.textEditingController,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.blackColor,
          ),
          focusNode: widget.focusNode,
          cursorColor:
              widget.onError ? AppColors.errorColor : AppColors.textColor,
          // cursorHeight: 14.h,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: const Color.fromRGBO(151, 151, 151, 1),
            ),
            isCollapsed: false,
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            focusedErrorBorder: TextFieldTheme.errorBorder,
            errorBorder: TextFieldTheme.errorBorder,
            focusedBorder: TextFieldTheme.focusBorder,
            enabledBorder: TextFieldTheme.defaulBorder,
            disabledBorder: TextFieldTheme.defaulBorder,
            border: TextFieldTheme.defaulBorder,
          ),
          keyboardType:
              widget.isCode || widget.isPhone ? TextInputType.phone : null,
          inputFormatters: [
            if (widget.isPhone) CustomInputFormatter(),
            if (widget.isName) NameInputFormatter(),
            if (widget.isCode && !widget.isInn)
              LengthLimitingTextInputFormatter(4),
            if (widget.isInn) LengthLimitingTextInputFormatter(12),
            if (widget.isInn) FilteringTextInputFormatter.digitsOnly,
          ],
          validator: widget.validator,
        ),
      ),
    );
  }
}
