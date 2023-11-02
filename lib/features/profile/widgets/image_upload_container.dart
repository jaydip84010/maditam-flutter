import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medyo/config/app_colors.dart';

class ImageUploadContainer extends StatefulWidget {
  const ImageUploadContainer({
    Key? key,
    this.ontap,
    this.file,
    this.onDelaytap,
  }) : super(key: key);
  final Function()? ontap;
  final Function()? onDelaytap;
  final File? file;

  @override
  State<ImageUploadContainer> createState() => _ImageUploadContainerState();
}

class _ImageUploadContainerState extends State<ImageUploadContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.file != null ? () {} : widget.ontap,
      child: Stack(children: [
        Container(
            height: 80.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: widget.file != null
                      ? AppColors.darkTeal
                      : AppColors.white),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  widget.file!,
                  fit: BoxFit.cover,
                ))),
        widget.file != null
            ? Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: widget.onDelaytap,
                  child: Container(
                    height: 25.h,
                    width: 98.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.black.withOpacity(0.45),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/svgs/deleteIcon.svg'),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ]),
    );
  }
}
