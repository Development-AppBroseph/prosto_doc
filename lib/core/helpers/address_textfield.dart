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
  String? Function(String?)? validator,
}) {
  return AddressTextField(controller, hint, validator);
}

class AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const AddressTextField(this.controller, this.hint, this.validator,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final basicColor = GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      fontSize: 14.h,
      color: AppColors.blackColor,
    );
    // return AutoCompleteTextField<String>();
    return Container(
      // height: 45,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 0),
            blurRadius: 2,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(60.r),
      ),
      child: EasyAutocomplete(
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
          focusedErrorBorder: InputBorder.none,
          //  const UnderlineInputBorder(
          //   // borderRadius: BorderRadius.all(Radius.circular(60)),
          //   borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          // ),
          errorBorder: const UnderlineInputBorder(
            // borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            borderSide:
                BorderSide(color: AppColors.buttonBlueColor, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color.fromRGBO(151, 151, 151, 1),
          ),
          contentPadding:
              const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        ),
        onChanged: (value) => print('onChanged value: $value'),
        onSubmitted: (value) => print('onSubmitted value: $value'),
      ),
    );
  }
}
