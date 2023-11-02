import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/theme/misc_provider.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

import '../../config/hive_contants.dart';

class ThemeChangeScreen extends ConsumerStatefulWidget {
  const ThemeChangeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ThemeChangeScreenState();
}

class _ThemeChangeScreenState extends ConsumerState<ThemeChangeScreen> {
  int? selectedIndex;

  bool volume = true;
  Box authbox = Hive.box(AppHSC.authBox);
  Box userbox = Hive.box(AppHSC.userBox);
  String? saved;
  int? index;
  List<String> sceneNames = [
    "themeChange_screen.moonlit",
    "themeChange_screen.hills",
    "themeChange_screen.night",
    "themeChange_screen.rainy",
    "themeChange_screen.cloudy",
    "themeChange_screen.snowy"
  ];
  List<String> scene = [
    "assets/images/dark.gif",
    "assets/images/giphy.gif",
    "assets/images/moonlit.gif",
    "assets/images/nature.gif",
    "assets/images/rainy.gif",
    "assets/images/snowy.gif"
  ];
  List<String> audio = [
    "sounds/night-ambience-17064.mp3",
    "sounds/forest-with-small-river-birds-and-nature-field-recording-6735.mp3",
    "sounds/night-ambience-17064.mp3",
    "sounds/birds-in-the-morning-24147.mp3",
    "sounds/mixkit-calm-thunderstorm-in-the-jungle-2415.wav",
    "sounds/wind__artic__cold-6195.mp3"
  ];
  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioServiceProvider);
    bool switchValue = ref.watch(volumeprovider);
    final audioplayer = ref.watch(audioPlayerProvider);
    playPause() async {
      await audioplayer.play(AssetSource(audio[selectedIndex!]));
      await audioplayer.setReleaseMode(ReleaseMode.loop);
    }

    return ScreenWrapper(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: ListView(
        children: [
          AppSpacerH(40.h),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80.w,
                    height: 40.h,
                    color: Colors.transparent,
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "themeChange_screen.title".tr(),
                  style: AppTextDecor.medium18White,
                ),
              ),
            ],
          ),
          AppSpacerH(60.h),
          Row(
            children: [
              SvgPicture.asset(
                "assets/svgs/scene_sound.svg",
                height: 32.h,
                color: AppColors.white,
              ),
              AppSpacerW(20.w),
              Text(
                "themeChange_screen.scn_sound".tr(),
                style: AppTextDecor.regular14White,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        ref
                            .watch(volumeprovider.notifier)
                            .update((state) => !state);
                        switchValue
                            ? audioplayer.setVolume(0)
                            : audioplayer.setVolume(1);
                      });
                    },
                    child: Icon(
                      switchValue ? Icons.volume_up : Icons.volume_off,
                      color: AppColors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          AppSpacerH(40.h),
          Row(
            children: [
              SvgPicture.asset(
                "assets/svgs/scene.svg",
                height: 32.h,
                color: AppColors.white,
              ),
              AppSpacerW(20.w),
              Text(
                "themeChange_screen.title".tr(),
                style: AppTextDecor.regular14White,
              )
            ],
          ),
          AppSpacerH(20.h),
          AppSpacerH(16.h),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400.h,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                            margin:
                                EdgeInsets.only(left: index == 0 ? 0 : 16.w),
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140.w,
                                  height: 300.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: selectedIndex == index
                                          ? Border.all(
                                              width: 2.h,
                                              color: AppColors.white)
                                          : null),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      scene[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                AppSpacerH(12.h),
                                Center(
                                  child: Text(
                                    sceneNames[index].tr(),
                                    style: AppTextDecor.regular16White,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ],
                  );
                }),
          ),
          AppSpacerH(20.h),
          SizedBox(
            child: Center(
              child: StreamBuilder<Object>(
                  stream: audioHandler?.playbackState
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return GestureDetector(
                      onTap: (() async {
                        setState(() {});

                        if (playing == false) {
                          playPause();
                        }
                        var box = await Hive.openBox("app");

                        box.put('saved_scene', scene[selectedIndex!]);
                        context.nav.pushNamed(Routes.homeScreen);
                        ref
                            .watch(sceneProvider.notifier)
                            .update((state) => scene[selectedIndex!]);

                        // switchValue ? playPause() : null;
                      }),
                      child: Container(
                        width: 168.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                            color: AppColors.darkGreen,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.buttonBorder, width: 1.w)),
                        child: Center(
                          child: Text(
                            "themeChange_screen.save".tr(),
                            style: AppTextDecor.regular14White,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}
