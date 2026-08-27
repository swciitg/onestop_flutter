import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/events/utils/event_formatters.dart';
import 'package:onestop_ui/index.dart';
import 'package:shimmer/shimmer.dart';

/// High-performance network image widget for Events.
///
/// Features:
/// - Fast caching via [CachedNetworkImage] with memory size constraints.
/// - Themed shimmer placeholder while loading.
/// - Clean fallback placeholder when URL is null, empty, or invalid.
class EventNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final BoxFit fit;

  const EventNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
    this.isCircular = false,
    this.fit = BoxFit.cover,
  });

  const EventNetworkImage.banner({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.fit = BoxFit.cover,
  })  : width = null,
        height = null,
        isCircular = false;

  const EventNetworkImage.avatar({
    super.key,
    required this.imageUrl,
    this.width = 48,
    this.height = 48,
    this.borderRadius,
    this.fit = BoxFit.cover,
  })  : aspectRatio = null,
        isCircular = true;

  @override
  Widget build(BuildContext context) {
    final isValid = EventFormatters.isValidImageUrl(imageUrl);

    Widget imageWidget;
    if (isValid) {
      final cacheWidth = width != null ? (width! * 2).toInt() : (isCircular ? 96 : 600);
      final cacheHeight = height != null ? (height! * 2).toInt() : (isCircular ? 96 : null);

      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!.trim(),
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, __) => _buildShimmerPlaceholder(),
        errorWidget: (_, __, ___) => _buildFallbackPlaceholder(),
      );
    } else {
      imageWidget = _buildFallbackPlaceholder();
    }

    if (isCircular) {
      return ClipOval(child: SizedBox(width: width, height: height, child: imageWidget));
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: OColor.gray200,
      highlightColor: OColor.gray100,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        color: OColor.white,
      ),
    );
  }

  Widget _buildFallbackPlaceholder() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: OColor.gray200,
      child: Center(
        child: Icon(
          isCircular ? FluentIcons.calendar_24_regular : FluentIcons.image_24_regular,
          size: isCircular ? 24 : 40,
          color: OColor.gray400,
        ),
      ),
    );
  }
}
