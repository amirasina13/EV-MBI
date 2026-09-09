import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance.dart';
import '../../register/register.dart';
import '../login.dart';

class LoginView extends StatefulWidget {
  final Function changeView;
  const LoginView({super.key, required this.changeView});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String errorfield = '', errorTextEmail = '', errorTextPwd = '';
  bool error = false;
  bool isProcessing = false;

  late FocusNode emailFocus, pwFocus;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<CustomInputFieldState> emailKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> passwordKey = GlobalKey();

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
    pwFocus = FocusNode();
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
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }

          if (state is LoginFinished) {
            setProcessingStatus(false);

            showSuccessToast(state.loginData['message'], context);

            var profile = state.loginData['data']['profile'];

            // Create a list of the fields you want to check
            List<String> fieldsToCheck = [
              profile['name'],
              profile['surname'],
              profile['forename'],
              profile['dob'],
              profile['contact'],
              profile['gender'],
            ];

            bool hasProfileData = fieldsToCheck.any(
              (value) => value.isNotEmpty,
            );

            if (hasProfileData) {
              if (Storage().fromPage == 'profile') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.profile,
                  (Route<dynamic> route) => false,
                );
              } else if (Storage().fromPage == 'scan') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.scan,
                  (Route<dynamic> route) => false,
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.historyList,
                  (Route<dynamic> route) => false,
                );
              }
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainRoutes.profile,
                (Route<dynamic> route) => false,
              );
            }
          }

          if (state is LoginError) {
            // ignore: unnecessary_null_comparison
            state.error != null ? error = true : error = false;

            setProcessingStatus(false);
            showErrorToast(state.error, context);
          }
          if (state is LoginNetworkError) {
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
                          mainAxisSize: MainAxisSize.min,
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
                                'signin-btn'.tr(),
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text(
                                'email-title'.tr(),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
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
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              bottomBorderColor:
                                  errorfield == 'error' ||
                                      errorfield == 'errorEmail'
                                  ? colorRed
                                  : colorBlack,
                              style: Theme.of(context).textTheme.bodySmall,
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
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      errorTextEmail,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 10,
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            CustomAppTextField(
                              key: passwordKey,
                              controller: passwordController,
                              focusNode: pwFocus,
                              hintText: 'pwd-enter'.tr(),
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              isPassword: true,
                              textAlignVertical: TextAlignVertical.center,
                              bottomBorderColor:
                                  errorfield == 'error' ||
                                      errorfield == 'errorPwd'
                                  ? colorRed
                                  : colorBlack,
                              style: Theme.of(context).textTheme.bodySmall,
                              onChanged: (value) {
                                if (value != '') {
                                  setState(() {
                                    errorfield = '';
                                    passwordKey.currentState?.validate();
                                  });
                                }
                              },
                            ),
                            errorfield == 'error' || errorfield == 'errorPwd'
                                ? Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      errorTextPwd,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 10,
                                            color: error
                                                ? colorRed
                                                : errorfield == 'error' ||
                                                      errorfield == 'errorPwd'
                                                ? colorRed
                                                : colorGreyBox,
                                          ),
                                    ),
                                  )
                                : SizedBox(),
                            Container(
                              alignment: Alignment.centerRight,
                              height: ScreenSize.width * 0.1,
                              margin: EdgeInsets.only(top: 10, bottom: 0),
                              child: InkWell(
                                child: Text(
                                  'forgot-pwd'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    MainRoutes.forgotPassword,
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomStyleButton(
                                    title: isProcessing
                                        ? 'processing-btn'.tr()
                                        : 'signin-btn'.tr(),
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
                                        : () {
                                            FocusScope.of(context).unfocus();
                                            _validateAndSend();
                                          },
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'no-acc'.tr(),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                        CustomButtonText(
                                          'register'.tr(),
                                          color: colorBlack,
                                          fontSize: 14.0,
                                          underline: true,
                                          fontWeight: FontWeight.w600,
                                          onClick: () {
                                            Navigator.of(context).pushNamed(
                                              MainRoutes.register,
                                              arguments: RegisterParameters(
                                                referralCode: '',
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  void _validateAndSend() {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'error';
      emailFocus.requestFocus();
      errorTextEmail = 'email-required'.tr();
      errorTextPwd = 'password-required'.tr();
    } else if (emailController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'email-required'.tr();
    } else if (passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'password-required'.tr();
    } else {
      errorfield = '';

      setProcessingStatus(true);
      BlocProvider.of<LoginBloc>(context).add(
        LoginPressed(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();
    pwFocus.dispose();

    super.dispose();
  }
}
