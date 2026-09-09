import 'package:flutter/material.dart';

import '../../../config/config.dart';

class LoadingWidget extends StatelessWidget {
  final Color backgroundColor;

  const LoadingWidget({super.key, this.backgroundColor = colorWhite});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style: TextStyle(
                fontFamily: fontFamilyMain,
                color: colorLightGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 8),
            CircularProgressIndicator(
              color: colorLightGrey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
