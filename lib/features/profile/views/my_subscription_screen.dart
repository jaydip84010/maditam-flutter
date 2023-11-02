import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/my_subscription_model/my_subscription_model.dart';
import 'package:medyo/features/core/views/premium_sub_screen.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class MySubScreen extends ConsumerStatefulWidget {
  const MySubScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MySubScreenState();
}

class _MySubScreenState extends ConsumerState<MySubScreen> {
  MySubscriptionModel? mySub;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Column(
      children: [
        const RegularAppBar(
          title: "My Subscription",
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ref.watch(mySubProvider).map(
                  loaded: (value) {
                    if (value.data.data?.subscriptions != null &&
                        value.data.data!.subscriptions!.isNotEmpty) {
                      final lastSub = value.data.data!.subscriptions!.first;
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          AppSpacerH(24.h),
                          Container(
                            padding: EdgeInsets.all(18.r),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.premiumBG,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.25),
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/app_sub_check.svg',
                                      height: 20.h,
                                      width: 20.h,
                                    ),
                                    AppSpacerW(10.w),
                                    Expanded(
                                        child: Text(
                                      'Subscription : ${lastSub.subscriptionPlan?.name ?? ''}',
                                      style: AppTextDecor.regular16White,
                                    ))
                                  ],
                                ),
                                AppSpacerH(9.h),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      lastSub.subscriptionPlan?.duration ?? '',
                                      style: AppTextDecor.bold18White,
                                    )),
                                    Text(
                                      '\$${lastSub.subscriptionPlan?.amount ?? 0}',
                                      style: AppTextDecor.regular14White,
                                    )
                                  ],
                                ),
                                AppSpacerH(9.h),
                                const HorizontalDivider(
                                  color: AppColors.darkTeal,
                                ),
                                AppSpacerH(9.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Valid till: ${lastSub.expiredAt ?? ''}',
                                      style: AppTextDecor.regular12White,
                                    ),
                                    // CustomSeprator(
                                    //   height: 10.h,
                                    //   width: 2.w,
                                    //   color: AppColors.white.withOpacity(0.5),
                                    // ),
                                    // Text(
                                    //   'Cancel Subscription',
                                    //   style: AppTextDecor.regular12White,
                                    //   textAlign: TextAlign.right,
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          AppSpacerH(32.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.r)),
                              border: Border.all(
                                color: AppColors.gray.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Benifits',
                                    style: AppTextDecor.bold16White),
                                AppSpacerH(16.h),
                                ...lastSub.subscriptionPlan!.features!
                                    .map((e) => PremiumCardTile(
                                          title: e,
                                        ))
                                    .toList(),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'You are Not Subscribed',
                          style: AppTextDecor.bold18White,
                        ),
                      );
                    }
                  },
                  error: (_) => ErrorTextWidget(error: _.error),
                  initial: (_) => const LoadingWidget(),
                  loading: (_) => const LoadingWidget(),
                ),
          ),
        ),
      ],
    ));
  }
}
