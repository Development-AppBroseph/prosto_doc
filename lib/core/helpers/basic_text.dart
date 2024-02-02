import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';

class BasicText extends StatelessWidget {
  final String text;
  final Color? color;

  const BasicText({required this.text, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.blackColor,
      ),
    );
  }
}
