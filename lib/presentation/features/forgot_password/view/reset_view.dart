import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance.dart';
import '../../otp/otp.dart';
import '../forgot_password.dart';

class ResetPasswordView extends StatefulWidget {
  final Function changeView;
  final String email;
  final String vToken;

  const ResetPasswordView({
    super.key,
    required this.changeView,
    required this.email,
    required this.vToken,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  String errorfield = '',
      otpCode = '',
      errorTextPwd = '',
      errorTextCfmPwd = '',
      errorTextMissMatch = '',
      reqEmail = '',
      resendvToken = '',
      tokenVerify = '';
  bool error = false, enableResend = true;
  bool isProcessing = false;

  late FocusNode pwFocus, confirmPwFocus;

  final focusNode = FocusNode();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<CustomInputFieldState> newPasswordKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> confirmPasswordKey = GlobalKey();
  final pinController = TextEditingController();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    pwFocus = FocusNode();
    confirmPwFocus = FocusNode();

    reqEmail = widget.email;
    resendvToken = widget.vToken;
    _requestOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
          selectionHandleColor: colorDarkGray,
        ),
      ),
      child: BlocConsumer<ForgotPassBloc, ForgotPassState>(
        listener: (context, state) {
          // on success delete navigator stack and push to home
          if (state is ForgotPassOtpVerified) {
            SuccessTimerDialog.showSuccessTimerDialog(
              context,
              state.message,
              () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.login,
                  (Route<dynamic> route) => false,
                );
              },
            );
          }
          if (state is ForgotPassResent) {
            setProcessingStatus(false);
            showSuccessToast(state.data['message'], context);
          }
          // on failure show a snackbar
          if (state is ForgotPassError) {
            // ignore: unnecessary_null_comparison
            state.error != null ? error = true : error = false;
            setProcessingStatus(false);

            showErrorToast(state.error, context);
          }
          // maintenance mode on
          if (state is ForgotPassMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }
        },
        builder: (context, state) {
          // show loading screen while processing
          if (state is ForgotPassProcessing) {}

          if (state is ForgotPassSent) {
            reqEmail = state.data['data']['email'];
            resendvToken = state.data['data']['vToken'];
          }

          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 10,
                      horizontal: marginHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: ScreenSize.height * 0.13,
                            child: ImageConverter(
                              imagePath: 'assets/logo/app_logo.png',
                              isAssets: true,
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: RichText(
                            textScaler: TextScaler.linear(
                              context.scaleFactor(),
                            ).clamp(maxScaleFactor: 1.2),
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colorBlack,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'enter-otp'.tr()),
                                TextSpan(
                                  text: reqEmail,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: colorBlack,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          color: colorTransparent,
                          height: ScreenSize.height / 16,
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
                                borderRadius: BorderRadius.circular(10),
                                color: colorWhite,
                                border: Border.all(
                                  color: error == false
                                      ? colorGreyBox
                                      : colorRed,
                                ),
                              ),
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              otpCode = pin;
                            },
                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                              setState(() {
                                error = false;
                              });
                            },
                          ),
                        ),
                        BlocConsumer<OtpBloc, OtpState>(
                          listener: (context, state) {
                            if (state is OtpRequestSuccess) {
                              setProcessingStatus(false);
                              resendvToken = state.data['data']['vToken'];
                              tokenVerify = state.data['data']['token'];
                              showSuccessToast(state.data['message'], context);
                            }
                            if (state is OtpResent) {
                              setProcessingStatus(false);
                              resendvToken = state.data['data']['vToken'];
                              tokenVerify = state.data['data']['token'];
                              showSuccessToast(state.data['message'], context);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: Text(
                                      'change-pwd'.tr(),
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: fontFamilyMain,
                                        color: colorBlack,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: ScreenSize.height * 0.03),
                                Text(
                                  'new-pwd-title'.tr(),
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: colorBlack,
                                  ),
                                ),
                                CustomAppTextField(
                                  key: newPasswordKey,
                                  controller: newPasswordController,
                                  validator: Validator.valueExists,
                                  keyboardType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  focusNode: pwFocus,
                                  hintText: 'new-pwd-enter'.tr(),
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  bottomBorderColor: colorBlack,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        errorfield = '';
                                        newPasswordKey.currentState?.validate();
                                      });
                                    }
                                  },
                                ),
                                errorfield == 'error' ||
                                        errorfield == 'errorPwd' ||
                                        errorfield == 'errorMismatch'
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          errorfield == 'error' ||
                                                  errorfield == 'errorPwd'
                                              ? errorTextPwd
                                              : errorTextMissMatch,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: error
                                                ? colorRed
                                                : errorfield == 'error' ||
                                                      errorfield ==
                                                          'errorPwd' ||
                                                      errorfield ==
                                                          'errorMismatch'
                                                ? colorRed
                                                : colorGreyBox,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          'must-contain'.tr(),
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            fontSize: 10,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'confirm-new-title'.tr(),
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: colorBlack,
                                    ),
                                  ),
                                ),
                                CustomAppTextField(
                                  key: confirmPasswordKey,
                                  controller: confirmPasswordController,
                                  validator: Validator.valueExists,
                                  keyboardType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  focusNode: confirmPwFocus,
                                  hintText: 'confirm-new-enter'.tr(),
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  bottomBorderColor: colorBlack,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        errorfield = '';
                                        confirmPasswordKey.currentState
                                            ?.validate();
                                      });
                                    }
                                  },
                                ),
                                errorfield == 'error' ||
                                        errorfield == 'errorCfmPwd' ||
                                        errorfield == 'errorMismatch'
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          errorfield == 'error' ||
                                                  errorfield == 'errorCfmPwd'
                                              ? errorTextCfmPwd
                                              : errorTextMissMatch,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: error
                                                ? colorRed
                                                : errorfield == 'error' ||
                                                      errorfield ==
                                                          'errorCfmPwd' ||
                                                      errorfield ==
                                                          'errorMismatch'
                                                ? colorRed
                                                : colorGreyBox,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          'must-contain'.tr(),
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            fontSize: 10,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                SizedBox(height: 40),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(bottom: 15),
                                        color: colorTransparent,
                                        child: enableResend == false
                                            ? Countdown(
                                                seconds: 60,
                                                build: (_, double time) {
                                                  var duration = Duration(
                                                    seconds: time.toInt(),
                                                  );
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                      style: TextStyle(
                                                        color: colorUsedGray,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            fontFamilyMain,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                onFinished: () {},
                                              )
                                            : SizedBox(),
                                      ),
                                      enableResend == true
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                bottom: 15,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'not-receive'.tr(),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          fontFamilyMain,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  CustomButtonText(
                                                    'send-again'.tr(),
                                                    color: enableResend == true
                                                        ? colorBlack
                                                        : colorDarkGray,
                                                    fontSize: 13.0,
                                                    underline: true,
                                                    fontWeight: FontWeight.w600,
                                                    onClick:
                                                        enableResend == true
                                                        ? _resendOtp
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                      CustomStyleButton(
                                        title: isProcessing
                                            ? 'processing-btn'.tr()
                                            : 'continue-btn'.tr(),
                                        textColor: isProcessing
                                            ? processingText
                                            : colorWhite,
                                        backgroundColor: isProcessing
                                            ? processing
                                            : null,
                                        borderRadius: 30,
                                        height: ScreenSize.height * 0.055,
                                        onPressed: isProcessing
                                            ? () {}
                                            : _validateAndSend,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _requestOtp() {
    BlocProvider.of<OtpBloc>(
      context,
    ).add(OtpRequest(email: reqEmail, purpose: 'forgot', vToken: resendvToken));
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(
      OtpResend(
        email: reqEmail,
        purpose: 'resend-forgot',
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

  void _validateAndSend() {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (otpCode == '') {
      setProcessingStatus(false);
      errorfield = 'errorOtp';
      showErrorToast('Otp No are required!', context);
    } else if (newPasswordController.text == '') {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      errorTextPwd = 'password-required'.tr();
    } else if (confirmPasswordController.text == '') {
      setProcessingStatus(false);
      errorfield = 'errorCfmPwd';
      errorTextCfmPwd = 'confirm-password-required'.tr();
    } else if (Validator.passwordCorrect(newPasswordController.text) != null) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      pwFocus.requestFocus();
      errorTextMissMatch =
          'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)';
    } else if (newPasswordController.text != confirmPasswordController.text) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      confirmPwFocus.requestFocus();
      errorTextMissMatch = 'Password mismatched';
    } else {
      errorfield == '';
      setProcessingStatus(true);
      BlocProvider.of<ForgotPassBloc>(context).add(
        ForgotPassOtpSend(
          password: confirmPasswordController.text,
          otpCode: otpCode,
          verifyToken: tokenVerify,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    pwFocus.dispose();
    confirmPwFocus.dispose();
    pinController.dispose();
    focusNode.dispose();

    super.dispose();
  }
}
