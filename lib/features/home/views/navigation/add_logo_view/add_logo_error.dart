import 'package:flutter/material.dart';
import 'package:prosto_doc/core/helpers/basic_text.dart';
import 'package:prosto_doc/core/helpers/big_title.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';

class AddLogoError extends StatelessWidget {
  final String? error;
  const AddLogoError({this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 47),
            BigTitle(text: 'Ваш логотип\nне добавлен!'),
            SizedBox(height: 25),
            BasicText(
                text:
                    'Пожалуйста соблюдайте правила\nзагрузки и попробуйте снова'),
            SizedBox(height: 25),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child:
            BasicText(
              text: 'Причина: $error',
              color: AppColors.errorColor,
            ),
            // ),
            SizedBox(height: 49),
            CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Ок'),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
