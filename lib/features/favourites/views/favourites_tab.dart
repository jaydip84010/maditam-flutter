import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/models/play_list_model/albam.dart';
import 'package:medyo/features/favourites/logic/fav_provider.dart';
import 'package:medyo/utils/dialouges.dart';
import 'package:medyo/widgets/playerLoader.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class FavouritesTab extends ConsumerWidget {
  const FavouritesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacerH(8.h),
          Text('Favourites', style: AppTextDecor.regular18White),
          Expanded(
            child: ref.watch(favListProvider).map(
                initial: (_) => const LoadingWidget(),
                loading: (_) => const LoadingWidget(),
                loaded: (_) => ListView.builder(
                      itemCount: _.data.data!.playList!.length,
                      itemBuilder: (context, index) {
                        final track = _.data.data!.playList![index];
                        return SongTile(
                          onTap: () {
                            context.nav.pushNamed(Routes.playerScreen);
                            ref.watch(selectedAlbumProvider.notifier).state =
                                null;
                            ref.watch(currentPlayListProvider.notifier).state =
                                _.data.data!.playList!;
                          },
                          isFavourite: true,
                          track: track,
                          index: index,
                          // isPaid: index % 2 == 0 ? true : false,
                        );
                      },
                    ),
                error: (_) => ErrorTextWidget(error: _.error)),
          ),
        ],
      ),
    );
  }
}

class SongTile extends ConsumerWidget {
  const SongTile({
    Key? key,
    this.isFavourite = false,
    required this.track,
    this.index,
    this.onTap,
    this.isSelected = false,
    this.isPaid = false,
  }) : super(key: key);
  final bool isFavourite;
  final MusicTrack track;
  final int? index;
  final Function()? onTap;
  final bool isSelected;
  final bool isPaid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioServiceProvider);
    return GestureDetector(
      onTap: () async {
        if (isPaid) {
          showPremiumDialouge(context);
        } else {
          // ref.watch(playerChangeNotifierProvider.notifier).startLoading(true);
          ref.watch(playerLoadingProvider.notifier).startLoading(true);
          onTap?.call();
          if (index != null) {
            await Future.delayed(const Duration(milliseconds: 500));
            // ref.watch(playerChangeNotifierProvider.notifier).stopLoading(false);
            ref.watch(selectedMusicIndex.notifier).state = index!;
          }
          AppGLF.changeAndPlayMedia(audioHandler!, track, shouldPlay: true);
          ref.watch(playerLoadingProvider.notifier).stopLoading(false);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: isSelected
                  ? AppColors.black.withOpacity(0.2)
                  : Colors.transparent),
          padding: EdgeInsets.all(5.r),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: track.thumbnail ?? '',
                  width: 56.w,
                  height: 56.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              AppSpacerW(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${track.name}',
                            style: isSelected
                                ? AppTextDecor.bold14White
                                : AppTextDecor.regular14White,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSpacerW(10.w),
                        // if (isPaid) ...[
                        //   Container(
                        //     height: 18.h,
                        //     width: 20.w,
                        //     // padding: EdgeInsets.all(27.r),
                        //     decoration: BoxDecoration(
                        //         color: AppColors.darkTeal.withOpacity(0.75),
                        //         borderRadius: BorderRadius.circular(5.r)),
                        //     child: SvgPicture.asset(
                        //       'assets/svgs/icon_prem_lock.svg',
                        //       height: 26.h,
                        //     ),
                        //   ),
                        // ] else ...[
                        //   SizedBox(
                        //     height: 18.h,
                        //     width: 20.h,
                        //     child: ref
                        //         .watch(favunfavProvider(track.id.toString()))
                        //         .map(
                        //           initial: (_) => GestureDetector(
                        //               onTap: () {
                        //                 ref
                        //                     .watch(favunfavProvider(
                        //                             track.id.toString())
                        //                         .notifier)
                        //                     .favUnFav();
                        //               },
                        //               child: FavouriteIcon(
                        //                 isFavourite: track.isfavorite == true,
                        //               )),
                        //           loading: (_) => const LoadingWidget(),
                        //           loaded: (_) {
                        //             Future.delayed(50.milisec).then((val) {
                        //               ref.refresh(favunfavProvider(
                        //                   track.id.toString()));

                        //               ref.refresh(favListProvider);
                        //               ref.refresh(tracksProvider(
                        //                   track.albam?.id.toString() ?? ''));
                        //             });
                        //             return FavouriteIcon(
                        //               isFavourite: track.isfavorite == true,
                        //             );
                        //           },
                        //           error: (_) => ErrorTextWidget(error: _.error),
                        //         ),
                        //   )
                        // ]
                      ],
                    ),
                    AppSpacerH(5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${track.description}',
                            style: isSelected
                                ? AppTextDecor.regular12White
                                : AppTextDecor.regular12DarkGreen,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSpacerW(10.w),
                        Text(
                          '${track.duration}',
                          style: AppTextDecor.regular14White,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({Key? key, this.isFavourite = false}) : super(key: key);
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      isFavourite
          ? 'assets/svgs/icon_heart_filled.svg'
          : 'assets/svgs/icon_herat.svg',
      fit: BoxFit.cover,
    );
  }
}
