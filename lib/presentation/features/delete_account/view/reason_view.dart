import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../widgets/independent/independent.dart';
import '../delete_acc.dart';

class ReasonView extends StatefulWidget {
  final Function changeView;

  const ReasonView({super.key, required this.changeView});

  @override
  State<ReasonView> createState() => _ReasonViewState();
}

class _ReasonViewState extends State<ReasonView> {
  String errorfield = '';
  bool isProcessing = false;
  String _result = '';
  late FocusNode validateFocus;
  final TextEditingController otherTextController = TextEditingController();
  final GlobalKey<CustomInputFieldState> otherTextKey = GlobalKey();
  final otherFocus = FocusNode();

  List reasonDelete = [
    'reason-1'.tr(),
    'reason-2'.tr(),
    'reason-3'.tr(),
    'reason-4'.tr(),
    'reason-5'.tr(),
    'reason-6'.tr(),
  ];

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    validateFocus = FocusNode();
  }

  @override
  void dispose() {
    otherTextController.dispose();

    // Clean up the focus node when the Form is disposed.
    validateFocus.dispose();
    super.dispose();
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
      child: BlocConsumer<DeleteAccBloc, DeleteAccState>(
        listener: (context, state) {
          if (state is AccReasonDeleted) {
            setProcessingStatus(false);
            Navigator.of(context).pushNamed(MainRoutes.deleteMobile);
          }
          // on failure show a snackbar
          if (state is DeleteAccError) {
            setProcessingStatus(false);
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              height: ScreenSize.height * 0.78,
              color: colorWhite,
              margin: EdgeInsets.symmetric(
                horizontal: marginHorizontal,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'reason-title'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ScreenSize.height * 0.02),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[0];
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[0],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[0],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[1];
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[1],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[1],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[2];
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[2],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[2],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[3];
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[3],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[3],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[4];
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[4],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[4],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _result = reasonDelete[5];

                        if (_result == 'Others' || _result == 'Lain-lain') {
                          otherFocus.requestFocus();
                        }
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Text(
                        reasonDelete[5],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: reasonDelete[5],
                          activeColor: colorBlack,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              _result = value!;

                              if (_result == 'Others' ||
                                  _result == 'Lain-lain') {
                                otherFocus.requestFocus();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 5,
                      title: Container(
                        height: ScreenSize.height * 0.08,
                        color: colorWhite,
                        child: TextField(
                          key: otherTextKey,
                          controller: otherTextController,
                          focusNode: otherFocus,
                          readOnly: _result == reasonDelete[5] ? false : true,
                          textAlignVertical: TextAlignVertical.top,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            hintText: 'reasons'.tr(),
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFC4C4C4),
                              fontFamily: fontFamilyMain,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGreyBox),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGreyBox),
                            ),
                          ),
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: CustomStyleButton(
                        title: 'continue-btn'.tr(),
                        height: ScreenSize.height / 18,
                        borderRadius: 30,
                        iconLeading: false,
                        icon: Icons.arrow_forward,
                        backgroundColor: isProcessing ? processing : null,
                        textColor: isProcessing ? processingText : colorWhite,
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
    fToast = FToast();
    fToast.init(context);

    if (_result.isEmpty) {
      setProcessingStatus(false);
      showErrorToast('Please select your reason', context);
    } else if (_result == 'Others' && otherTextController.text.isEmpty) {
      setProcessingStatus(false);
      validateFocus.requestFocus();
      showErrorToast('Please share us your reason', context);
    } else {
      setProcessingStatus(true);
      BlocProvider.of<DeleteAccBloc>(context).add(
        DeleteAccReason(
          reason: _result == 'Others' ? otherTextController.text : _result,
        ),
      );
    }
  }
}
