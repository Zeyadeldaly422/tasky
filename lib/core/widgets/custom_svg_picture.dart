import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgPicture extends StatelessWidget {
  const CustomSvgPicture({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.withcolorfilter = true,
  });
  //named constructor
  const CustomSvgPicture.withoutcolor({
    super.key,
    required this.path,
    this.height,
    this.width,
  }) : withcolorfilter = false;

  final String path;
  final bool withcolorfilter;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      colorFilter: withcolorfilter
          ? ColorFilter.mode(
              Theme.of(context).colorScheme.secondary,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}
