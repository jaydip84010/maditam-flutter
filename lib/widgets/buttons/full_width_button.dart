import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    Key? key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
  }) : super(key: key);
  final double? width;
  final double? height;
  final Color? buttonColor;
  final String title;
  final Color? titleColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 60.h,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.darkGreen,
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextDecor.medium18White
                .copyWith(color: titleColor ?? AppColors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
