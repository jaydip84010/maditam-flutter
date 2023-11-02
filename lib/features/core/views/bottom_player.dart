import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/core/views/player_screen.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class BottomPlayerControl extends ConsumerWidget {
  const BottomPlayerControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioServiceProvider);
    final showBottom = ref.watch(bottomShow);
    return showBottom
        ? GestureDetector(
            onPanUpdate: (details) {
              debugPrint('drag : ${details.delta.dy}');
              ref.watch(bottomPlayerOffset('x').notifier).state =
                  details.delta.dx * 5;
              ref.watch(bottomPlayerOffset('y').notifier).state =
                  details.delta.dy * 5;
              if (details.delta.dy < -3 || details.delta.dy > 3) {
                context.nav.pushNamed(Routes.playerScreen);
                ref.watch(bottomPlayerOffset('x').notifier).state = 0;
                ref.watch(bottomPlayerOffset('y').notifier).state = 0;
              }
              if (details.delta.dx < -10 || details.delta.dx > 10) {
                ref.watch(bottomShow.notifier).state = false;
                ref.watch(bottomPlayerOffset('x').notifier).state = 0;
                ref.watch(bottomPlayerOffset('y').notifier).state = 0;
              }
            },
            child: StreamBuilder<PlaybackState>(
                stream: audioHandler?.playbackState,
                builder: (context, media) {
                  if (media.hasData &&
                      media.data != null &&
                      (media.data!.playing || ref.watch(isAudioPaused))) {
                    return Container(
                      height: 80.h,
                      width: 390.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          AppColors.darkTeal.withOpacity(0),
                          AppColors.darkTeal.withOpacity(1)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                    child: StreamBuilder<MediaItem?>(
                                  stream: audioHandler?.mediaItem,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: snapshot.data!.artUri
                                                .toString(),
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.topLeft,
                                            errorWidget: (context, url, error) {
                                              return const SizedBox();
                                            },
                                          ),
                                          AppSpacerW(10.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.title,
                                                  style:
                                                      AppTextDecor.bold12White,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  snapshot.data!.album ?? '',
                                                  style: AppTextDecor
                                                      .regular12White,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    PlayerIconsSmall(
                                      svgPath: 'assets/svgs/icon_previous.svg',
                                      onTap: () {
                                        audioHandler?.skipToPrevious();
                                      },
                                    ),
                                    AppSpacerW(20.w),
                                    StreamBuilder<bool>(
                                      stream: audioHandler?.playbackState
                                          .map((state) => state.playing)
                                          .distinct(),
                                      builder: (context, snapshot) {
                                        final playing = snapshot.data ?? false;

                                        return GestureDetector(
                                          onTap: () {
                                            debugPrint('Status $playing');
                                            if (playing) {
                                              audioHandler?.pause();
                                            } else {
                                              audioHandler?.play();
                                            }
                                          },
                                          child: Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.h),
                                              border: Border.all(
                                                  color: AppColors.darkGreen,
                                                  width: 1.w),
                                            ),
                                            child: Center(
                                              child: PlayerIconsSmall(
                                                svgPath: playing
                                                    ? 'assets/svgs/icon_pause.svg'
                                                    : 'assets/svgs/icon_play.svg',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    AppSpacerW(20.w),
                                    PlayerIconsSmall(
                                      svgPath: 'assets/svgs/icon_next.svg',
                                      onTap: () {
                                        audioHandler?.skipToNext();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              StreamBuilder<MediaItem?>(
                                  stream: audioHandler?.mediaItem,
                                  builder: (context, media) {
                                    return Text(
                                      (media.data != null &&
                                              media.data!.duration != null)
                                          ? AppGLF.format(ref
                                              .watch(playBackDurationProvider))
                                          : "0:00",
                                      style: AppTextDecor.regular14White,
                                    );
                                  }),
                              Expanded(
                                child: StreamBuilder<MediaItem?>(
                                    stream: audioHandler?.mediaItem,
                                    builder: (context, media) {
                                      return SliderTheme(
                                        data: SliderThemeData(
                                            overlayShape:
                                                SliderComponentShape.noThumb
                                            // here
                                            // trackShape: CustomTrackShape(),
                                            ),
                                        child: Slider(
                                          value: (media.data != null &&
                                                  media.data!.duration != null)
                                              ? (ref
                                                      .watch(
                                                          playBackDurationProvider)
                                                      .inSeconds /
                                                  (media.data!.duration!
                                                      .inSeconds))
                                              : 0,
                                          activeColor: AppColors.white,
                                          thumbColor: AppColors.white,
                                          inactiveColor: AppColors.white
                                              .withOpacity(0.5)
                                              .withOpacity(0.3),
                                          onChanged: (value) {
                                            audioHandler?.seek(Duration(
                                                seconds: (media.data!.duration!
                                                            .inSeconds *
                                                        value)
                                                    .toInt()));
                                          },
                                        ),
                                      );
                                    }),
                              ),
                              StreamBuilder<MediaItem?>(
                                  stream: audioHandler?.mediaItem,
                                  builder: (context, media) {
                                    return Text(
                                      (media.data != null &&
                                              media.data!.duration != null)
                                          ? AppGLF.format(media.data!.duration!)
                                          : "0:00",
                                      style: AppTextDecor.regular14White,
                                    );
                                  })
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          )
        : const SizedBox();
  }
}
