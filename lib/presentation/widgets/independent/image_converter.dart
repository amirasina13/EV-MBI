import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageConverter extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool isAssets;

  const ImageConverter({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode,
    required this.isAssets,
  });

  // Helper method to check if the path ends with a known SVG extension
  bool get isSvg => imagePath.toLowerCase().endsWith('.svg');

  /// Return ImageProvider ONLY for non-SVG images
  ImageProvider? get imageProvider {
    if (isSvg) return null;

    return isAssets ? AssetImage(imagePath) : NetworkImage(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    if (isAssets) {
      if (isSvg) {
        return SvgPicture.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      } else {
        return Image(
          image: AssetImage(imagePath),
          fit: fit,
          color: color,
          height: height,
          width: width,
          colorBlendMode: colorBlendMode,
        );
      }
    } else {
      if (isSvg) {
        return SvgPicture.network(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      } else {
        return Image(
          image: NetworkImage(imagePath),
          fit: fit,
          color: color,
          height: height,
          width: width,
          colorBlendMode: colorBlendMode,
        );
      }
    }
  }
}
