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

class MostRecommendedChannelsScreen extends ConsumerStatefulWidget {
  const MostRecommendedChannelsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MostRecommendedChannelsScreenState();
}

class _MostRecommendedChannelsScreenState
    extends ConsumerState<MostRecommendedChannelsScreen> {
  // final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    // controller.addListener(() {
    //   if (controller.offset >= controller.position.maxScrollExtent) {
    //     ref
    //         .watch(dashboardcategoryalbumListProvider('Most-Recomanded'))
    //         .maybeWhen(
    //           orElse: () {},
    //           loaded: (data) {
    //             EasyLoading.showInfo('Reached Scroll End');
    //             if (data.data!.albams!.meta!.currentPage! <
    //                 data.data!.albams!.meta!.lastPage!) {
    //               ref
    //                   .watch(
    //                       dashboardcategoryalbumListProvider('Most-Recomanded')
    //                           .notifier)
    //                   .getDashboardCategoryAlbumList(
    //                       page: data.data!.albams!.meta!.currentPage! + 1);
    //             }
    //           },
    //         );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Column(
      children: [
        const RegularAppBar(title: "Most Recommended"),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppSpacerH(12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: ref
                    .watch(
                        dashboardcategoryalbumListProvider('Most-Recomanded'))
                    .map(
                        initial: (_) => const LoadingWidget(),
                        loading: (_) => const LoadingWidget(),
                        loaded: (_) {
                          return GridView.count(
                            // controller: controller,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 78 / 96,
                            mainAxisSpacing: 10.h,
                            children: _.data.data!.albams!.map(
                              (e) {
                                int index = _.data.data!.albams!.indexOf(e);
                                return GestureDetector(
                                  onTap: () {
                                    ref
                                        .watch(selectedDatumProvider.notifier)
                                        .state = _.data.data!.albams![index];
                                    ref
                                        .watch(selectedMusicProvider.notifier)
                                        .update((state) => "Home");
                                    context.nav.pushNamed(Routes.playerScreen);
                                  },
                                  child: MostRecommendedCard(
                                    margin: 0,
                                    data: e,
                                  ),
                                );
                              },
                            ).toList(),
                          );
                        },
                        error: (_) => ErrorTextWidget(error: _.error)),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
