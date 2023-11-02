import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';
import 'package:medyo/config/input_field_decorations.dart';
import 'package:medyo/features/auth/logic/auth_provider.dart';
import 'package:medyo/features/auth/views/auth_screen_wrapper.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:medyo/utils/routes.dart';
import 'package:medyo/widgets/buttons/full_width_button.dart';
import 'package:medyo/widgets/misc_widgets.dart';
import 'package:medyo/widgets/regular_app_bar.dart';

class ResetPassPhaseThreeScreen extends StatefulWidget {
  const ResetPassPhaseThreeScreen({super.key, required this.token});

  @override
  State<ResetPassPhaseThreeScreen> createState() =>
      _ResetPassPhaseThreeScreenState();

  final String token;
}

class _ResetPassPhaseThreeScreenState extends State<ResetPassPhaseThreeScreen> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  bool obsecureTextOne = true;
  bool obsecureTextTwo = true;

  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AuthScreenWrapper(
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formkey,
          child: SizedBox(
            height: 812.h,
            width: 375.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacerH(24.h),
                const RegularAppBar(
                  title: "Set New Password",
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create new password',
                          style: AppTextDecor.bold32White,
                        ),
                        AppSpacerH(5.h),
                        Text(
                          'Create your new password',
                          style: AppTextDecor.regular18White,
                        ),
                        AppSpacerH(44.h),
                        Expanded(
                          child: Column(
                            children: [
                              AppSpacerH(33.h),
                              FormBuilderTextField(
                                focusNode: fNodes[0],
                                name: 'password',
                                obscureText: obsecureTextOne,
                                decoration: AppInputDecor.dgBordered.copyWith(
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obsecureTextOne = !obsecureTextOne;
                                      });
                                    },
                                    child: Icon(
                                      obsecureTextOne
                                          ? Icons.visibility
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),
                                style: AppTextDecor.bold18White,
                              ),
                              AppSpacerH(33.h),
                              FormBuilderTextField(
                                focusNode: fNodes[1],
                                name: 'password2',
                                obscureText: obsecureTextTwo,
                                decoration: AppInputDecor.dgBordered.copyWith(
                                  hintText: 'Password Again',
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obsecureTextTwo = !obsecureTextTwo;
                                      });
                                    },
                                    child: Icon(
                                      obsecureTextTwo
                                          ? Icons.visibility
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),
                                style: AppTextDecor.bold18White,
                              ),
                              AppSpacerH(51.h),
                              SizedBox(
                                height: 50.h,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    return ref.watch(resetPassProvider).map(
                                      error: (_) {
                                        Future.delayed(2000.milisec)
                                            .then((value) {
                                          // ignore: unused_result
                                          ref.refresh(resetPassProvider);
                                        });
                                        return ErrorTextWidget(error: _.error);
                                      },
                                      initial: (_) {
                                        return AppTextButton(
                                          title: 'Reset Password',
                                          titleColor: AppColors.white,
                                          onTap: () {
                                            for (final element in fNodes) {
                                              if (element.hasFocus) {
                                                element.unfocus();
                                              }
                                            }

                                            if (_formkey.currentState != null &&
                                                _formkey.currentState!
                                                    .saveAndValidate()) {
                                              final formData =
                                                  _formkey.currentState!.fields;
                                              ref
                                                  .watch(
                                                    resetPassProvider.notifier,
                                                  )
                                                  .resetPass(
                                                    resetToken: widget.token,
                                                    password:
                                                        formData['password']!
                                                            .value as String,
                                                    passwordConfirmation:
                                                        formData['password2']!
                                                            .value as String,
                                                  );
                                            }
                                          },
                                        );
                                      },
                                      loaded: (_) {
                                        Future.delayed(50.milisec)
                                            .then((value) {
                                          // ignore: unused_result
                                          ref.refresh(
                                            resetPassProvider,
                                          ); //Refresh This so That App Doesn't Auto Login

                                          Future.delayed(50.milisec)
                                              .then((value) {
                                            context.nav.pushNamedAndRemoveUntil(
                                              Routes.loginScreen,
                                              (route) => false,
                                            );
                                          });
                                        });
                                        return const MessageTextWidget(
                                          msg: 'Success',
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
      ),
    );
  }
}
