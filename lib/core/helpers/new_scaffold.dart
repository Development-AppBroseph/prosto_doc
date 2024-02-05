import 'package:flutter/material.dart';

class NewScaffold extends StatelessWidget {
  NewScaffold({
    required this.body,
    required this.cardBody,
    required this.cardHeight,
    // required this.emptyPadding,
    super.key,
  });

  final Widget body;
  final Widget cardBody;
  // final double emptyPadding;
  final double cardHeight;

  final keyImage = GlobalKey();

  static const bottomPadding = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            Container(
              // color: Colors.amber,
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/background_beranda_2.png',
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(height: cardHeight - 125),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: cardHeight - 32),
                            child: Image.asset(
                              'assets/images/Group_14284.png',
                              height: 157,
                              width: 196,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 22),
                            width: double.infinity,
                            height: cardHeight,
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
                            child: cardBody,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: cardHeight - 32),
                            child: Stack(
                              children: [
                                const SizedBox(
                                  height: 157,
                                  width: 196,
                                ),
                                Positioned(
                                  top: 80,
                                  left: 68,
                                  child: Image.asset(
                                    'assets/images/dino_blue.png',
                                    height: 71,
                                    width: 21,
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
              ),
            ),
            Flexible(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
