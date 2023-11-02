import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/input_field_decorations.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/auth/views/auth_screen_wrapper.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';

class ResetPassPhaseOneScreen extends ConsumerStatefulWidget {
  const ResetPassPhaseOneScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPassPhaseOneScreenState();
}

class _ResetPassPhaseOneScreenState
    extends ConsumerState<ResetPassPhaseOneScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext buildContext) {
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return Future.value(true);
      },
      child: AuthScreenWrapper(
          child: SingleChildScrollView(
        child: SizedBox(
          height: 844.h,
          child: Column(
            children: [
              const RegularAppBar(
                title: "Reset Password",
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacerH(24.h),
                      Text(
                        'Reset Password',
                        style: AppTextDecor.bold24White,
                      ),
                      Text(
                        'Enter your email to reset your Password',
                        style: AppTextDecor.regular14White,
                      ),
                      AppSpacerH(24.h),
                      TextFormField(
                        controller: textEditingController,
                        decoration: AppInputDecor.dgBordered.copyWith(
                          labelText: "Your Email",
                          hintText: "Email",
                        ),
                        style: AppTextDecor.regular18White,
                      ),
                      AppSpacerH(50.h),
                      ref.watch(sendOtpMailProvider).map(
                          initial: (_) => AppTextButton(
                              onTap: () {
                                if (textEditingController.text.contains('@') &&
                                    textEditingController.text.contains('.')) {
                                  ref
                                      .watch(sendOtpMailProvider.notifier)
                                      .sendOtpToMail(
                                          email: textEditingController.text);
                                }
                              },
                              title: 'Send Mail'),
                          loading: (_) => const LoadingWidget(),
                          loaded: (_) {
                            Future.delayed(50.milisec).then((val) {
                              ref.invalidate(sendOtpMailProvider);
                              context.nav.pushNamed(
                                  Routes.resetPassPhaseTwoScreen,
                                  arguments: textEditingController.text);
                            });
                            return const MessageTextWidget(msg: 'Success');
                          },
                          error: (_) {
                            Future.delayed(2000.milisec).then((val) {
                              ref.invalidate(sendOtpMailProvider);
                            });
                            return AppTextButton(
                              title: _.error,
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
