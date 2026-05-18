import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Validate URL
    if (imageUrl.isEmpty || !Uri.tryParse(imageUrl)!.isAbsolute) {
      return _buildErrorWidget();
    }

    // Decode the bitmap at (roughly) the size it's actually displayed at
    // instead of full resolution. The home feed shows dozens of thumbnails;
    // decoding each at native size is the main source of jank and memory
    // pressure. Cap the decode to the display box * devicePixelRatio so the
    // image still looks crisp but costs a fraction of the memory/CPU.
    final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2.0;
    final int? memW =
        width != null && width!.isFinite ? (width! * dpr).round() : null;
    final int? memH =
        height != null && height!.isFinite ? (height! * dpr).round() : null;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: memW,
      memCacheHeight: memH,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              shape: boxShape,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      errorListener: (error) {
        debugPrint('CachedNetworkImage error for $imageUrl: $error');
      },
      httpHeaders: const {},
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColors.backgColor20272E,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.textColor6B6B6B,
          size: 40.sp,
        ),
      ),
    );
  }
}