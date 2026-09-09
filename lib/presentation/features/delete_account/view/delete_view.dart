import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/data_driven/connectivity_check.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../delete_acc.dart';

class DeleteMobileView extends StatefulWidget {
  final Function changeView;

  // ignore: use_key_in_widget_constructors
  const DeleteMobileView({Key? key, required this.changeView}) : super();

  @override
  State<DeleteMobileView> createState() => _DeleteMobileViewState();
}

class _DeleteMobileViewState extends State<DeleteMobileView> {
  bool error = false;
  bool isProcessing = false;
  String errorfield = '', errorTextEmail = '';
  List<String> getCode = [];
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<CustomInputFieldState> emailKey = GlobalKey();

  late FocusNode emailFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    emailFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();

    _connectivity.disposeStream();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? Colors.blueAccent : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorWhite,
          body: BlocConsumer<DeleteAccBloc, DeleteAccState>(
            listener: (context, state) {
              if (state is DeleteAccSent) {
                setProcessingStatus(false);

                Storage().secureStorage.deleteAll();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.login,
                  (Route<dynamic> route) => false,
                );
                showSuccessToast(state.message, context);
              }
              // on failure show a error dialog
              if (state is DeleteAccError) {
                setProcessingStatus(false);
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);

                showErrorToast(state.error, context);
                Navigator.pop(context);
              }
              if (state is DeleteAccMaintenanceError) {
                setProcessingStatus(false);

                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => MaintenanceScreen(
                      parameters: MaintenanceParameters(message: state.message),
                    ),
                  ),
                  ModalRoute.withName('/'),
                );
              }
            },
            builder: (context, state) {
              if (state is DeleteAccProcessing) {}
              return SingleChildScrollView(
                reverse: true,
                physics: BouncingScrollPhysics(),
                child: Container(
                  color: colorWhite,
                  margin: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    0,
                    marginHorizontal,
                    25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: ScreenSize.height / 10,
                        child: Text(
                          'delete-my-acc'.tr(),
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: sizeBetween / 3),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          'email-title'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: colorWhite,
                          boxShadow: [
                            BoxShadow(
                              color: error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                        errorfield == 'errorEmail'
                                  ? colorRed
                                  : colorGreyBox,
                              offset: Offset(
                                0.0,
                                error
                                    ? 3
                                    : errorfield == 'error' ||
                                          errorfield == 'errorEmail'
                                    ? 3
                                    : 0,
                              ),
                            ),
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: CustomInputField(
                          key: emailKey,
                          controller: emailController,
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
                          border: InputBorder.none,
                          focusNode: emailFocus,
                          onValueChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                                error = false;
                                emailKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorEmail'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
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
                      Container(
                        width: ScreenSize.width,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: colorGreyBox,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textScaler: TextScaler.linear(
                                context.scaleFactor(),
                              ).clamp(maxScaleFactor: 1.2),
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: colorRed,
                                  fontFamily: fontFamilyMain,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'reason-note-title'.tr(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n\n1. ${'reason-note-1'.tr()} \n2. ${'reason-note-2'.tr()}', //credits / points and vouchers
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: ScreenSize.width * 0.6,
                              child: RichText(
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.linear(
                                  context.scaleFactor(),
                                ).clamp(maxScaleFactor: 1.2),
                                text: TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: colorRed,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  children: [
                                    TextSpan(text: '\n\n ${'sure'.tr()}'),
                                    TextSpan(
                                      text: 'proceed'.tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sizeBetween * 2),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomStyleButton(
                    height: ScreenSize.height / 18,
                    borderRadius: 30,
                    title: 'submit-btn'.tr(),
                    backgroundColor: isProcessing ? processing : null,
                    textColor: isProcessing ? processingText : colorWhite,
                    onPressed: isProcessing ? () {} : _validateAndSend,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'cancel-btn'.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        color: colorBlack,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    fToast = FToast();
    fToast.init(context);

    if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'email-required'.tr();
    } else {
      errorfield = '';

      showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20.0),
            insetPadding: EdgeInsets.zero,
            backgroundColor: colorWhite,
            content: Container(
              color: colorWhite,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: ScreenSize.width * 0.18,
                    width: ScreenSize.width * 0.18,
                    color: colorTransparent,
                    child: ImageConverter(
                      imagePath: 'assets/icon/bin.webp',
                      isAssets: true,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(
                        context.scaleFactor(),
                      ).clamp(maxScaleFactor: 1.2),
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colorIconGrey,
                        ),
                        children: [
                          TextSpan(text: 'delete-confirm'.tr()),
                          TextSpan(
                            text: '${emailController.text}? ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenSize.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'action-undone'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: colorIconGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: CustomStyleButton(
                            backgroundColor: colorRed,
                            height: ScreenSize.height / 16,
                            width: ScreenSize.width,
                            title: 'delete-btn'.tr(),
                            onPressed: _confirmDeleteAccount,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 5),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            // color: colorBabyBlue,
                            alignment: Alignment.center,
                            child: Text(
                              'cancel-btn'.tr(),
                              style: TextStyle(
                                fontSize: 15,
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _confirmDeleteAccount() {
    setProcessingStatus(true);

    BlocProvider.of<DeleteAccBloc>(
      context,
    ).add(DeleteAccSend(email: emailController.text));
  }
}
