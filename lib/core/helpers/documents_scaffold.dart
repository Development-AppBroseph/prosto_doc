import 'package:flutter/material.dart';
import 'package:prosto_doc/core/helpers/big_title.dart';
import 'package:prosto_doc/features/home/views/bottom_view.dart';

class DocumentsScaffold extends StatelessWidget {
  const DocumentsScaffold({
    required this.body,
    super.key,
  });

  final Widget body;

  // static const bottomPadding = 50.0;
  // static const _topPadding = 143.0;
  static const _cardHeight = 84.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Flexible(
          //   child:
          Stack(
            children: [
              IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/documents_bg.png',
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(height: 45),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: _cardHeight - 16,
                            ),
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
                            margin: const EdgeInsets.symmetric(horizontal: 22),
                            width: double.infinity,
                            height: _cardHeight,
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
                            child: const Center(
                              child: BigTitle(text: 'Мои документы'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: _cardHeight - 14,
                              right: 24,
                            ),
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
                  ],
                ),
              ),
            ],
          ),
          // ),
          Flexible(
            child: body,
          ),
          const SizedBox(height: BottomView.height),
        ],
      ),
    );
  }
}
