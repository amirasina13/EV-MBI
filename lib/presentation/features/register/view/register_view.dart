import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance.dart';
import '../../otp/otp.dart';
import '../register.dart';

class RegisterView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  const RegisterView({
    super.key,
    required this.changeView,
    required this.referralCode,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String errorfield = '',
      errorTextEmail = '',
      errorTextPwd = '',
      errorTextCfmPwd = '',
      errorTextMissMatch = '',
      otpCode = '',
      vToken = '';
  bool error = false;
  bool isProcessing = false;

  late Map reqInfo;

  late FocusNode emailFocus, pwFocus, confirmPwFocus;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final GlobalKey<CustomInputFieldState> emailKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> passwordKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> confirmPasswordKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> refferelKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    Storage().token = '';
    referralController.text = widget.referralCode.isNotEmpty
        ? widget.referralCode
        : Storage().referralCode!.isNotEmpty
        ? Storage().referralCode!
        : '';

    emailFocus = FocusNode();
    pwFocus = FocusNode();
    confirmPwFocus = FocusNode();
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
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }
          if (state is RegisterSuccess) {
            setProcessingStatus(false);

            reqInfo = state.data;
            var reqEmail = state.data['data']['email'];
            var reqVToken = state.data['data']['vToken'];
            Storage().referralCode = '';
            _requestOtp(reqEmail, reqVToken);
          }
          if (state is RegisterError) {
            // ignore: unnecessary_null_comparison
            state.error != null ? error = true : error = false;

            setProcessingStatus(false);
            showErrorToast(state.error, context);
          }
          if (state is RegisterNetworkError) {
            setProcessingStatus(false);
            showErrorToast(state.error, context);
          }
          if (state is ReferDecryptSuccess) {
            referralController.text = state.referCode;
          }
          if (state is ReferDecryptFail) {
            referralController.text = '';
            showErrorToast('Refferal code not valid.', context);
          }
        },
        builder: (context, state) {
          // show loading screen while processing
          if (state is RegisterProcessing) {
            // return Center(
            //   child: CircularProgressIndicator(color: colorDisableGrey,),
            // );
          }

          if (state is RegisterVerifySuccess) {
            emailController.text = state.data['data']['email'];
            vToken = state.data['data']['vToken'];
          }

          return BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpRequestSuccess) {
                setProcessingStatus(false);

                Navigator.of(context).pushNamed(
                  MainRoutes.otpVerify,
                  arguments: OtpVerifyParameters(data: state.data),
                );
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
              return SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
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
                                Center(
                                  child: Text(
                                    'create-acc'.tr(),
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: fontFamilyMain,
                                      color: colorBlack,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'email-title'.tr(),
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: colorBlack,
                                    ),
                                  ),
                                ),
                                CustomAppTextField(
                                  key: emailKey,
                                  controller: emailController,
                                  validator: Validator.valueExists,
                                  readOnly: true,
                                  keyboardType: TextInputType.emailAddress,
                                  focusNode: emailFocus,
                                  hintText: 'email-enter'.tr(),
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  bottomBorderColor:
                                      errorfield == 'error' ||
                                          errorfield == 'errorEmail'
                                      ? colorRed
                                      : colorBlack,

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
                                        error = false;
                                        emailKey.currentState?.validate();
                                      });
                                    }
                                  },
                                ),
                                errorfield == 'error' ||
                                        errorfield == 'errorEmail'
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          left: 15,
                                        ),
                                        child: Text(
                                          errorTextEmail,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: error
                                                ? colorRed
                                                : errorfield == 'error' ||
                                                      errorfield == 'errorEmail'
                                                ? colorRed
                                                : colorGreyBox,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(height: ScreenSize.height * 0.01),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'pwd-title'.tr(),
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: colorBlack,
                                    ),
                                  ),
                                ),
                                CustomAppTextField(
                                  key: passwordKey,
                                  controller: passwordController,
                                  focusNode: pwFocus,
                                  hintText: 'pwd-enter'.tr(),
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  // contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  isPassword: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  bottomBorderColor:
                                      errorfield == 'error' ||
                                          errorfield == 'errorPwd' ||
                                          errorfield == 'errorMismatch'
                                      ? colorRed
                                      : colorBlack,
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
                                        passwordKey.currentState?.validate();
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
                                SizedBox(height: ScreenSize.height * 0.01),
                                Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child: Text(
                                    'confirm-pwd-title'.tr(),
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
                                  focusNode: confirmPwFocus,
                                  hintText: 'confirm-pwd-enter'.tr(),
                                  hintStyle: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorBlack,
                                  ),
                                  // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  isPassword: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  bottomBorderColor:
                                      errorfield == 'error' ||
                                          errorfield == 'errorCfmPwd' ||
                                          errorfield == 'errorMismatch'
                                      ? colorRed
                                      : colorBlack,
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
                                const Spacer(),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: CustomStyleButton(
                                    title: isProcessing
                                        ? 'processing-btn'.tr()
                                        : 'next-btn'.tr(),
                                    textColor: isProcessing
                                        ? processingText
                                        : colorWhite,
                                    backgroundColor: isProcessing
                                        ? processing
                                        : null,
                                    // borderColor: isProcessing
                                    //     ? processing
                                    //     : colorGoldPerak,
                                    borderRadius: 30,
                                    height: ScreenSize.height * 0.055,
                                    onPressed: isProcessing
                                        ? () {}
                                        : _validateAndSend,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (passwordController.text.isEmpty &&
        confirmPasswordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'error';
      emailFocus.requestFocus();

      errorTextPwd = 'password-required'.tr();
      errorTextCfmPwd = 'confirm-password-required'.tr();
    } else if (passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'password-required'.tr();
    } else if (confirmPasswordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorCfmPwd';
      confirmPwFocus.requestFocus();
      errorTextCfmPwd = 'confirm-password-required'.tr();
    } else if (Validator.passwordCorrect(passwordController.text) != null) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      pwFocus.requestFocus();
      errorTextMissMatch =
          'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)';
    } else if (passwordController.text != confirmPasswordController.text) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      confirmPwFocus.requestFocus();
      errorTextMissMatch = 'Password mismatched';
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(context).add(
        RegisterPressed(
          email: emailController.text.trim(),
          password: confirmPasswordController.text.trim(),
          vToken: vToken,
        ),
      );
    }
  }

  void _requestOtp(String reqEmail, String reqVToken) {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(
      context,
    ).add(OtpRequest(email: reqEmail, purpose: 'register', vToken: reqVToken));
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();
    pwFocus.dispose();
    confirmPwFocus.dispose();

    super.dispose();
  }
}
