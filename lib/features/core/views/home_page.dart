import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/category_list_model/category.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  String gandu = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ref.watch(categoriessProvider).map(
            initial: (_) => const LoadingWidget(),
            loading: (_) => const LoadingWidget(),
            loaded: (_) {
              if (_.data.data?.category?.isNotEmpty == true) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: SnappingListScrollPhysics(itemHeight: 610.h),
                  itemCount: _.data.data!.category!.length,
                  itemBuilder: (context, index) {
                    final Category category = _.data.data!.category![index];
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: index == _.data.data!.category!.length - 1
                              ? 94.h
                              : 0.h),
                      child: HomePageTile(
                        category: category,
                        onTap: () {
                          context.nav.pushNamed(Routes.subCategoryScreen,
                              arguments: category);
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('menu_screen.no_data'.tr()),
                );
              }
            },
            error: (_) => ErrorTextWidget(error: _.error)));
  }
}

class HomePageTile extends StatelessWidget {
  const HomePageTile({
    Key? key,
    this.onTap,
    required this.category,
  }) : super(key: key);
  final Function()? onTap;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: SizedBox(
            height: 590.h,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: category.thumbnail ?? '',
                  fit: BoxFit.cover,
                  height: 590.h,
                  width: double.infinity,
                ),
                Container(
                  height: 590.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xff253334),
                      Color.fromARGB(0, 37, 51, 52),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  )),
                ),
                Positioned(
                    bottom: 10,
                    child: Container(
                      width: 350.w,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        category.name ?? '',
                        style: AppTextDecor.regular18White,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SnappingListScrollPhysics extends ScrollPhysics {
  final double itemHeight;

  const SnappingListScrollPhysics({
    required this.itemHeight,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  SnappingListScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      SnappingListScrollPhysics(
        parent: buildParent(ancestor),
        itemHeight: itemHeight,
      );

  double _getItem(ScrollMetrics position) {
    return (position.pixels) / itemHeight;
  }

  double _getPixels(ScrollMetrics position, double item) =>
      min(item * itemHeight, position.maxScrollExtent);

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
