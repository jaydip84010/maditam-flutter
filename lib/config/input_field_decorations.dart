import 'package:flutter/material.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/config/app_text_decor.dart';

class AppInputDecor {
  AppInputDecor._(); // This class is not meant to be instantiated.

  static InputDecoration dgBordered = InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    hintStyle: const TextStyle(color: AppColors.darkGreen, fontSize: 16),
    filled: true,
    fillColor: Colors.transparent,
    labelStyle: AppTextDecor.regular18White,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.darkGreen,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.darkGreen,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.darkGreen,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.red,
      ),
    ),
  );
}
