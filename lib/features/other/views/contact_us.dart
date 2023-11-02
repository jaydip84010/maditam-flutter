import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/config.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends ConsumerWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            height: 844.h,
            width: 390.w,
            color: AppColors.darkTeal,
            child: Column(
              children: [
                const RegularAppBar(
                  title: 'Contact Us',
                ),
                AppSpacerH(23.h),
                Image.asset(
                  'assets/images/contact_us.png',
                  height: 165.h,
                  width: 262.w,
                ),
                AppSpacerH(60.h),
                const Icon(
                  Icons.location_pin,
                  color: AppColors.white,
                ),
                AppSpacerH(5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    AppConfig.ctAboutCompany,
                    textAlign: TextAlign.center,
                    style: AppTextDecor.regular14White,
                  ),
                ),
                AppSpacerH(37.h),
                GestureDetector(
                  onTap: () async {
                    await FlutterLaunch.launchWhatsapp(
                      phone: AppConfig.ctWhatsApp,
                      message: "",
                    );
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/svgs/icon_whats_app.svg'),
                      AppSpacerH(15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          'Message us on WhatsApp\n${AppConfig.ctWhatsApp}',
                          style: AppTextDecor.regular14White
                              .copyWith(decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacerH(37.h),
                GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                      Uri.parse('mailto:${AppConfig.ctMail}'),
                    )) {
                      EasyLoading.showError("Couldn't Mail");
                    }
                  },
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mail,
                        color: AppColors.white,
                      ),
                      AppSpacerH(15.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          AppConfig.ctMail,
                          style: AppTextDecor.regular14White
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Container(
                width: 350.w,
                decoration: BoxDecoration(
                  color: AppColors.darkTeal,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: AppTextButton(
                  title: 'Close',
                  onTap: () async {
                    context.nav.pop();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
