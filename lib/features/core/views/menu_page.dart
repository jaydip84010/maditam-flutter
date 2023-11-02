import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/app_banner_list_model/banner.dart';
import 'package:medyo/features/core/models/category_list_model/category.dart';
import 'package:medyo/features/theme/misc_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/dialouges.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/features/core/models/dashboard_category_a_lbums_list/albam.dart'
    as hAlbam;

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  Box authbox = Hive.box(AppHSC.authBox);
  Box userbox = Hive.box(AppHSC.userBox);
  String? saved;

  @override
  void initState() {
    debugPrint("Build");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final audioplayer = ref.watch(audioPlayerProvider);
      if (audioplayer.state != PlayerState.playing) {
        audioplayer.play(AssetSource("sounds/birds-in-the-morning-24147.mp3"));
        await audioplayer.setVolume(0);
      }
      _checkScene();
    });
  }

  Future<void> _checkScene() async {
    var box = await Hive.openBox("app");

    saved = box.get('saved_scene');
  }

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
  bool sunny = true;

  @override
  Widget build(BuildContext context) {
    String? scene = ref.watch(sceneProvider);

    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (BuildContext context, Box userBox, Widget? child) {
          return ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.authBox).listenable(),
              builder: (BuildContext context, Box authBox, Widget? child) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        saved != null
                            ? saved.toString()
                            : scene != ""
                                ? scene!
                                : AppGLF.getTimeOfDay() == "Morning"
                                    ? "assets/images/giphy.gif"
                                    : AppGLF.getTimeOfDay() == "Afternoon"
                                        ? "assets/images/nature.gif"
                                        : AppGLF.getTimeOfDay() == "Evening"
                                            ? "assets/images/rainy.gif"
                                            : "assets/images/moonlit.gif",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Color(0xff253334),
                          Color.fromARGB(0, 37, 51, 52),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      )),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: ListView(
                          children: [
                            AppSpacerH(20.h),
                            authBox.get(AppHSC.authToken) == null
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        context.nav
                                            .pushNamed(Routes.loginScreen);
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            color: AppColors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        minimumSize: Size(150.w, 50.h),
                                        alignment: Alignment.center,
                                      ),
                                      child: Text(
                                        "login_screen.login".tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    context.nav.pushNamed(Routes.themechange);
                                    debugPrint(scene);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svgs/scene.svg",
                                    height: 40.h,
                                    color: AppColors.white,
                                  ),
                                )),
                            AppSpacerH(24.h),
                            Text(
                              "${"menu_screen.good".tr()} ${AppGLF.getTimeOfDay().tr()}, ${(userBox.get(AppHSC.firstName) != null && userBox.get(AppHSC.firstName) != '') ? userBox.get(AppHSC.firstName) : 'Guest'}",
                              style: AppTextDecor.bold18White,
                            ),
                            AppSpacerH(16.h),
                            ref.watch(appBannersProvider).map(
                                initial: (_) => const LoadingWidget(),
                                loading: (_) => const LoadingWidget(),
                                loaded: (_) {
                                  if (_.data.data!.banner!.isNotEmpty) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: 388.w,
                                          height: 220.h,
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  _.data.data!.banner!.length,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    AppBannerContainer(
                                                      margin:
                                                          index == 0 ? 0 : 16.w,
                                                      banner: _.data.data!
                                                          .banner![index],
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                        AppSpacerH(24.h),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                                error: (_) => ErrorTextWidget(error: _.error)),
                            ref.watch(categoriessProvider).map(
                                initial: (_) => const LoadingWidget(),
                                loading: (_) => const LoadingWidget(),
                                loaded: (_) {
                                  if (_.data.data?.category?.isNotEmpty ==
                                      true) {
                                    return GridView.count(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 12.w,
                                      childAspectRatio: 78 / 86,
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
                                    return Center(
                                      child: Text('menu_screen.no_data'.tr()),
                                    );
                                  }
                                },
                                error: (_) => ErrorTextWidget(error: _.error)),
                            AppSpacerH(24.h),
                            SizedBox(
                              child: Center(
                                child: GestureDetector(
                                  onTap: (() {
                                    context.nav.pushNamed(Routes.allcatagories);
                                  }),
                                  child: Container(
                                    width: 168.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: AppColors.buttonBorder,
                                            width: 1.w)),
                                    child: Center(
                                      child: Text(
                                        "menu_screen.view_all".tr(),
                                        style: AppTextDecor.regular12White,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            AppSpacerH(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppGLF.getTimeOfDay() == "Morning" ? "menu_screen.morning".tr() : AppGLF.getTimeOfDay() == "Afternoon" ? "menu_screen.afternoon".tr() : AppGLF.getTimeOfDay() == "Evening" ? "menu_screen.evening".tr() : "menu_screen.night".tr()} ${"menu_screen.reset".tr()}",
                                  style: AppTextDecor.bold14White.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.nav
                                        .pushNamed(Routes.afternoonreset);
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 40.h,
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "menu_screen.see_all".tr(),
                                        style: AppTextDecor.regular14DarkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacerH(16.h),
                            const DashboardCatagories(),
                            AppSpacerH(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "menu_screen.recommand".tr(),
                                  style: AppTextDecor.bold14White
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.nav.pushNamed(
                                        Routes.mostrecommendedchannel);
                                  },
                                  child: Container(
                                    width: 80.w,
                                    height: 40.h,
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "menu_screen.see_all".tr(),
                                        style: AppTextDecor.regular14DarkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacerH(16.h),
                            SizedBox(
                              width: 200.w,
                              height: 232.h,
                              child: ref
                                  .watch(dashboardcategoryalbumListProvider(
                                      'Most-Recomanded'))
                                  .map(
                                    initial: (_) => const LoadingWidget(),
                                    loading: (_) => const LoadingWidget(),
                                    loaded: (_) {
                                      return ValueListenableBuilder(
                                          valueListenable:
                                              Hive.box(AppHSC.userBox)
                                                  .listenable(),
                                          builder: (BuildContext context,
                                              Box userBox, Widget? child) {
                                            final bool isPremium =
                                                (userBox.get(AppHSC.premium) ==
                                                    true);
                                            return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    _.data.data!.albams!.length,
                                                itemBuilder: (context, index) {
                                                  final isPaid = _.data.data!
                                                      .albams![index].isPaid;
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (isPaid!) {
                                                        showPremiumDialouge(
                                                            context);
                                                      } else {
                                                        ref
                                                            .watch(
                                                                selectedDatumProvider
                                                                    .notifier)
                                                            .state = _.data
                                                                .data!.albams![
                                                            index];
                                                        ref
                                                            .watch(
                                                                selectedMusicProvider
                                                                    .notifier)
                                                            .update((state) =>
                                                                "Home");
                                                        context.nav.pushNamed(
                                                            Routes
                                                                .playerScreen);
                                                      }
                                                    },
                                                    child: MostRecommendedCard(
                                                        margin: index == 0 &&
                                                                context.locale ==
                                                                    'ar'
                                                            ? 0
                                                            : 10.w,
                                                        data: _.data.data!
                                                            .albams![index],
                                                        isPaid: isPaid!),
                                                  );
                                                });
                                          });
                                    },
                                    error: (_) =>
                                        ErrorTextWidget(error: _.error),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
  }
}

class AppBannerContainer extends StatelessWidget {
  const AppBannerContainer({
    Key? key,
    required this.margin,
    this.banner,
  }) : super(key: key);
  final double margin;
  final AppBanner? banner;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: context.locale == const Locale("ar", "SA")
            ? EdgeInsets.only(right: margin)
            : EdgeInsets.only(left: margin),
        decoration: const BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 320.w,
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: banner != null
                    ? Image.network(
                        banner!.thumbnail.toString(),
                        width: 320.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/home_song.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            AppSpacerH(12.h),
            Text(
              banner != null
                  ? banner!.title.toString().tr()
                  : "10 Minute Mindfulness Meditation",
              style: AppTextDecor.bold12White,
            ),
          ],
        ));
  }
}

class MostRecommendedCard extends StatelessWidget {
  const MostRecommendedCard({
    Key? key,
    required this.margin,
    required this.data,
    this.isPaid,
  }) : super(key: key);
  final double margin;
  final bool? isPaid;
  final hAlbam.Albam data;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (BuildContext context, Box userBox, Widget? child) {
          final bool isPremium = (userBox.get(AppHSC.premium) == true);
          return Container(
              margin: EdgeInsets.only(left: margin),
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Container(
                      width: 200.w,
                      height: 160.h,
                      decoration: const BoxDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: data != null
                            ? Image.network(
                                data.thumbnail.toString(),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/most_recommended.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (isPaid!)
                      Positioned(
                          bottom: 5.h,
                          left: 5.h,
                          child: CircleAvatar(
                              maxRadius: 13,
                              backgroundColor:
                                  AppColors.darkTeal.withOpacity(0.4),
                              child: SvgPicture.asset(
                                "assets/svgs/lock_icon.svg",
                                width: 12.w,
                                height: 16.h,
                              )))
                  ]),
                  AppSpacerH(12.h),
                  SizedBox(
                    width: 160.w,
                    height: 52.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data != null
                            ? Text(
                                data.name.toString().tr(),
                                style: AppTextDecor.bold12White,
                              )
                            : Text(
                                "menu_screen.mindful".tr(),
                                style: AppTextDecor.bold12White,
                              ),
                        data != null
                            ? Expanded(
                                child: Text(
                                  data.description.toString().tr(),
                                  style: AppTextDecor.regular12DarkGreen,
                                  maxLines: 2,
                                ),
                              )
                            : Text(
                                "menu_screen.relieve".tr(),
                                style: AppTextDecor.regular12DarkGreen,
                              ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}

class AfterNoonResteCard extends StatelessWidget {
  const AfterNoonResteCard({
    Key? key,
    required this.margin,
    this.data,
    required this.isPaid,
  }) : super(key: key);
  final double margin;
  final bool isPaid;
  final hAlbam.Albam? data;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (BuildContext context, Box userBox, Widget? child) {
          final bool isPremium = (userBox.get(AppHSC.premium) == true);
          return Container(
              margin: EdgeInsets.only(left: margin),
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Container(
                      width: 200.w,
                      height: 160.h,
                      decoration: const BoxDecoration(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: data != null
                            ? Image.network(
                                data!.thumbnail.toString(),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/home_reset.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (isPaid)
                      Positioned(
                          bottom: 5.h,
                          left: 5.h,
                          child: CircleAvatar(
                              maxRadius: 13,
                              backgroundColor:
                                  AppColors.darkTeal.withOpacity(0.4),
                              child: SvgPicture.asset(
                                "assets/svgs/lock_icon.svg",
                                width: 12.w,
                                height: 16.h,
                              )))
                  ]),
                  AppSpacerH(10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data != null
                          ? Text(
                              data!.name.toString().tr(),
                              style: AppTextDecor.bold12White,
                            )
                          : Text(
                              "menu_screen.mindful".tr(),
                              style: AppTextDecor.bold12White,
                            ),
                      AppSpacerW(4.w),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: 'menu_screen.daily_meditam'.tr(),
                            style: AppTextDecor.regular12DarkGreen),
                        WidgetSpan(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, bottom: 5.h, right: 5.w),
                                child: const CircleAvatar(
                                  maxRadius: 2,
                                  backgroundColor: AppColors.darkGreen,
                                ))),
                        TextSpan(
                            text: 'menu_screen.tamara_lev'.tr(),
                            style: AppTextDecor.regular12DarkGreen),
                      ])),
                    ],
                  ),
                ],
              ));
        });
  }
}

