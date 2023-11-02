import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/input_field_decorations.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';
import 'package:medyo/widgets/screen_wrapper.dart';

class ChangePassScreen extends ConsumerStatefulWidget {
  const ChangePassScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePassScreenState();
}

class _ChangePassScreenState extends ConsumerState<ChangePassScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  bool obsecureText = true;
  bool obsecureText2 = true;
  bool obsecureText3 = true;

  @override
  Widget build(BuildContext buildContext) {
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return Future.value(true);
      },
      child: ScreenWrapper(
          child: FormBuilder(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const RegularAppBar(
                title: "Change Password",
              ),
              AppSpacerH(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: FormBuilderTextField(
                  name: "current_password",
                  decoration: AppInputDecor.dgBordered.copyWith(
                    labelText: "Old Password",
                    hintText: "Old Password",
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
              ),
              AppSpacerH(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: FormBuilderTextField(
                  name: "password",
                  decoration: AppInputDecor.dgBordered.copyWith(
                    labelText: "Create password",
                    hintText: "Create password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obsecureText2 = !obsecureText2;
                        });
                      },
                      child: Icon(
                        obsecureText2
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                  style: AppTextDecor.regular18White,
                  obscureText: obsecureText2,
                  validator: FormBuilderValidators.required(),
                ),
              ),
              AppSpacerH(24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: FormBuilderTextField(
                  name: "password_confirmation",
                  decoration: AppInputDecor.dgBordered.copyWith(
                    labelText: "Confirm new password",
                    hintText: "Confirm new password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obsecureText3 = !obsecureText3;
                        });
                      },
                      child: Icon(
                        obsecureText3
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                  style: AppTextDecor.regular18White,
                  obscureText: obsecureText3,
                  validator: FormBuilderValidators.required(),
                ),
              ),
              AppSpacerH(50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ref.watch(changePassProvider).map(
                    initial: (_) => AppTextButton(
                        onTap: () {
                          if (_formkey.currentState?.saveAndValidate() ==
                              true) {
                            ref
                                .watch(changePassProvider.notifier)
                                .changePass(data: _formkey.currentState!.value);
                          }
                        },
                        title: 'Change Password'),
                    loading: (_) => const LoadingWidget(),
                    loaded: (_) {
                      Future.delayed(50.milisec).then((val) {
                        ref.invalidate(changePassProvider);
                        context.nav.pop();
                      });
                      return const MessageTextWidget(msg: 'Success');
                    },
                    error: (_) {
                      Future.delayed(50.milisec).then((val) {
                        ref.invalidate(changePassProvider);
                      });
                      return ErrorTextWidget(error: _.error);
                    }),
              ),
              AppSpacerH(50.h)
            ],
          ),
        ),
      )),
    );
  }
}
