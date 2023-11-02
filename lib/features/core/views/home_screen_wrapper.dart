import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/views/bottom_player.dart';
import 'package:medyo/features/core/views/home_page.dart';
import 'package:medyo/features/core/views/menu_page.dart';
import 'package:medyo/features/profile/views/profile_tab.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/widgets/home_app_bar.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class HomeScreenWrapper extends ConsumerStatefulWidget {
  const HomeScreenWrapper({Key? key, this.padding}) : super(key: key);

  final EdgeInsets? padding;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends ConsumerState<HomeScreenWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(50.milisec).then((value) {
      ref.watch(userProvider);
    });
  }

  int selcetedIndex = 0;
  bool isappbar = true;
  @override
  Widget build(BuildContext context) {
    AppGLF.changeStatusBarColor(color: Colors.transparent);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        height: 94.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.darkTeal.withOpacity(0.75),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomePageBottomBarItem(
              onTap: () {
                setState(() {
                  selcetedIndex = 0;
                  isappbar = true;
                });
              },
              isSelected: selcetedIndex == 0,
              svgPath: "assets/svgs/app_icon.svg",
            ),
            HomePageBottomBarItem(
              onTap: () {
                setState(() {
                  selcetedIndex = 1;
                  isappbar = true;
                });
              },
              isSelected: selcetedIndex == 1,
              svgPath: "assets/svgs/menu_icon.svg",
            ),
            HomePageBottomBarItem(
              onTap: () {
                setState(() {
                  selcetedIndex = 2;
                  isappbar = true;
                });
              },
              isSelected: selcetedIndex == 2,
              svgPath: "assets/svgs/icon_user.svg",
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: widget.padding ?? EdgeInsets.zero,
            height: 844.h,
            width: 390.w,
            color: AppColors.darkTeal,
            child: Column(
              children: [
                isappbar == false
                    ? HomeAppBar(
                        onProfiletap: () {
                          setState(() {
                            selcetedIndex = 2;
                          });
                        },
                      )
                    : selcetedIndex == 1
                        ? AppSpacerH(40.h)
                        : const SizedBox(),
                Expanded(
                  child: IndexedStack(
                    index: selcetedIndex,
                    children: const [MenuPage(), HomeTab(), ProfileTab()],
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
              duration: 500.milisec,
              bottom: 96.h - ref.watch(bottomPlayerOffset('y')),
              left: 0 + ref.watch(bottomPlayerOffset('x')),
              child: const BottomPlayerControl())
        ],
      ),
    );
  }
}

class HomePageBottomBarItem extends StatelessWidget {
  const HomePageBottomBarItem(
      {Key? key, this.onTap, this.isSelected = false, required this.svgPath})
      : super(key: key);
  final Function()? onTap;
  final bool isSelected;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.25 : 1,
        duration: 200.milisec,
        child: SvgPicture.asset(
          svgPath,
          color: isSelected ? AppColors.white : AppColors.gray,
          fit: BoxFit.cover,
          height: 24.h,
        ),
      ),
    );
  }
}