class AllCatagoriesCard extends ConsumerWidget {
  const AllCatagoriesCard({
    Key? key,
    this.data,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;
  final Category? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 78.w,
          height: 66.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.premiumBG,
          ),
          child: Column(children: [
            AppSpacerH(12.h),
            data!.icon != null
                ? Image.network(
                    data!.icon.toString(),
                    width: 38.w,
                    height: 38.h,
                    color: AppColors.white,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/home_sgstn_tile_2.png",
                    fit: BoxFit.cover,
                  ),
            AppSpacerH(6.h),
            Text(
              data!.name != null ? data!.name.toString().tr() : "Chill",
              style: AppTextDecor.regular12White,
            )
          ]),
        ));
  }
}

class DashboardCatagories extends ConsumerStatefulWidget {
  const DashboardCatagories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardCatagoriesState();
}

class _DashboardCatagoriesState extends ConsumerState<DashboardCatagories> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    // controller.addListener(() {
    //   if (controller.offset >= controller.position.maxScrollExtent) {
    //     setState(() {
    //       EasyLoading.showInfo('Reached Scroll End');
    //     });
    //     ref.watch(dashboardcategoryalbumListProvider).maybeWhen(
    //           orElse: () {},
    //           loaded: (data) {
    //             setState(() {
    //               EasyLoading.showInfo('Reached Scroll End');
    //             });

    //             if (data.data!.albams!.meta!.currentPage! <
    //                 data.data!.albams!.meta!.lastPage!) {
    //               ref
    //                   .watch(dashboardcategoryalbumListProvider.notifier)
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
    return ref
        .watch(dashboardcategoryalbumListProvider(
            AppGLF.getTimeOfDay().toLowerCase()))
        .map(
          initial: (_) => const LoadingWidget(),
          loading: (_) => const LoadingWidget(),
          loaded: (_) {
            return ValueListenableBuilder(
                valueListenable: Hive.box(AppHSC.userBox).listenable(),
                builder: (BuildContext context, Box userBox, Widget? child) {
                  // final bool isPremium =
                  //     (userBox.get(AppHSC.premium) == true);

                  return SizedBox(
                      width: 200.w,
                      height: 212.h,
                      child: ListView.builder(
                          controller: controller,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _.data.data!.albams!.length,
                          itemBuilder: (context, index) {
                            final data = _.data.data!.albams![index];
                            final isPaid = _.data.data!.albams![index].isPaid;
                            print(
                                "isPaid ${_.data.data!.albams![index].isPaid}");
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isPaid!) {
                                      showPremiumDialouge(context);
                                    } else {
                                      ref
                                          .watch(selectedDatumProvider.notifier)
                                          .state = _.data.data!.albams![index];
                                      ref
                                          .watch(selectedMusicProvider.notifier)
                                          .update((state) => "Home");
                                      context.nav
                                          .pushNamed(Routes.playerScreen);
                                    }
                                  },
                                  child: AfterNoonResteCard(
                                    // ignore: unrelated_type_equality_checks
                                    margin: index == 0 && context.locale == "ar"
                                        ? 0
                                        : 10.w,
                                    data: data,
                                    isPaid: isPaid!,
                                  ),
                                ),
                              ],
                            );
                          }));
                });
          },
          error: (_) => ErrorTextWidget(error: _.error),
        );
  }
}
