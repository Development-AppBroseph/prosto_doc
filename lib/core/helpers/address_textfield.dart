import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/features/home/datasources/dadata.dart';
// import 'package:'

Widget addressTextField({
  required TextEditingController controller,
  required String hint,
}) {
  return AddressTextField(controller, hint);
}

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const AddressTextField(this.controller, this.hint, {super.key});

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
          SizedBox(), //const CircularProgressIndicator.adaptive(), // Это загораживает кнопку подтверждения диалога
      controller: controller,
      inputTextStyle: basicColor,
      suggestionTextStyle: basicColor,
      cursorColor: AppColors.textColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(color: AppColors.buttonBlueColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(color: AppColors.greyColor, width: 2.0),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: const Color.fromRGBO(151, 151, 151, 1),
        ),
      ),
      onChanged: (value) => print('onChanged value: $value'),
      onSubmitted: (value) => print('onSubmitted value: $value'),
    );
  }
}
