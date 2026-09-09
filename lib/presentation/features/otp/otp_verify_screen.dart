import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../otp/otp.dart';
import '../wrapper.dart';

class OtpVerifyParameters {
  final Map data;

  const OtpVerifyParameters({required this.data});
}

class OtpVerifyScreen extends StatefulWidget {
  final OtpVerifyParameters parameters;
  const OtpVerifyScreen({super.key, required this.parameters});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorTransparent,
      ),
      child: CustomScaffold(
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
          onPressed: _showLogInScreen,
          icon: Icon(Icons.close),
        ),
        body: OtpVerifyWrapper(data: widget.parameters.data),
        bottomMenuIndex: 4,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }

  void _showLogInScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}

class OtpVerifyWrapper extends StatefulWidget {
  final Map data;

  const OtpVerifyWrapper({super.key, required this.data});

  @override
  MainWrapperState<OtpVerifyWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _OtpVerifyWrapperState(data);
}

class _OtpVerifyWrapperState extends MainWrapperState<OtpVerifyWrapper> {
  Map data;
  _OtpVerifyWrapperState(this.data);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpBloc>(
          create: (context) {
            return OtpBloc(authRepository: sl());
          },
        ),
      ],

      child: getPageView(<Widget>[
        OtpVerifyView(changeView: changePage, data: data),
      ]),
    );
  }
}
