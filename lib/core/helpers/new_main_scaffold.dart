import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/features/home/views/bottom_view.dart';

class NewMainScaffold extends StatelessWidget {
  const NewMainScaffold({
    required this.body,
    this.backgroundColor,
    super.key,
  });

  final Widget body;
  final Color? backgroundColor;

  static const bottomPadding = 50.0;
  static const _topPadding = 143.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/background_beranda.svg',
                  fit: BoxFit.fitWidth,
                  color: backgroundColor ??
                      AppColors
                          .dinoBlue, // const Color.fromRGBO(78, 130, 234, 1),
                  width: MediaQuery.of(context).size.width,
                ),
                Image.asset(
                  'assets/images/new_transparent_graphics.png',
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  margin: const EdgeInsets.only(top: _topPadding - 71),
                  width: double.infinity,
                  height: 88,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/Group_14284.png',
                    height: 88,
                    width: 109,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 22,
                    right: 22,
                    top: _topPadding,
                    // bottom: BottomView.height,
                  ),
                  width: double.infinity,
                  // height: cardHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(48, 48, 48, 0.05),
                        offset: Offset(0, 8),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  child: body,
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: _topPadding - 24, right: 24),
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/dino_blue.png',
                    height: 40,
                    width: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: BottomView.height + 22)
        ],
      ),
    );
  }
}
