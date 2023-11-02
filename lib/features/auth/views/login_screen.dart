import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/hive_contants.dart';
import 'package:medyo/config/input_field_decorations.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/auth/views/auth_screen_wrapper.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';

import '../../../utils/global_function.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  bool obsecureText = true;
  final Box loginBox = Hive.box(
    AppHSC.loginInfoBox,
  );
  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: FormBuilder(
        key: _formkey,
        child: ListView(
          children: [
            AppSpacerH(59.h),
            GestureDetector(
              onDoubleTap: () {
                debugPrint(loginBox.toMap().toString());
                _formkey.currentState?.patchValue({
                  'email': loginBox.get('email'),
                  'password': loginBox.get('password')
                });
              },
              child: SizedBox(
                height: 61.h,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    "assets/images/app_logo_white_with_text.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            AppSpacerH(40.h),
            Text(
              "login_screen.sign_in".tr(),
              style: AppTextDecor.bold24White,
            ),
            AppSpacerH(12.h),
            Text(
              "login_screen.sign_in_text".tr(),
              style: AppTextDecor.regular18DarkGreen,
            ),
            AppSpacerH(56.h),
            FormBuilderTextField(
              name: "email",
              decoration: AppInputDecor.dgBordered.copyWith(
                labelText: "signup_screen.email".tr(),
                hintText: "signup_screen.hint_email".tr(),
              ),
              style: AppTextDecor.regular18White,
              validator: FormBuilderValidators.required(),
            ),
            AppSpacerH(24.h),
            FormBuilderTextField(
              name: "password",
              decoration: AppInputDecor.dgBordered.copyWith(
                labelText: "signup_screen.password".tr(),
                hintText: "signup_screen.hint_pass".tr(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obsecureText = !obsecureText;
                    });
                  },
                  child: Icon(
                    obsecureText
                        ? Icons.visibility
                        : Icons.visibility_off_outlined,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              style: AppTextDecor.regular18White,
              obscureText: obsecureText,
              validator: FormBuilderValidators.required(),
            ),
            AppSpacerH(24.h),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    context.nav.pushNamed(Routes.resetPassPhaseOneScreen);
                  },
                  child: Text(
                    "login_screen.forgot_pass".tr(),
                    style: AppTextDecor.regular14White
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            AppSpacerH(40.h),
            ref.watch(loginProvider).map(initial: (_) {
              return AppTextButton(
                title: "login_screen.login".tr(),
                onTap: () {
                  if (_formkey.currentState!.saveAndValidate()) {
                    final formValue = _formkey.currentState!.value;

                    loginBox.putAll(formValue);

                    ref.watch(loginProvider.notifier).login(
                        email: formValue["email"],
                        password: formValue["password"]);
                  }
                },
              );
            }, error: (_) {
              Future.delayed(2000.milisec).then((e) {
                ref.invalidate(loginProvider);
              });
              return AppTextButton(title: _.error);
            }, loading: (_) {
              return const LoadingWidget();
            }, loaded: (_) {
              Future.delayed(50.milisec).then((e) {
                final Box authBox = Hive.box(
                  AppHSC.authBox,
                ); //Stores Auth Data
                final Box userBox = Hive.box(
                  AppHSC.userBox,
                );
                authBox.putAll(_.data.data!.access!.toMap());
                userBox.putAll(_.data.data!.user!.toMap());
                ref.invalidate(loginProvider);
                ref.invalidate(loginProvider);
                ref.refresh(categoriessProvider);
                ref.refresh(dashboardcategoryalbumListProvider(
                    AppGLF.getTimeOfDay().toLowerCase()));
                ref.refresh(
                    dashboardcategoryalbumListProvider('Most-Recomanded'));
                context.nav.pushNamedAndRemoveUntil(
                    Routes.homeScreen, (route) => false);
              });
              return const AppTextButton(
                title: "Success",
              );
            }),
            const AppSpacerH(20),
            // AppTextButton(
            //   title: "Facebook Login",
            //   onTap: () async {
            //     final LoginResult result = await FacebookAuth.instance.login(
            //       permissions: [
            //         'email',
            //       ],
            //     );
            //
            //     if (result.status == LoginStatus.success) {
            //       // you are logged
            //       final AccessToken accessToken = result.accessToken!;
            //       EasyLoading.showSuccess(accessToken.token);
            //     } else {
            //       EasyLoading.showError(result.message ?? 'Tupid Error');
            //     }
            //   },
            // ),
            AppSpacerH(120.h),
            Center(
              child: GestureDetector(
                  onTap: () {
                    context.nav.pushNamedAndRemoveUntil(
                        Routes.signUpScreen, (route) => false);
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "login_screen.dont_have_acc".tr(),
                      style: AppTextDecor.regular16White,
                    ),
                    TextSpan(
                      text: "signup_screen.sign_up".tr(),
                      style: AppTextDecor.regular16White
                          .copyWith(decoration: TextDecoration.underline),
                    ),
                  ]))),
            ),
          ],
        ),
      ),
    ));
  }
}
