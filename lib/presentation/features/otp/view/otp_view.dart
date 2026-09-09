import 'dart:async';

import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/data_driven/register_timer_dialog.dart';
import '../../../widgets/independent/independent.dart';
import '../otp.dart';

class OtpVerifyView extends StatefulWidget {
  final Function changeView;
  final Map data;

  const OtpVerifyView({
    super.key,
    required this.changeView,
    required this.data,
  });

  @override
  State<StatefulWidget> createState() {
    return _OtpVerifyViewState();
  }
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  String otpCode = '', resendvToken = '', tokenVerify = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    resendvToken = widget.data['data']['vToken'];
    tokenVerify = widget.data['data']['token'];
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: error == false ? colorDarkGray : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<OtpBloc, OtpState>(
          listener: (context, state) {
            fToast = FToast();
            fToast.init(context);

            // on success delete navigator stack and push to home
            if (state is OtpFinished) {
              RegisterTimerDialog.showSuccessDialog(context);
            }
            if (state is OtpResent) {
              setProcessingStatus(false);
              resendvToken = state.data['data']['vToken'];
              tokenVerify = state.data['data']['token'];
              showSuccessToast(state.data['message'], context);
            }
            if (state is OtpError) {
              // ignore: unnecessary_null_comparison
              state.error != null ? error = true : error = false;
              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }
          },
          builder: (context, state) {
            // show loading screen while processing
            if (state is OtpProcessing) {
              // return Center(
              //   child: CircularProgressIndicator(color: colorDisableGrey,),
              // );
            }

            return SingleChildScrollView(
              child: Container(
                height: ScreenSize.height,
                width: ScreenSize.width,
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  ScreenSize.height * 0.05,
                  marginHorizontal,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ImageConverter(
                        imagePath: 'assets/logo/app_logo.png',
                        isAssets: true,
                        height: ScreenSize.height * 0.13,
                      ),
                    ),
                    SizedBox(height: ScreenSize.height * 0.02),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'OTP VERIFICATION',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamilyMain,
                          color: colorBlack,
                        ),
                      ),
                    ),
                    SizedBox(height: sizeBetween * 0.5),
                    Container(
                      color: colorTransparent,
                      height: ScreenSize.height / 15,
                      child: Pinput(
                        length: 6,
                        controller: pinController,
                        autofocus: true,
                        focusNode: focusNode,
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: error == false ? colorLightGrey : colorRed,
                            ),
                          ),
                        ),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          otpCode = pin;
                          _verifyOtp();
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                          setState(() {
                            error = false;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: ScreenSize.height / 6,
                      width: ScreenSize.width,
                      margin: EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.0,
                            offset: Offset(0.0, 5.0),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(15),
                      child: RichText(
                        textScaler: TextScaler.linear(
                          context.scaleFactor(),
                        ).clamp(maxScaleFactor: 1.2),
                        text: TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: colorBlack,
                            fontFamily: fontFamilyMain,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Note: \n1. A verification code has been sent to ',
                            ),
                            TextSpan(
                              text: widget.data['data']['send_to'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ' through email. \n\n2. If you did not receive the code, please check the spam filter or click on ',
                            ),
                            TextSpan(
                              text: 'Resend OTP ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: 'below.'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: sizeBetween * 0.4),
                    Container(
                      height: ScreenSize.height * 0.09,
                      width: ScreenSize.width,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 5, bottom: 15),
                      color: colorTransparent,
                      child: enableResend == false
                          ? Countdown(
                              seconds: 60,
                              build: (_, double time) {
                                var duration = Duration(seconds: time.toInt());
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
                                    '${duration.inSeconds} seconds left before enabling resend',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 16,
                                      fontFamily: fontFamilyMain,
                                    ),
                                  ),
                                );
                              },
                              onFinished: () {},
                            )
                          : CustomButtonText(
                              'Resend OTP',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: enableResend == true
                                  ? colorBlack
                                  : colorDarkGray,
                              onClick: enableResend == true ? _resendOtp : null,
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(
      OtpResend(
        email: widget.data['data']['send_to'],
        purpose: 'resend-register',
        vToken: resendvToken,
      ),
    );
    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  void _verifyOtp() {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(
      context,
    ).add(OtpVerify(otpCode: otpCode, token: tokenVerify));
  }
}
