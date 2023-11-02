import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medyo/config/app_colors.dart';
import 'package:medyo/features/core/logic/core_provider.dart';
import 'package:medyo/utils/context_less_nav.dart';

class MusicDetaisScreen extends ConsumerStatefulWidget {
  const MusicDetaisScreen(
      {required this.musicId, required this.thumbnailUrl, super.key});
  final String musicId;
  final String thumbnailUrl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MusicDetaisScreenState();
}

class _MusicDetaisScreenState extends ConsumerState<MusicDetaisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(musicDetaislProvider(widget.musicId)).map(
            initial: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_) {
              Future.delayed(50.milisec, () {
                ref.invalidate(musicDetaislProvider(widget.musicId));
                EasyLoading.showError(_.error.toString());
              });
              return Center(
                child: Text(_.error.toString()),
              );
            },
            loaded: (_) {
              return NestedScrollView(
                headerSliverBuilder: (ctx, innerBoxScroll) {
                  return [
                    SliverAppBar(
                      expandedHeight: 0.3.sh,
                      pinned: true,
                      backgroundColor: AppColors.darkTeal,
                      flexibleSpace: FlexibleSpaceBar(
                        // centerTitle: true,
                        background: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(widget.thumbnailUrl),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(
                                    0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          _.data.data!.readmore!.title.toString(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18.sp,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: EdgeInsets.all(10.0.h),
                  child: Html(
                    style: {
                      '*': Style(
                        color: AppColors.black,
                        fontSize: FontSize(14.sp),
                        fontFamily: 'Open Sans',
                      )
                    },
                    data: _.data.data!.readmore!.content,
                  ),
                ),
              );
            },
          ),
    );
  }
}
