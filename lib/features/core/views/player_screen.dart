import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/features/favourites/views/favourites_tab.dart';
import 'package:medyo/services/ad_helper.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/player_app_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../widgets/playerLoader.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late InterstitialAd interad;
  bool isloaded = false;
  bool allowUpdate = true;
  bool isSliderOpen = false;
  @override
  void initState() {
    super.initState();
    initinterad();
  }

  initinterad() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstetialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: ((error) {
          debugPrint('Failed to load a banner ad: ${error.message}');
        }),
      ),
    );
  }

  void onLoaded(InterstitialAd ad) {
    interad = ad;
    isloaded = true;
  }

  @override
  Widget build(BuildContext context) {
    AppGLF.changeStatusBarColor(color: Colors.transparent);
    final audioHandler = ref.watch(audioServiceProvider);
    final album = ref.watch(selectedAlbumProvider);
    final album2 = ref.watch(selectedDatumProvider);
    final music = ref.watch(selectedMusicProvider);
    final musicIndex = ref.watch(selectedMusicIndex);
    final playList = ref.watch(currentPlayListProvider);

    final isLoading = ref.watch(playerLoadingProvider.notifier).state;

    if (album != null && music == "Sub") {
      ref.watch(tracksProvider(album.id.toString())).maybeWhen(
          orElse: () {},
          loaded: (_) async {
            Future.delayed(50.milisec).then((value) {
              ref.watch(currentPlayListProvider.notifier).state =
                  _.data!.albams!;

              if (_.data != null &&
                  _.data!.albams!.length < musicIndex &&
                  audioHandler?.mediaItem.value?.extras?['album'] ==
                      _.data!.albams!.first.albam?.id.toString()) {
                AppGLF.changeAndPlayMedia(
                    audioHandler!, _.data!.albams![musicIndex],
                    shouldPlay: true);
              }
            });
          });
    } else if (album2 != null && music == "Home") {
      ref.watch(tracksProvider(album2.id.toString())).maybeWhen(
          orElse: () {},
          loaded: (_) async {
            Future.delayed(50.milisec).then((value) {
              ref.watch(currentPlayListProvider.notifier).state =
                  _.data!.albams!;

              if (_.data != null &&
                  _.data!.albams!.length < musicIndex &&
                  audioHandler?.mediaItem.value?.extras?['album'] ==
                      _.data!.albams!.first.albam?.id.toString()) {
                AppGLF.changeAndPlayMedia(
                    audioHandler!, _.data!.albams![musicIndex],
                    shouldPlay: true);
              }
            });
          });
    }

    return Scaffold(
      body: StreamBuilder<MediaItem?>(
          stream: audioHandler?.mediaItem,
          builder: (context, media) {
            if (playList.length > musicIndex) {
              AppGLF.setMedia(audioHandler!, media, playList[musicIndex]);
            }
            return Container(
                height: 844.h,
                width: 390.w,
                color: AppColors.darkTeal,
                child: Column(
                  children: [
                    const PLayerAppBar(),
                    Expanded(
                        child: SlidingUpPanel(
                      onPanelSlide: (position) {
                        print('Print position $position');
                      },
                      header: Container(
                        width: 390.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        child: Center(
                            child: SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: AnimatedRotation(
                            turns: isSliderOpen ? 0 : 0.5,
                            duration: 200.milisec,
                            child: const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.white,
                            ),
                          ),
                        )),
                      ),
                      onPanelOpened: () {
                        debugPrint('Slider Opened');
                        setState(() {
                          isSliderOpen = true;
                        });
                      },
                      onPanelClosed: () {
                        debugPrint('Slider Closed');
                        setState(() {
                          isSliderOpen = false;
                        });
                      },
                      color: Colors.transparent,
                      minHeight: 270.h,
                      maxHeight: 600.h,
                      panelBuilder: (controller) => ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          decoration:
                              const BoxDecoration(color: AppColors.slidePanel),
                          child: Column(
                            children: [
                              AppSpacerH(20.h),
                              Expanded(
                                child: playList.isNotEmpty
                                    ? ListView.builder(
                                        controller: controller,
                                        padding: EdgeInsets.zero,
                                        itemCount: playList.length,
                                        itemBuilder: (context, index) {
                                          final song = playList[index];
                                          return SongTile(
                                            track: song,
                                            index: index,
                                            isSelected:
                                                media.data?.title == song.name,
                                            isPaid: playList[index].isPaid!,
                                          );
                                        })
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: AppColors.darkTeal,
                          child: Column(
                            children: [
                              Container(
                                height: 246.h,
                                width: 246.h,
                                padding: EdgeInsets.all(12.h),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(123.h),
                                  border: Border.all(
                                      color: AppColors.darkGreen, width: 1.w),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(111.h),
                                    child: CachedNetworkImage(
                                      imageUrl: media.data != null
                                          ? media.data!.artUri.toString()
                                          : "",
                                      height: 222.h,
                                      width: 222.h,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/cdlabel.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              AppSpacerH(23.h),
                              SizedBox(
                                width: 340.w,
                                child: Text(
                                  media.data != null ? media.data!.title : "",
                                  style: AppTextDecor.regular16White,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 340.w,
                                child: TextScroll(
                                  media.data?.extras?['desc'] ?? "",
                                  style: AppTextDecor.regular16White,
                                  textAlign: TextAlign.left,
                                  velocity: const Velocity(
                                      pixelsPerSecond: Offset(30, 0)),
                                ),
                              ),
                              AppSpacerH(26.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // const PlayerIcons(
                                  //   svgPath: 'assets/svgs/icon_suffle.svg',
                                  // ),
                                  const SizedBox(),
                                  PlayerIcons(
                                    onTap: () async {
                                      audioHandler?.skipToPrevious();
                                    },
                                    svgPath: context.locale.languageCode == "ar"
                                        ? 'assets/svgs/icon_next.svg'
                                        : 'assets/svgs/icon_previous.svg',
                                  ),
                                  StreamBuilder<bool>(
                                    stream: audioHandler?.playbackState
                                        .map((state) => state.playing)
                                        .distinct(),
                                    builder: (context, snapshot) {
                                      final playing = snapshot.data ?? false;

                                      return isLoading
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.white,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                if (playing) {
                                                  audioHandler?.pause();
                                                } else {
                                                  audioHandler?.play();
                                                }
                                              },
                                              child: Container(
                                                height: 57.h,
                                                width: 57.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28.5.h),
                                                  border: Border.all(
                                                      color:
                                                          AppColors.darkGreen,
                                                      width: 1.w),
                                                ),
                                                child: Center(
                                                  child: PlayerIcons(
                                                    svgPath: playing
                                                        ? 'assets/svgs/icon_pause.svg'
                                                        : 'assets/svgs/icon_play.svg',
                                                  ),
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                  PlayerIcons(
                                    onTap: () {
                                      if (isloaded) {
                                        interad.show();
                                      }
                                      audioHandler?.skipToNext();
                                    },
                                    svgPath: context.locale.languageCode == "ar"
                                        ? 'assets/svgs/icon_previous.svg'
                                        : 'assets/svgs/icon_next.svg',
                                  ),
                                  const SizedBox(),
                                  // const PlayerIcons(
                                  //   svgPath: 'assets/svgs/icon_repeat.svg',
                                  // ),
                                ],
                              ),
                              AppSpacerH(10.h),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: SliderTheme(
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
                                              (media.data!.duration!.inSeconds))
                                          : 0,
                                      activeColor: AppColors.darkGreen,
                                      thumbColor: AppColors.darkGreen,
                                      inactiveColor: AppColors.darkGreen
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
                                  )),
                              AppSpacerH(10.h),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (media.data != null &&
                                                media.data!.duration != null)
                                            ? AppGLF.format(ref.watch(
                                                playBackDurationProvider))
                                            : "0:00",
                                        style: AppTextDecor.regular14White,
                                      ),
                                      Text(
                                        (media.data != null &&
                                                media.data!.duration != null)
                                            ? AppGLF.format(
                                                media.data!.duration!)
                                            : "0:00",
                                        style: AppTextDecor.regular14White,
                                      ),
                                    ],
                                  ))
                            ],
                          )),
                    ))
                  ],
                ));
          }),
    );
  }
}

class PlayerIcons extends StatelessWidget {
  const PlayerIcons({
    Key? key,
    required this.svgPath,
    this.onTap,
  }) : super(key: key);
  final String svgPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SvgPicture.asset(
          svgPath,
          width: 23.h,
        ),
      ),
    );
  }
}

class PlayerIconsSmall extends StatelessWidget {
  const PlayerIconsSmall({
    Key? key,
    required this.svgPath,
    this.onTap,
  }) : super(key: key);
  final String svgPath;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: SvgPicture.asset(
          svgPath,
          width: 12.h,
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
