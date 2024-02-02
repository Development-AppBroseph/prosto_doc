import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prosto_doc/core/helpers/big_title.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/features/home/bloc/logo_view_cubit.dart';

class AddLogoSuccess extends StatelessWidget {
  const AddLogoSuccess({required this.base64, super.key});

  final String base64;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 47),
          BigTitle(text: 'Ваш логотип\nдобавлен!'),
          SizedBox(height: 35),
          Container(
            height: 125,
            width: 125,
            child: Image.memory(
              base64Decode(
                base64.replaceAll('data:image/jpg;base64,', ''),
              ),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 56),
          CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'Отлично!'),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
