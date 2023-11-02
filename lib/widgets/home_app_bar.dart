import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({
    super.key,
    this.onProfiletap,
  });
  final Function()? onProfiletap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.darkGreen, width: 1)),
      ),
      child: Column(
        children: [
          AppSpacerH(44.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                SvgPicture.asset("assets/svgs/app_icon.svg"),
                AppSpacerW(6.w),
                Text(
                  "Maditam",
                  style: AppTextDecor.bold18White,
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: onProfiletap,
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box(AppHSC.userBox).listenable(),
                      builder:
                          (BuildContext context, Box userBox, Widget? child) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(16.h),
                            child: CachedNetworkImage(
                              imageUrl: userBox.get(AppHSC.thumbnail),
                              height: 32.h,
                              width: 32.h,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ));
                      }),
                )
              ],
            ),
          ),
          AppSpacerH(24.h),
        ],
      ),
    );
  }
}
