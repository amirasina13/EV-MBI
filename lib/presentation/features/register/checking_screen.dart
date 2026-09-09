import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'register.dart';

class RegisterParameters {
  final String referralCode;

  const RegisterParameters({required this.referralCode});
}

class CheckingRegisterScreen extends StatefulWidget {
  final RegisterParameters parameters;
  const CheckingRegisterScreen({super.key, required this.parameters});

  @override
  State<CheckingRegisterScreen> createState() => _CheckingRegisterScreenState();
}

class _CheckingRegisterScreenState extends State<CheckingRegisterScreen> {
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
        body: CheckingRegisterWrapper(
          referralCode: widget.parameters.referralCode,
        ),
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

class CheckingRegisterWrapper extends StatefulWidget {
  final String referralCode;

  const CheckingRegisterWrapper({super.key, required this.referralCode});

  @override
  MainWrapperState<CheckingRegisterWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _CheckingRegisterWrapperState(referralCode);
}

class _CheckingRegisterWrapperState
    extends MainWrapperState<CheckingRegisterWrapper> {
  String referralCode;
  _CheckingRegisterWrapperState(this.referralCode);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (context) {
            return RegisterBloc(userRepository: sl());
          },
        ),
        BlocProvider<OtpBloc>(
          create: (context) {
            return OtpBloc(authRepository: sl());
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is RegisterMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          CheckingRegisterView(
            changeView: changePage,
            referralCode: referralCode,
          ),
          RegisterView(changeView: changePage, referralCode: referralCode),
        ]),
      ),
    );
  }
}
