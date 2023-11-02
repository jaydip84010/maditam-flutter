import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/music_details.dart';

class PLayerAppBar extends ConsumerWidget {
  const PLayerAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioServiceProvider);

    return StreamBuilder<MediaItem?>(
        stream: audioHandler?.mediaItem,
        builder: (context, media) {
          return Column(
            children: [
              AppSpacerH(44.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.nav.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      color: Colors.transparent,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 18.h,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      media.data?.title ?? '',
                      style: AppTextDecor.bold18White,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // PlayerAppBarItem2(
                  //   widget: media.data != null
                  //       ? ref
                  //           .watch(favunfavProvider(
                  //               media.data?.extras?['id'] ?? ''))
                  //           .map(
                  //             initial: (_) => GestureDetector(
                  //                 onTap: () {
                  //                   ref
                  //                       .watch(favunfavProvider(
                  //                               media.data?.extras?['id'] ??
                  //                                   '')
                  //                           .notifier)
                  //                       .favUnFav();
                  //                 },
                  //                 child: FavouriteIcon(
                  //                   isFavourite:
                  //                       media.data?.extras!['isFav'] == true,
                  //                 )),
                  //             loading: (_) => const LoadingWidget(),
                  //             loaded: (_) {
                  //               Future.delayed(50.milisec).then((val) {
                  //                 ref.invalidate(favunfavProvider(
                  //                     media.data?.extras?['id'] ?? ''));

                  //                 ref.invalidate(favListProvider);
                  //                 ref.invalidate(tracksProvider(
                  //                     media.data?.extras?['album'] ?? ''));
                  //               });
                  //               return FavouriteIcon(
                  //                   isFavourite:
                  //                       media.data?.extras!['isFav'] == true);
                  //             },
                  //             error: (_) => ErrorTextWidget(error: _.error),
                  //           )
                  //       : const SizedBox(),
                  // ),
                  AppSpacerW(16.w),
                  // Text(media.data!.extras!['id']),

                  media.data?.extras?["hasReadMore"] == false
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 35.h,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                // backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MusicDetaisScreen(
                                      musicId: media.data!.extras!['id'],
                                      thumbnailUrl:
                                          media.data!.extras!['thumbnail'],
                                    ),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                "assets/svgs/read more.svg",
                                width: 30,
                                color: Colors.white,
                              )
                              // Text(
                              //   "see more",
                              //   style: AppTextDecor.bold14White.copyWith(
                              //     fontSize: 14.sp,
                              //     fontWeight: FontWeight.w400,
                              //   ),
                              // ),
                              ),
                        ),

                  // const PlayerAppBarItem(
                  //   svgPath: 'assets/svgs/icon_download.svg',
                  // ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              AppSpacerH(16.h),
            ],
          );
        });
  }
}

class PlayerAppBarItem extends StatelessWidget {
  const PlayerAppBarItem({
    Key? key,
    this.onTap,
    required this.svgPath,
  }) : super(key: key);
  final Function()? onTap;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.h),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.slidePanel,
          ),
          height: 40.h,
          width: 40.h,
          child: Center(
              child: SvgPicture.asset(
            svgPath,
            height: 16.h,
            fit: BoxFit.cover,
            color: AppColors.white,
          )),
        ),
      ),
    );
  }
}

class PlayerAppBarItem2 extends StatelessWidget {
  const PlayerAppBarItem2({
    Key? key,
    this.onTap,
    required this.widget,
  }) : super(key: key);
  final Function()? onTap;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.h),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.slidePanel,
          ),
          height: 40.h,
          width: 40.h,
          child: Center(child: widget),
        ),
      ),
    );
  }
}
