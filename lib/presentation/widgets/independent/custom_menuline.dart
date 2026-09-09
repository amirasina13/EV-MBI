import 'package:flutter/material.dart';

import '../../../config/config.dart';
import 'independent.dart';

/* Widget class for custom listTile. Will use in features/settings/view/settings_view.dart.  */
class CustomMenuLine extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback onTap;
  final double? fontTitle;
  final FontWeight? fontWeight;
  final Widget? trailing;

  const CustomMenuLine({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
    this.fontTitle = 13,
    this.fontWeight = FontWeight.w300,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorTransparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: colorTransparent,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: icon != null
                ? Container(
                    width: ScreenSize.height * 0.04,
                    padding: EdgeInsets.all(5),
                    child: icon,
                  )
                : null,
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: fontTitle,
                fontFamily: fontFamilyMain,
                fontWeight: fontWeight,
              ),
            ),
            trailing:
                trailing ??
                Icon(Icons.chevron_right, color: colorGreenGradient),
          ),
        ),
      ),
    );
  }
}
