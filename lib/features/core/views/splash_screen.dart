import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(2000.milisec).then((value) {
      final Box appSettingsBox = Hive.box(
        AppHSC.appSettingsBox,
      );
      context.nav.pushNamedAndRemoveUntil(
        appSettingsBox.get(AppHSC.hasSeenOnBoardingScreen) == true
            ? Routes.homeScreen
            : Routes.onBoardingScreen,
        (route) => false,
      );
      // context.nav.pushNamedAndRemoveUntil(
      //   (authBox.get(AppHSC.authToken) != null &&
      //           authBox.get(AppHSC.authToken) != '')
      //       ? Routes.homeScreen
      //       : Routes.onBoardingScreen,
      //   (route) => false,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Stack(
      children: [
        Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/female_yoga_pose.png',
                ),
                fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 844.h,
          width: 390.w,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xff253334),
              Color.fromARGB(0, 37, 51, 52),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          )),
        ),
        Center(
          child: Hero(
            tag: "LOGO",
            child: Image.asset(
              "assets/images/app_logo.png",
              height: 125.h,
              fit: BoxFit.fitHeight,
            ),
          ),
        )
      ],
    ));
  }
}
