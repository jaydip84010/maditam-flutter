import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/services/audio_service.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/global_function.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';

showProfilePictureDialuge(BuildContext context) {
  File? file;
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: file != null ? 320.h : 260.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.darkTeal,
                    ),
                    child: Column(
                      children: [
                        AppSpacerH(20.h),
                        Center(
                          child: Stack(children: [
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors.black, width: 1.h)),
                              child: file == null
                                  ? Center(
                                      child: SvgPicture.asset(
                                        "assets/svgs/thumbnail.svg",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        file!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            if (file != null)
                              Positioned(
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        file = null;
                                      });
                                    },
                                    child: Container(
                                      height: 25.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color:
                                            AppColors.white.withOpacity(0.45),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/svgs/deleteIcon.svg',
                                          color: AppColors.darkTeal,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ))
                          ]),
                        ),
                        if (file != null) ...[
                          AppSpacerH(12.h),
                          ref.watch(changePhotoProvider).map(
                              initial: (_) => AppTextButton(
                                    width: 120.w,
                                    height: 40.h,
                                    title: 'Update',
                                    onTap: () {
                                      if (file != null) {
                                        ref
                                            .watch(changePhotoProvider.notifier)
                                            .changeProfilePhoto(file: file!);
                                      } else {
                                        EasyLoading.showError('Select a photo');
                                      }
                                    },
                                  ),
                              loading: (_) => const LoadingWidget(),
                              loaded: (_) {
                                Future.delayed(50.milisec).then((value) {
                                  context.nav.pop();
                                  ref.invalidate(changePhotoProvider);
                                  final _ = ref.refresh(userProvider);
                                });
                                return const AppTextButton(
                                  title: 'Success',
                                );
                              },
                              error: (_) {
                                Future.delayed(50.milisec).then((value) {
                                  ref.invalidate(changePhotoProvider);
                                });

                                return AppTextButton(
                                  title: _.error,
                                  buttonColor: AppColors.red,
                                  titleColor: AppColors.white,
                                );
                              }),
                        ],
                        AppSpacerH(32.h),
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(
                                () {
                                  file = File(image.path);
                                },
                              );
                            }
                          },
                          child: Text(
                            "Upload from Gallery",
                            style: AppTextDecor.regular14White,
                          ),
                        ),
                        AppSpacerH(12.h),
                        Divider(
                          color: AppColors.white,
                          height: 2.h,
                        ),
                        AppSpacerH(12.h),
                        GestureDetector(
                          onTap: () async {
                            {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (image != null) {
                                setState(
                                  () {
                                    file = File(image.path);
                                  },
                                );
                              }
                            }
                          },
                          child: Text("Take from Camera",
                              style: AppTextDecor.regular14White),
                        ),
                        AppSpacerH(12.h),
                        Divider(
                          color: AppColors.white,
                          height: 2.h,
                        ),
                        AppSpacerH(12.h),
                        GestureDetector(
                          onTap: () {
                            context.nav.pop();
                          },
                          child: Text(
                            "Cancel",
                            style: AppTextDecor.regular14White,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

showPremiumDialouge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkTeal,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(16.h),
              width: 340.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Go Premium',
                    style: AppTextDecor.bold24White
                        .copyWith(color: const Color(0xffD6AF30)),
                  ),
                  AppSpacerH(16.h),
                  Text(
                    'Enjoy 120+ premium meditation tracks with an easy upgrade.',
                    style: AppTextDecor.regular16White,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacerH(32.h),
                  AppTextButton(
                    title: 'Get Premium',
                    onTap: () {
                      context.nav.pop();
                      context.nav.pushNamed(Routes.premiumSubScreen);
                    },
                  ),
                ],
              ),
            ),
          )));
}

showLogoutDialouge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkTeal,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(16.h),
              width: 340.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "LogOut",
                    style: AppTextDecor.bold24White
                        .copyWith(color: const Color(0xffD6AF30)),
                  ),
                  AppSpacerH(16.h),
                  Text(
                    'You are About to Log Out',
                    style: AppTextDecor.regular16White,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacerH(32.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextButton(
                          buttonColor: AppColors.gray,
                          title: 'Cancel',
                          onTap: () {
                            context.nav.pop();
                          },
                        ),
                      ),
                      AppSpacerW(10.w),
                      Expanded(
                        child: Consumer(builder: (context, ref, child) {
                          return ref.watch(logoutProvider).map(
                              initial: (_) => AppTextButton(
                                    buttonColor: AppColors.red,
                                    title: 'Log Out',
                                    onTap: () {
                                      ref.watch(audioServiceProvider)?.stop();
                                      ref
                                          .watch(logoutProvider.notifier)
                                          .logOut();
                                    },
                                  ),
                              loading: (_) => const LoadingWidget(),
                              loaded: (_) {
                                final Box authBox = Hive.box(
                                  AppHSC.authBox,
                                );
                                final Box userBox = Hive.box(
                                  AppHSC.userBox,
                                );
                                Future.delayed(50.milisec).then((value) {
                                  authBox.clear();
                                  userBox.clear();

                                  ref.invalidate(logoutProvider);

                                  ref.refresh(categoriessProvider);
                                  ref.refresh(
                                      dashboardcategoryalbumListProvider(
                                          AppGLF.getTimeOfDay().toLowerCase()));
                                  ref.refresh(
                                      dashboardcategoryalbumListProvider(
                                          'Most-Recomanded'));

                                  context.nav.pushNamedAndRemoveUntil(
                                      Routes.homeScreen, (route) => false);
                                });
                                return const MessageTextWidget(msg: "Success");
                              },
                              error: (_) {
                                Future.delayed(100.milisec).then((e) {
                                  ref.invalidate(logoutProvider);
                                });
                                return ErrorTextWidget(error: _.error);
                              });
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
}

showDeleteDialouge(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkTeal,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(16.h),
              width: 340.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delete Account",
                    style: AppTextDecor.bold24White
                        .copyWith(color: const Color(0xffD6AF30)),
                  ),
                  AppSpacerH(16.h),
                  Text(
                    'You are about to Delete your Account!',
                    style: AppTextDecor.regular16White,
                    textAlign: TextAlign.center,
                  ),
                  AppSpacerH(32.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextButton(
                          buttonColor: AppColors.gray,
                          title: 'Cancel',
                          onTap: () {
                            context.nav.pop();
                          },
                        ),
                      ),
                      AppSpacerW(10.w),
                      Expanded(
                        child: AppTextButton(
                          buttonColor: AppColors.red,
                          title: 'Delete',
                          onTap: () {
                            context.nav.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
}
