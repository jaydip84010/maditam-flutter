import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/views/bottom_player.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';

class ScreenWrapper extends ConsumerWidget {
  const ScreenWrapper({
    Key? key,
    this.color = AppColors.darkTeal,
    required this.child,
    this.padding,
    this.showBottomPlayer = true,
  }) : super(key: key);
  final Color color;
  final Widget child;
  final EdgeInsets? padding;
  final bool showBottomPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppGLF.changeStatusBarColor(color: Colors.transparent);
    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: 844.h,
            width: 390.w,
            padding: padding ?? EdgeInsets.zero,
            color: color,
            child: child,
          ),
          if (showBottomPlayer)
            AnimatedPositioned(
                duration: 10.milisec,
                bottom: 2.h - ref.watch(bottomPlayerOffset('y')),
                left: 0 + ref.watch(bottomPlayerOffset('x')),
                child: const BottomPlayerControl())
        ],
      ),
    );
  }
}
