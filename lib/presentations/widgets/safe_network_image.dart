import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class SafeNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  const SafeNetworkImage({
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
  State<SafeNetworkImage> createState() => _SafeNetworkImageState();
}

class _SafeNetworkImageState extends State<SafeNetworkImage> {
  bool _hasError = false;
  String? _lastImageUrl;

  @override
  void didUpdateWidget(SafeNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset error state if the URL changes
    if (oldWidget.imageUrl != widget.imageUrl) {
      _hasError = false;
      _lastImageUrl = widget.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have an error or the same URL caused an error before, show the error widget directly
    if (_hasError || (widget.imageUrl == _lastImageUrl && _hasError)) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          border: widget.border,
          color: Colors.grey.withOpacity(0.6),
          borderRadius: widget.borderRadius,
          shape: widget.boxShape,
        ),
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.borderRadius,
          shape: widget.boxShape,
          color: widget.backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: widget.fit,
            colorFilter: widget.colorFilter,
          ),
        ),
        child: widget.child,
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey.withOpacity(0.3),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            border: widget.border,
            color: Colors.grey.withOpacity(0.6),
            borderRadius: widget.borderRadius,
            shape: widget.boxShape,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        // Set error state to prevent repeated attempts with same problematic URL
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _lastImageUrl = url;
            });
          }
        });
        
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            border: widget.border,
            color: Colors.grey.withOpacity(0.6),
            borderRadius: widget.borderRadius,
            shape: widget.boxShape,
          ),
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
          ),
        );
      },
      errorListener: (error) {
        debugPrint('SafeNetworkImage error: $error');
      },
      httpHeaders: const {},
      maxHeightDiskCache: 1000,
      maxWidthDiskCache: 1000,
    );
  }
}