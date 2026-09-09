import 'package:flutter/material.dart';

import '../../../config/config.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? fontSizeTitle;
  final double? fontSizeSubtitle;
  final Widget? icon;
  final Widget? subtitleWidget;
  final VoidCallback? onTap;
  final double? fontTitle;
  final FontWeight? fontWeight;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? header;
  final Widget? footer;

  const CustomContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.fontSizeTitle = 24,
    this.fontSizeSubtitle,
    this.icon,
    this.subtitleWidget,
    this.onTap,
    this.fontTitle = 13,
    this.fontWeight = FontWeight.w600,
    this.height = 120,
    this.width,
    this.padding,
    this.margin,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    header ?? SizedBox(),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSizeTitle,
                          color: colorBlack,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child:
                          subtitleWidget ??
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: colorDarkGray),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
