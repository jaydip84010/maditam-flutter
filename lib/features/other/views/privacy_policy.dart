import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/offlinr_data.dart';
import 'package:medyo/features/profile/logic/profile_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class PrivacyPolicy extends ConsumerWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Container(
        height: 844.h,
        width: 390.w,
        color: AppColors.darkTeal,
        child: Stack(
          children: [
            SizedBox(
              child: Column(
                children: [
                  const RegularAppBar(
                    title: 'Privacy Policy',
                  ),
                  ref.watch(privacyAndPolicyProvider).map(
                        initial: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        loading: (_) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        loaded: (_) {
                          return Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0.h),
                                  child: Html(
                                    style: {
                                      '*': Style(
                                        color: AppColors.white,
                                        fontSize: FontSize(14.sp),
                                        fontFamily: 'Open Sans',
                                      )
                                    },
                                    data: _.data.data!.setting!.content,
                                  ),
                                ),
                                AppSpacerH(60.h)
                              ],
                            ),
                          );
                        },
                        error: (_) => Center(
                          child: Text(
                            _.error.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 390.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 15.h,
                ),
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
            )
          ],
        ),
      ),
    );
  }
}
