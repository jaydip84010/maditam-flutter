import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/core/views/home_screen_wrapper.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/dialouges.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:share_plus/share_plus.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    Locale selectedLanguage = context.locale;
    Future<void> _showSimpleDialog() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              // <-- SEE HERE
              title: Text('profile_screen.select_language'.tr()),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    context.setLocale(const Locale('en', 'US'));

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreenWrapper()),
                        (route) => false);
                  },
                  child: selectedLanguage == const Locale('en', 'US')
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 2.w),
                          color: const Color.fromARGB(255, 211, 210, 210),
                          alignment: Alignment.centerLeft,
                          child: const Text('English'),
                        )
                      : const Text('English'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    context.setLocale(const Locale('ar', 'SA'));

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreenWrapper()),
                        (route) => false);
                  },
                  child: selectedLanguage == const Locale('ar', 'SA')
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 2.w),
                          color: const Color.fromARGB(255, 211, 210, 210),
                          alignment: Alignment.centerLeft,
                          child: const Text('عربي'),
                        )
                      : const Text('عربي'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    context.setLocale(const Locale('tr', 'CY'));

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreenWrapper()),
                        (route) => false);
                  },
                  child: selectedLanguage == const Locale('tr', 'CY')
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 2.w),
                          color: const Color.fromARGB(255, 211, 210, 210),
                          alignment: Alignment.centerLeft,
                          child: const Text('Türkçe'))
                      : const Text('Türkçe'),
                ),
              ],
            );
          });
    }

    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (BuildContext context, Box userBox, Widget? child) {
          // final bool isPremium = userBox.get(AppHSC.premium);
          return ValueListenableBuilder(
              valueListenable: Hive.box(AppHSC.authBox).listenable(),
              builder: (BuildContext context, Box authbox, Widget? child) {
                return Column(
                  children: [
                    AppSpacerH(60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          authbox.get(AppHSC.authToken) != null
                              ? SizedBox(
                                  height: 64.h,
                                  width: 64.h,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(32.h),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                userBox.get(AppHSC.thumbnail),
                                            height: 64.h,
                                            width: 64.h,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Center(
                                                    child: Icon(Icons.error)),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.h),
                                            border: Border.all(
                                                color: AppColors.white,
                                                width: 1.w)),
                                        height: 64.h,
                                        width: 64.h,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            showProfilePictureDialuge(context);
                                          },
                                          child: Container(
                                            height: 24.h,
                                            width: 24.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.h),
                                                color: AppColors.white),
                                            child: Center(
                                                child: Icon(
                                              Icons.camera_alt,
                                              color: AppColors.black,
                                              size: 18.h,
                                            )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                              : SizedBox(
                                  height: 64.h,
                                  width: 64.h,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(32.h),
                                          child: Icon(
                                            Icons.person,
                                            size: 64.h,
                                            color: AppColors.white,
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32.h),
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 1.w,
                                          ),
                                        ),
                                        height: 64.h,
                                        width: 64.h,
                                      ),
                                      //
                                    ],
                                  ),
                                ),
                          AppSpacerW(16.w),
                          authbox.get(AppHSC.authToken) != null
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${userBox.get(AppHSC.firstName)}",
                                        style: AppTextDecor.bold18White,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${userBox.get(AppHSC.email)}",
                                            style:
                                                AppTextDecor.regular14DarkGreen,
                                          ),
                                          AppSpacerW(8.w),
                                          Container(
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.h),
                                                color: userBox.get(
                                                            AppHSC.verified) ==
                                                        true
                                                    ? AppColors.pureGreen
                                                    : AppColors.darkGreen),
                                            child: userBox
                                                        .get(AppHSC.verified) ==
                                                    true
                                                ? Text(
                                                    "Verified",
                                                    style: AppTextDecor
                                                        .regular14DarkTeal,
                                                  )
                                                : ref
                                                    .watch(
                                                        verificationMailProvider)
                                                    .map(
                                                      initial: (_) =>
                                                          GestureDetector(
                                                        onTap: () {
                                                          ref
                                                              .watch(
                                                                  verificationMailProvider
                                                                      .notifier)
                                                              .verificationMail();
                                                        },
                                                        child: Text(
                                                          'profile_screen.send_mail'
                                                              .tr(),
                                                        ),
                                                      ),
                                                      loading: (_) =>
                                                          const LoadingWidget(),
                                                      loaded: (_) {
                                                        return Text(
                                                          'profile_screen.send_code'
                                                              .tr(),
                                                        );
                                                      },
                                                      error: (_) =>
                                                          const ErrorTextWidget(
                                                              error: 'Error'),
                                                    ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    context.nav.pushNamed(Routes.loginScreen);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: AppColors.white,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
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
                        ],
                      ),
                    ),
                    const AppSpacerH(17),
                    const HorizontalDivider(color: AppColors.darkGreen),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          AppSpacerH(38.h),
                          // ProfileTabWidget(
                          //   svgPath: "assets/svgs/icon_download.svg",
                          //   title: "My Downloads",
                          //   onTap: () {
                          //     context.nav.pushNamed(Routes.downLoadScreen);
                          //   },
                          // ),
                          userBox.get(AppHSC.premium) == false
                              ? ProfileTabWidget(
                                  svgPath: "assets/svgs/icon_star.svg",
                                  title: "My Subscription",
                                  onTap: () {
                                    context.nav.pushNamed(Routes.mySubScreen);
                                  },
                                )
                              : const SizedBox(),

                          GestureDetector(
                            onTap: () async {
                              await _showSimpleDialog();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                children: [
                                  // SvgPicture.asset(
                                  //   svgPath,
                                  //   height: 18.h,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  const Icon(
                                    Icons.language,
                                    color: AppColors.buttonBorder,
                                  ),
                                  AppSpacerW(11.w),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "profile_screen.change_lang"
                                              .tr(args: [':']),
                                          style: AppTextDecor.regular14White,
                                        ),
                                        Text(
                                          selectedLanguage ==
                                                  const Locale('tr', 'CY')
                                              ? "Türkçe"
                                              : selectedLanguage ==
                                                      const Locale('ar', 'SA')
                                                  ? "عربي"
                                                  : "English",
                                          style: AppTextDecor.regular14White,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ProfileTabWidget(
                            svgPath: "assets/svgs/icon_share.svg",
                            title: "profile_screen.invite_friend".tr(),
                            onTap: () {
                              Share.share(
                                  'https://play.google.com/store/apps/details?id=com.maditam');
                            },
                          ),
                          ProfileTabWidget(
                            svgPath: "assets/svgs/icon_privacy_policy.svg",
                            title: "profile_screen.privacy_policy".tr(),
                            onTap: () {
                              context.nav.pushNamed(Routes.privacyPolicy);
                            },
                          ),
                          ProfileTabWidget(
                            svgPath: "assets/svgs/icon_contact_us.svg",
                            title: "profile_screen.contact_us".tr(),
                            onTap: () {
                              context.nav.pushNamed(Routes.contactUs);
                            },
                          ),
                          authbox.get(AppHSC.authToken) != null
                              ? ProfileTabWidget(
                                  svgPath: "assets/svgs/icon_change_pass.svg",
                                  title: "profile_screen.change_pass".tr(),
                                  onTap: () {
                                    context.nav.pushNamed(Routes.changePass);
                                  },
                                )
                              : const SizedBox(),
                          authbox.get(AppHSC.authToken) != null
                              ? ProfileTabWidget(
                                  svgPath:
                                      "assets/svgs/icon_delete_account.svg",
                                  title: "profile_screen.delete_acc".tr(),
                                  onTap: () {
                                    showDeleteDialouge(context);
                                  },
                                )
                              : const SizedBox(),
                          authbox.get(AppHSC.authToken) != null
                              ? ProfileTabWidget(
                                  svgPath: "assets/svgs/icon_logout.svg",
                                  title: "profile_screen.log_out".tr(),
                                  onTap: () {
                                    showLogoutDialouge(context);
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                );
              });
        });
  }
}

class ProfileTabWidget extends StatelessWidget {
  const ProfileTabWidget({
    Key? key,
    required this.svgPath,
    required this.title,
    this.onTap,
  }) : super(key: key);
  final String svgPath;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              height: 18.h,
              fit: BoxFit.cover,
            ),
            AppSpacerW(11.w),
            Expanded(
                child: Text(
              title,
              style: AppTextDecor.regular14White,
            ))
          ],
        ),
      ),
    );
  }
}
