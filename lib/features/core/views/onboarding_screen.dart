import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final Box appSettingsBox = Hive.box(
    AppHSC.appSettingsBox,
  );
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacerH(193.h),
              Center(
                child: Hero(
                  tag: "LOGO",
                  child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 125.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                "onboarding_screen.welcome".tr(),
                style: AppTextDecor.bold36White,
              ),
              AppSpacerH(12.h),
              Text(
                "onboarding_screen.text".tr(),
                style: AppTextDecor.regular18White,
              ),
              AppSpacerH(74.h),
              AppTextButton(
                title: "onboarding_screen.btn_text".tr(),
                onTap: () {
                  debugPrint('Got Hit');
                  // context.nav.pushNamedAndRemoveUntil(
                  //   (authBox.get(AppHSC.authToken) != null &&
                  //           authBox.get(AppHSC.authToken) != '')
                  //       ? Routes.homeScreen
                  //       : Routes.loginScreen,
                  //   (route) => false,
                  // );
                  appSettingsBox.put(AppHSC.hasSeenOnBoardingScreen, true);
                  context.nav.pushNamedAndRemoveUntil(
                    Routes.homeScreen,
                    (route) => false,
                  );
                },
              ),
              AppSpacerH(66.h),
            ],
          ),
        )
      ],
    ));
  }
}
