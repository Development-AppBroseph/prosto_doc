import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/textfield_theme.dart';
import 'package:prosto_doc/features/home/datasources/dadata.dart';
// import 'package:'

Widget addressTextField({
  required TextEditingController controller,
  required String hint,
  String? Function(String?)? validator,
}) {
  return AddressTextField(
    controller,
    hint,
    validator: validator,
  );
}

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const AddressTextField(
    this.controller,
    this.hint, {
    super.key,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final basicColor = GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      fontSize: 14.h,
      color: AppColors.blackColor,
    );
    // return AutoCompleteTextField<String>();
    return EasyAutocomplete(
      asyncSuggestions: dadataSource.getSuggestions,
      progressIndicatorBuilder:
          const SizedBox(), //const CircularProgressIndicator.adaptive(), // Это загораживает кнопку подтверждения диалога
      controller: controller,
      inputTextStyle: basicColor,
      suggestionTextStyle: basicColor,
      cursorColor: AppColors.textColor,
      validator: validator,
      decoration: InputDecoration(
        isCollapsed: false,
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        focusedErrorBorder: TextFieldTheme.errorBorder,
        errorBorder: TextFieldTheme.errorBorder,
        focusedBorder: TextFieldTheme.focusBorder,
        enabledBorder: TextFieldTheme.defaulBorder,
        border: TextFieldTheme.defaulBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(151, 151, 151, 1),
        ),
        // contentPadding:
        //     const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      ),
      onChanged: (value) => print('onChanged value: $value'),
      onSubmitted: (value) => print('onSubmitted value: $value'),
    );
  }
}
