import 'package:control_style/control_style.dart';
import 'package:flutter/material.dart';
import 'package:prosto_doc/core/helpers/colors.dart';

class TextFieldTheme {
  static final defaulBorder = makeBorder(Colors.transparent);
  static final focusBorder = makeBorder(AppColors.buttonBlueColor);
  static final errorBorder = makeBorder(AppColors.errorColor);

  static DecoratedInputBorder makeBorder(Color color) => DecoratedInputBorder(
        shadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 0),
            blurRadius: 2,
          ),
        ],
        child: OutlineInputBorder(
          borderRadius: BorderRadius.all(const Radius.circular(60)),
          borderSide: BorderSide(color: color, width: 2.0),
        ),
      );
}
