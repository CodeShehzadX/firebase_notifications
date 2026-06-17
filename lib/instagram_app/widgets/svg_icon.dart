import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';

/// Renders a monochrome SVG icon and recolors it via [color].
class SvgIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color color;

  const SvgIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
