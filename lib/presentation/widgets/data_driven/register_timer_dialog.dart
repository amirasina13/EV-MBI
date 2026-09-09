import 'dart:async';

import 'package:ev_charger/presentation/helper/helper.dart';
import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../independent/independent.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart

Timer? timerDialog;

class RegisterTimerDialog extends StatelessWidget {
  const RegisterTimerDialog({super.key});

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: colorBlack),
              iconSize: ScreenSize.height * 0.03,
              onPressed: () {
                timerDialog!.cancel();
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
                height: ScreenSize.height * 0.15,
              ),
            ),
            Container(
              height: ScreenSize.height / 3,
              margin: EdgeInsets.fromLTRB(
                marginHorizontal,
                0,
                marginHorizontal,
                20,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: ImageConverter(
                    imagePath: 'assets/image/register-success.webp',
                    isAssets: true,
                  ).imageProvider!,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(
                  context.scaleFactor(),
                ).clamp(maxScaleFactor: 1.2),
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: colorBlack,
                    fontWeight: FontWeight.w300,
                    fontFamily: fontFamilyMain,
                  ),
                  children: const [
                    TextSpan(text: 'Welcome to '),
                    TextSpan(
                      text: appName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorOrange,
                        fontFamily: fontFamilyMain,
                      ),
                    ),
                    TextSpan(text: '!'),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenSize.width * 0.03),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Your account has been successfully registered.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: colorBlack,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        timerDialog = Timer(Duration(seconds: 3), () {
          if (!context.mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainRoutes.login,
            (Route<dynamic> route) => false,
          );
        });
        // and later, before the timer goes off...
        timerDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: RegisterTimerDialog(),
        );
      },
    );
  }
}
