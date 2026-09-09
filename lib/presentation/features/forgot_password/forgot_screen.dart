import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'forgot_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorTransparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: colorTransparent,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          toolbarHeight: kToolbarHeight,
          leading: IconButton(
            onPressed: _showLogInScreen,
            icon: Icon(Icons.close),
          ),
          body: ForgotPasswordWrapper(),
          bottomMenuIndex: 4,
          isShow: false,
          canClick: false,
          isCenterTitle: false,
          showBottomNavigator: false,
        ),
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

class ForgotPasswordWrapper extends StatefulWidget {
  const ForgotPasswordWrapper({super.key});

  @override
  MainWrapperState<ForgotPasswordWrapper> createState() =>
      _ForgotPasswordWrapperState();
}

class _ForgotPasswordWrapperState
    extends MainWrapperState<ForgotPasswordWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForgotPassBloc>(
          create: (context) => ForgotPassBloc(authRepository: sl()),
        ),
        BlocProvider<OtpBloc>(
          create: (context) => OtpBloc(authRepository: sl()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ForgotPassBloc, ForgotPassState>(
            listener: (context, state) {
              /* ----------------------------------------------------------------- Listen to Credit error, popup error dialog */
              if (state is ForgotPassMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
          BlocListener<OtpBloc, OtpState>(
            listener: (context, state) {
              /* ----------------------------------------------------------------- Listen to Security error, popup error dialog */
              if (state is OtpError) {
                showErrorToast(state.error, context);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          ForgotPasswordView(changeView: changePage),
        ]),
      ),
    );
  }
}
