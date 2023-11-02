import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';

class AppSpacerH extends StatelessWidget {
  const AppSpacerH(
    this.height, {
    Key? key,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class AppSpacerW extends StatelessWidget {
  const AppSpacerW(
    this.width, {
    Key? key,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class AppDividerV extends StatelessWidget {
  const AppDividerV({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 3.0,
      child: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
          width: width != null ? width! / 2 : 1.0,
          height: height ?? 10.h,
          color: AppColors.gray,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomSeprator extends StatelessWidget {
  CustomSeprator({Key? key, this.color, this.height, this.width})
      : super(key: key);
  Color? color;
  double? height;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1.h,
      width: width ?? double.infinity,
      color: color ?? AppColors.offWhite,
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.toString().tr(),
        style: AppTextDecor.medium14Red,
      ),
    );
  }
}

class MessageTextWidget extends StatelessWidget {
  const MessageTextWidget({Key? key, required this.msg}) : super(key: key);
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg.toString().tr(),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.showBG = false}) : super(key: key);
  final bool showBG;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.darkGreen,
      ),
    );
  }
}

// class LoadingWidget extends StatelessWidget {
//   const LoadingWidget({Key? key, this.showBG = false}) : super(key: key);
//   final bool showBG;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: BusyLoader(showbackground: showBG),
//     );
//   }
// }

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      width: double.infinity,
      color: color ?? AppColors.white.withOpacity(0.2),
    );
  }
}
