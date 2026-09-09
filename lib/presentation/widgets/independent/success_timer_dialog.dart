import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import 'independent.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart
Timer? timerSuccessDialog;

class SuccessTimerDialog extends StatelessWidget {
  final String message;

  const SuccessTimerDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height,
      width: ScreenSize.width,
      padding: EdgeInsets.fromLTRB(
        marginHorizontal,
        ScreenSize.height * 0.006,
        marginHorizontal,
        0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: colorBlack),
              iconSize: ScreenSize.height * 0.03,
              onPressed: () {
                timerSuccessDialog!.cancel();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.login,
                  (Route<dynamic> route) => false,
                );
              },
            ),
            Center(
              child: ImageConverter(
                imagePath: 'assets/logo/app_logo.png',
                isAssets: true,
                height: ScreenSize.height * 0.13,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                marginHorizontal,
                50,
                marginHorizontal,
                ScreenSize.height * 0.04,
              ),
              child: Text(
                'Success',
                style: TextStyle(
                  fontFamily: fontFamilyMain,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: colorOrange,
                ),
              ),
            ),
            Container(
              height: ScreenSize.height * 0.15,
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageConverter(
                    imagePath: 'assets/icon/success_circle.png',
                    isAssets: true,
                    height: ScreenSize.height * 0.13,
                  ).imageProvider!,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessTimerDialog(
    BuildContext context,
    String message,
    final VoidCallback routes,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        timerSuccessDialog = Timer(Duration(seconds: 3), routes);
        // and later, before the timer goes off...
        timerSuccessDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: SuccessTimerDialog(message: message),
        );
      },
    );
  }
}
