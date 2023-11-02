import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class RegularAppBar extends StatelessWidget {
  const RegularAppBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.darkGreen, width: 1)),
      ),
      child: Column(
        children: [
          AppSpacerH(44.h),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.nav.pop();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  color: Colors.transparent,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 18.h,
                    color: AppColors.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: AppTextDecor.bold18White,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacerH(16.h),
        ],
      ),
    );
  }
}
