import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/payment_controller.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class PremiumSubScreen extends ConsumerStatefulWidget {
  const PremiumSubScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PremiumSubScreenState();
}

class _PremiumSubScreenState extends ConsumerState<PremiumSubScreen> {
  bool allowClick = true;

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Column(
      children: [
        const RegularAppBar(
          title: "Become Premium Member",
        ),
        AppSpacerH(20.h),
        Container(
          width: 350.w,
          constraints: BoxConstraints(
            minHeight: 464.h,
            maxHeight: 500.h,
          ),
          child: ref.watch(allPremiumsProvider).map(
              initial: (_) => const LoadingWidget(),
              loading: (_) => const LoadingWidget(),
              loaded: (_) {
                if (_.data.data?.plans?.isNotEmpty == true) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _.data.data!.plans!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = _.data.data!.plans![index];
                      return Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Container(
                          width: 220.w,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: AppColors.slidePanel,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data.name ?? '',
                                style: AppTextDecor.bold20White,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppSpacerH(24.h),
                              ...data.features!
                                  .map((e) => Column(
                                        children: [
                                          PremiumCardTile(
                                            title: e,
                                          ),
                                          AppSpacerH(16.h),
                                        ],
                                      ))
                                  .toList(),
                              const Expanded(child: SizedBox()),
                              const HorizontalDivider(),
                              AppSpacerH(10.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${data.amount.toString()}',
                                    style: AppTextDecor.bold24White,
                                  ),
                                  AppSpacerW(4.w),
                                  Text(
                                    'for ${data.duration}',
                                    style: AppTextDecor.regular12White,
                                  ),
                                ],
                              ),
                              AppSpacerH(10.h),
                              AppTextButton(
                                onTap: () {
                                  if (allowClick) {
                                    allowClick = false;
                                    PaymentController controller =
                                        PaymentController();
                                    controller
                                        .makePayment(
                                            amount: data.amount.toString(),
                                            currency: "USD",
                                            packageID: data.id.toString(),
                                            ref: ref)
                                        .then((value) {
                                      allowClick = true;
                                      if (value) {
                                        // ignore: unused_result
                                        ref.refresh(userProvider);
                                        context.nav.pop();
                                      }
                                    });
                                  }
                                },
                                title: 'Get Premium',
                                height: 39.h,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const MessageTextWidget(msg: "No Plans Found");
                }
              },
              error: (_) => ErrorTextWidget(error: _.error)),
        ),
        const Expanded(child: SizedBox())
      ],
    ));
  }
}

class PremiumReviewTile extends StatelessWidget {
  const PremiumReviewTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.darkTeal,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: CachedNetworkImage(
                    imageUrl: '',
                    height: 48.h,
                    width: 48.h,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/cdlabel.png'),
                  ),
                ),
                AppSpacerW(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mamun Mia',
                        style: AppTextDecor.bold16White,
                      ),
                      Text(
                        '12 Nov, 2022',
                        style: AppTextDecor.bold14White
                            .copyWith(color: AppColors.white.withOpacity(0.5)),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 14,
                    ),
                    const AppSpacerW(5),
                    Text(
                      '5/5',
                      style: AppTextDecor.bold16White,
                    )
                  ],
                )
              ],
            ),
            const AppSpacerH(13.5),
            Text(
              'I had very good experience with them, responsible, friendly and helpful. I recommend',
              style: AppTextDecor.regular14White,
            )
          ],
        ),
      ),
    );
  }
}

class PremiumCardTile extends StatelessWidget {
  const PremiumCardTile({Key? key, this.isGiven = true, required this.title})
      : super(key: key);
  final bool isGiven;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          isGiven
              ? 'assets/svgs/app_premium_tick.svg'
              : 'assets/svgs/app_premium_tick.svg',
          height: 16.h,
          width: 16.h,
        ),
        AppSpacerW(12.w),
        Expanded(child: Text(title, style: AppTextDecor.regular14White))
      ],
    );
  }
}
