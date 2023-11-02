import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/views/menu_page.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class AfterNoonResetAllScreen extends ConsumerStatefulWidget {
  const AfterNoonResetAllScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AfterNoonResetAllScreenState();
}

class _AfterNoonResetAllScreenState
    extends ConsumerState<AfterNoonResetAllScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Column(
      children: [
        RegularAppBar(title: "${AppGLF.getTimeOfDay().tr()} Reset"),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppSpacerH(12.h),
              ref
                  .watch(dashboardcategoryalbumListProvider(
                      AppGLF.getTimeOfDay().toLowerCase()))
                  .map(
                      initial: (_) => const LoadingWidget(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: GridView.count(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
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
                                      context.nav
                                          .pushNamed(Routes.playerScreen);
                                    },
                                    child: AfterNoonResteCard(
                                      margin: 0,
                                      data: e,
                                      isPaid: e.isPaid!,
                                    ));
                              },
                            ).toList(),
                          ),
                        );
                      },
                      error: (_) => ErrorTextWidget(error: _.error)),
            ],
          ),
        ),
      ],
    ));
  }
}
