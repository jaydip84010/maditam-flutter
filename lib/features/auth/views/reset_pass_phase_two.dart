import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/auth/views/auth_screen_wrapper.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class ResetPassPhaseTwoScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  final String forEmailorPhone;

  ResetPassPhaseTwoScreen({super.key, required this.forEmailorPhone});

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 812.h,
          width: 375.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegularAppBar(
                title: "Enter OTP",
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(24.h),
                      Text(
                        'Enter OTP',
                        style: AppTextDecor.bold24White,
                      ),
                      AppSpacerH(5.h),
                      Text(
                        'An 6 digit code has been sent to $forEmailorPhone',
                        style: AppTextDecor.regular18White,
                      ),
                      AppSpacerH(44.h),
                      Expanded(
                        child: Column(
                          children: [
                            AppSpacerH(33.h),
                            Form(
                              key: formKey,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                hintCharacter: '_',
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  debugPrint(v);
                                  return null;
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(3.w),
                                  fieldHeight: 50.w,
                                  fieldWidth: 50.w,
                                  inactiveFillColor: AppColors.white,
                                  activeFillColor: AppColors.white,
                                  activeColor: AppColors.white,
                                  errorBorderColor: AppColors.white,
                                  inactiveColor: AppColors.white,
                                ),
                                cursorColor: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                textStyle: AppTextDecor.bold18White,
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                onChanged: (String value) {
                                  debugPrint("Changed : $value");
                                },
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final int time =
                                    ref.watch(forgotPassTimeProvider);
                                return SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (time > 0)
                                        Text(
                                          'OTP will send within 00 : ${time > 9 ? time : '0$time'}',
                                          style: AppTextDecor.regular14White,
                                        )
                                      else
                                        const SizedBox(),
                                      if (time <= 0)
                                        ref.watch(sendOtpMailProvider).maybeMap(
                                              orElse: () {
                                                return const SizedBox();
                                              },
                                              initial: (_) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    await ref
                                                        .watch(
                                                          sendOtpMailProvider
                                                              .notifier,
                                                        )
                                                        .sendOtpToMail(
                                                          email:
                                                              forEmailorPhone,
                                                        );

                                                    ref
                                                        .watch(
                                                            sendOtpMailProvider)
                                                        .maybeWhen(
                                                          orElse: () {},
                                                          loaded: (_) {
                                                            ref
                                                                .watch(
                                                                  forgotPassTimeProvider
                                                                      .notifier,
                                                                )
                                                                .startTimer();
                                                          },
                                                        );
                                                  },
                                                  child: Text(
                                                    'Resend OTP',
                                                    style: AppTextDecor
                                                        .bold14White,
                                                  ),
                                                );
                                              },
                                              loading: (_) => SizedBox(
                                                height: 10.h,
                                                width: 10.w,
                                                child: const LoadingWidget(),
                                              ),
                                              error: (_) {
                                                return const SizedBox();
                                              },
                                            )
                                      else
                                        const SizedBox()
                                    ],
                                  ),
                                );
                              },
                            ),
                            AppSpacerH(129.h),
                            SizedBox(
                              height: 50.h,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return ref.watch(verifyOtpProvider).map(
                                    error: (_) {
                                      Future.delayed(2000.milisec)
                                          .then((value) {
                                        // ignore: unused_result
                                        ref.refresh(verifyOtpProvider);
                                      });
                                      return ErrorTextWidget(error: _.error);
                                    },
                                    loaded: (_) {
                                      Future.delayed(50.milisec).then((value) {
                                        // ignore: unused_result
                                        ref.refresh(
                                          verifyOtpProvider,
                                        );
                                        if (_.data['data']['reset_token'] !=
                                            null) {
                                          Future.delayed(50.milisec)
                                              .then((value) {
                                            context.nav.pushNamed(
                                              Routes.resetPassPhaseThreeScreen,
                                              arguments: _.data['data']
                                                  ['reset_token'],
                                            );
                                          });
                                        }
                                      });
                                      return const MessageTextWidget(
                                        msg: 'Success',
                                      );
                                    },
                                    initial: (_) {
                                      return AppTextButton(
                                        title: 'Verify OTP',
                                        titleColor: AppColors.white,
                                        onTap: () {
                                          debugPrint(
                                              textEditingController.text);
                                          ref
                                              .watch(
                                                verifyOtpProvider.notifier,
                                              )
                                              .verifyOtp(
                                                email: forEmailorPhone,
                                                otp: textEditingController.text,
                                              );
                                        },
                                      );
                                    },
                                    loading: (_) {
                                      return const LoadingWidget();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
