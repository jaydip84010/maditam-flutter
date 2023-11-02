import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/album_list_model/albam.dart';
import 'package:medyo/features/core/models/category_list_model/category.dart';
import 'package:medyo/services/ad_helper.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/dialouges.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class SubCategoryPage extends ConsumerStatefulWidget {
  const SubCategoryPage({super.key, required this.category});
  final Category category;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubCategoryPageState();
}

class _SubCategoryPageState extends ConsumerState<SubCategoryPage> {
  late BannerAd bannerAd;
  bool isloaded = false;
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    initbannerAd();
    // }
  }

  initbannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isloaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Stack(children: [
      SizedBox(
        height: 844.h,
        width: 390.w,
        child: Column(
          children: [
            RegularAppBar(title: widget.category.name ?? ''),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ref
                    .watch(albumsProvider(widget.category.id.toString()))
                    .map(
                      initial: (_) => const LoadingWidget(),
                      loading: (_) => const LoadingWidget(),
                      loaded: (_) {
                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 167 / 240,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          children: _.data.data!.albams!
                              .map((e) => AlbumTile(
                                    albam: e,
                                  ))
                              .toList(),
                        );
                      },
                      error: (_) => ErrorTextWidget(error: _.error),
                    ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
          bottom: 0,
          child: isloaded
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ),
                )
              : Container()),
    ]));
  }
}

class AlbumTile extends ConsumerWidget {
  const AlbumTile({
    Key? key,
    required this.albam,
  }) : super(key: key);
  final Albam albam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (BuildContext context, Box userBox, Widget? child) {
          final bool isPremium = (userBox.get(AppHSC.premium) == true);
          final bool isPaid = albam.isPaid ?? false;
          return GestureDetector(
            onTap: () {
              if (isPaid) {
                showPremiumDialouge(context);
              } else {
                ref.watch(selectedAlbumProvider.notifier).state = albam;
                ref
                    .watch(selectedMusicProvider.notifier)
                    .update((state) => "Sub");
                context.nav.pushNamed(Routes.playerScreen);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 143.h,
                  width: 167.w,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: CachedNetworkImage(
                          imageUrl: albam.thumbnail ?? '',
                          width: 167.w,
                          height: 143.h,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const LoadingWidget(),
                          errorWidget: (context, url, error) => ErrorTextWidget(
                              error: "menu_screen.error_text".tr()),
                        ),
                      ),
                      if (isPaid)
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(27.r),
                            decoration: BoxDecoration(
                                color: AppColors.darkTeal.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(5.r)),
                            child: SvgPicture.asset(
                              'assets/svgs/icon_prem_lock.svg',
                              height: 26.h,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                AppSpacerH(8.h),
                Text(
                  albam.name.toString().tr(),
                  style: AppTextDecor.semiBold16White,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                AppSpacerH(4.h),
                Expanded(
                    child: Text(
                  albam.description.toString().tr(),
                  style: AppTextDecor.regular12DarkGreen,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ))
              ],
            ),
          );
        });
  }
}
