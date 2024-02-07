import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/features/home/bloc/main_cubit.dart';
import 'package:prosto_doc/features/home/views/navigation/documents_view.dart';
import 'package:prosto_doc/features/home/views/navigation/main_categories_view.dart';
import 'package:prosto_doc/features/home/views/navigation/profile_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NavbarItem> items = [
    NavbarItem(Icons.home, 'Home', backgroundColor: colors[0]),
    NavbarItem(Icons.shopping_bag, 'Products', backgroundColor: colors[1]),
    NavbarItem(Icons.person, 'Me', backgroundColor: colors[2]),
  ];

  int currentIndex = 0;

  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': const MainCategoriesView(),

      // 'main_categories': AuthView(),
    },
    1: {
      '/': const DocumentsView(),
      // 'second': AuthView(),
    },
    2: {
      '/': ProfileView(),
      // 'second': AuthView(),
    },
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NavbarRouter(
          errorBuilder: (context) {
            return const Center(child: Text('Error 404'));
          },
          // onBackButtonPressed: (isExiting) {
          //   return isExiting;
          // },
          type: NavbarType.floating,
          onChanged: (p0) {
            if (p0 == 1) {
              context.read<MainCubit>().getMyDocuments();
            }
            setState(() {
              currentIndex = p0;
            });
          },
          onCurrentTabClicked: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          decoration: NavbarDecoration(
            height: 85.h,
            margin: EdgeInsets.zero,
            elevation: 0,
            navbarType: BottomNavigationBarType.fixed,
            selectedIconColor: AppColors.textColor,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelTextStyle: GoogleFonts.poppins(
              fontSize: 12.h,
              color: AppColors.textColor,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelTextStyle: GoogleFonts.poppins(
              fontSize: 12.h,
              color: AppColors.greyColor,
              fontWeight: FontWeight.w400,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            indicatorColor: AppColors.textColor,
          ),
          destinationAnimationCurve: Curves.easeInOutQuint,
          destinationAnimationDuration: 0,
          // decoration:
          //     NavbarDecoration(navbarType: BottomNavigationBarType.shifting),
          destinations: [
            for (int i = 0; i < items.length; i++)
              DestinationRouter(
                navbarItem: items[i],
                destinations: [
                  for (int j = 0; j < _routes[i]!.keys.length; j++)
                    Destination(
                      route: _routes[i]!.keys.elementAt(j),
                      widget: _routes[i]!.values.elementAt(j),
                    ),
                ],
                initialRoute: _routes[i]!.keys.first,
              ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: IgnorePointer(
            child: Container(
              height: 86.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.r,
                    color: const Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
              ),
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: currentIndex == 1
                        ? Alignment.topCenter
                        : currentIndex == 2
                            ? Alignment.topRight
                            : Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 65.w),
                      width: 30.w,
                      height: 4.h,
                      color: AppColors.textColor,
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 43.w),
                        SizedBox(
                          height: 47.h,
                          width: 77.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Home.svg',
                                height: 20.h,
                                width: 26.w,
                                color: currentIndex == 0
                                    ? AppColors.textColor
                                    : AppColors.greyColor,
                              ),
                              SizedBox(height: 4.h),
                              Material(
                                color: Colors.white,
                                child: Text(
                                  'Категории',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.h,
                                    color: currentIndex == 0
                                        ? AppColors.textColor
                                        : AppColors.greyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          height: 47.h,
                          width: 77.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Discovery.svg',
                                height: 20.h,
                                width: 26.w,
                                color: currentIndex == 1
                                    ? AppColors.textColor
                                    : AppColors.greyColor,
                              ),
                              SizedBox(height: 4.h),
                              Material(
                                color: Colors.white,
                                child: Text(
                                  'Документы',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.h,
                                    color: currentIndex == 1
                                        ? AppColors.textColor
                                        : AppColors.greyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          height: 47.h,
                          width: 77.w,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Profile.svg',
                                height: 20.h,
                                width: 26.w,
                                color: currentIndex == 2
                                    ? AppColors.textColor
                                    : AppColors.greyColor,
                              ),
                              SizedBox(height: 4.h),
                              Material(
                                color: Colors.white,
                                child: Text(
                                  'Профиль',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.h,
                                    color: currentIndex == 2
                                        ? AppColors.textColor
                                        : AppColors.greyColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 41.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
