import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/views/menu_page.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class AllCatagoriesScreen extends ConsumerStatefulWidget {
  const AllCatagoriesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllCatagoriesScreenState();
}

class _AllCatagoriesScreenState extends ConsumerState<AllCatagoriesScreen> {
  List<String> images = [
    "assets/images/home_sgstn_tile_3.png",
    "assets/images/home_sgstn_tile_2.png",
    "assets/images/home_sgstn_tile_1.png",
    "assets/images/home_sgstn_tile_3.png",
    "assets/images/home_sgstn_tile_2.png",
    "assets/images/home_sgstn_tile_1.png",
    "assets/images/home_sgstn_tile_3.png",
    "assets/images/home_sgstn_tile_2.png",
    "assets/images/home_sgstn_tile_1.png",
  ];
  List<String> types = [
    "Empower",
    "Chill-Out",
    "Sleep",
    "Empower",
    "Chill-Out",
    "Sleep",
    "Empower",
    "Chill-Out",
    "Sleep",
  ];
  List<int> tiles = [1, 2, 3, 4, 5, 6, 7, 8];
  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Stack(children: [
      SizedBox(
          height: 844.h,
          width: 390.w,
          child: Column(children: [
            const RegularAppBar(title: 'All Meditations'),
            AppSpacerH(40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: ref.watch(categoriessProvider).map(
                  initial: (_) => const LoadingWidget(),
                  loading: (_) => const LoadingWidget(),
                  loaded: (_) {
                    if (_.data.data?.category?.isNotEmpty == true) {
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 78 / 96,
                        mainAxisSpacing: 10.h,
                        children: _.data.data!.category!
                            .map((e) => AllCatagoriesCard(
                                  data: e,
                                  onTap: () {
                                    context.nav.pushNamed(
                                        Routes.subCategoryScreen,
                                        arguments: e);
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: Text('No Data'),
                      );
                    }
                  },
                  error: (_) => ErrorTextWidget(error: _.error)),
            )
          ]))
    ]));
  }
}
