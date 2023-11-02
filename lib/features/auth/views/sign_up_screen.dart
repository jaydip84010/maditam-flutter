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
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  bool obsecureText = true;
  bool savePass = false;
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
            SizedBox(
              height: 61.h,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/app_logo_white_with_text.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            AppSpacerH(40.h),
            Text(
              "signup_screen.sign_up".tr(),
              style: AppTextDecor.bold24White,
            ),
            AppSpacerH(12.h),
            Text(
              "signup_screen.sign_up_text".tr(),
              style: AppTextDecor.regular18DarkGreen,
            ),
            AppSpacerH(56.h),
            FormBuilderTextField(
              name: "name",
              decoration: AppInputDecor.dgBordered.copyWith(
                labelText: "signup_screen.full_name".tr(),
                hintText: "signup_screen.hint_name".tr(),
              ),
              style: AppTextDecor.regular18White,
              validator: FormBuilderValidators.required(),
            ),
            AppSpacerH(24.h),
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
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(4),
              ]),
            ),
            AppSpacerH(40.h),
            ref.watch(registerProvider).map(initial: (_) {
              return AppTextButton(
                title: "signup_screen.sign_up".tr(),
                onTap: () {
                  if (_formkey.currentState!.saveAndValidate()) {
                    final formValue = _formkey.currentState!.value;

                    ref.watch(registerProvider.notifier).register(
                        name: formValue["name"],
                        email: formValue["email"],
                        password: formValue["password"]);
                  }
                },
              );
            }, error: (_) {
              Future.delayed(50.milisec).then((e) {
                ref.invalidate(registerProvider);
              });
              Future.delayed(50.milisec).then((e) {
                EasyLoading.showError(_.error.toString());
              });
              return ErrorTextWidget(error: _.error);
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
                ref.invalidate(registerProvider);
                context.nav.pushNamedAndRemoveUntil(
                    Routes.homeScreen, (route) => false);
              });
              return const AppTextButton(
                title: "Success",
              );
            }),
            AppSpacerH(100.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  context.nav.pushNamedAndRemoveUntil(
                      Routes.loginScreen, (route) => false);
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "signup_screen.already_have_acc".tr(),
                        style: AppTextDecor.regular16White,
                      ),
                      TextSpan(
                        text: "login_screen.sign_in".tr(),
                        style: AppTextDecor.regular16White
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
