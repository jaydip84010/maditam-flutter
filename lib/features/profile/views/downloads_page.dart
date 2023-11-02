import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class MyDownLoadsScreen extends ConsumerWidget {
  const MyDownLoadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenWrapper(
        child: Column(
      children: [
        const RegularAppBar(
          title: "My Downloads",
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const SizedBox();

                // const SongTile();
              },
            ),
          ),
        ),
      ],
    ));
  }
}
