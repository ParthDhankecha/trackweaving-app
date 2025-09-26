import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowSvg extends StatelessWidget {
  final String assetName;
  final String semanticsLabel;
  final double height;
  final double width;
  final BoxFit fit;
  const ShowSvg({
    super.key,
    required this.assetName,
    this.semanticsLabel = '',
    required this.height,
    required this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svgs/$assetName.svg',
      semanticsLabel: semanticsLabel,
      fit: fit,
      height: height,
      width: width,
    );
  }
}
