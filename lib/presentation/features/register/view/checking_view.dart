import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance.dart';
import '../../wrapper.dart';
import '../register.dart';

class CheckingRegisterView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  const CheckingRegisterView({
    super.key,
    required this.changeView,
    required this.referralCode,
  });

  @override
  State<CheckingRegisterView> createState() => _CheckingRegisterViewState();
}

class _CheckingRegisterViewState extends State<CheckingRegisterView> {
  String errorfield = '', errorTextEmail = '';
  bool error = false;
  bool isProcessing = false;

  late FocusNode emailFocus;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final GlobalKey<CustomInputFieldState> emailKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> refferelKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    emailFocus = FocusNode();

    referralController.text = widget.referralCode;
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
          if (state is ReferDecryptSuccess) {
            referralController.text = state.referCode;
          }
          if (state is ReferDecryptFail) {
            referralController.text = '';
            showErrorToast('Refferal code not valid.', context);
          }
          if (state is RegisterVerifySuccess) {
            setProcessingStatus(false);
            showSuccessToast(state.data['message'], context);
            Storage().referralCode = referralController.text;
            widget.changeView(changeType: ViewChangeType.Forward);
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
        },
        builder: (context, state) {
          return SafeArea(
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
                        errorfield == 'error' || errorfield == 'errorEmail'
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
                  errorfield == 'error' || errorfield == 'errorEmail'
                      ? Container(
                          margin: EdgeInsets.only(top: 5, left: 15),
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
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: CustomStyleButton(
                        title: isProcessing
                            ? 'processing-btn'.tr()
                            : 'next-btn'.tr(),
                        textColor: isProcessing ? processingText : colorWhite,
                        backgroundColor: isProcessing ? processing : null,
                        // borderColor: isProcessing ? processing : colorGoldPerak,
                        borderRadius: 30,
                        height: ScreenSize.height * 0.055,
                        onPressed: isProcessing ? () {} : _validateAndSend,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _validateAndSend() {
    if (emailController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'email-required'.tr();
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(
        context,
      ).add(RegisterVerify(email: emailController.text.trim()));
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();

    super.dispose();
  }
}
