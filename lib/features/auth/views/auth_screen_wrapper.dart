import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class AuthScreenWrapper extends StatelessWidget {
  const AuthScreenWrapper({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        showBottomPlayer: false,
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: Image.asset("assets/images/auth_overlay.png")),
            SizedBox(
              height: 844.h,
              width: 390.w,
              child: child,
            )
          ],
        ));
  }
}
