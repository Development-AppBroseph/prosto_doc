import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
  }) : showIcon = true;

  const CustomBackButton.fake({
    super.key,
  }) : showIcon = false;

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showIcon) {
          Navigator.pop(context);
        }
      },
      child: Container(
        // height: 40,
        // width: 40,
        color: Colors.transparent,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Container(
          height: 20,
          width: 20,
          // color: Colors.amber,
          alignment: Alignment.center,
          child: showIcon
              ? SvgPicture.asset(
                  'assets/icons/arrow.svg',
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
