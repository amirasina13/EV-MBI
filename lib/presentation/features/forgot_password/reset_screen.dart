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

class ResetPassParameters {
  final String email;
  final String vToken;

  const ResetPassParameters({required this.email, required this.vToken});
}

class ResetPasswordScreen extends StatefulWidget {
  final ResetPassParameters? parameters;
  const ResetPasswordScreen({super.key, this.parameters});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
          body: ResetPasswordWrapper(
            email: widget.parameters!.email,
            vToken: widget.parameters!.vToken,
          ),
          bottomMenuIndex: 4,
          isShow: false,
          canClick: false,
          isCenterTitle: false,
          showBottomNavigator: false,
        ),
      ),
    );
  }
}

class ResetPasswordWrapper extends StatefulWidget {
  final String email;
  final String vToken;

  const ResetPasswordWrapper({
    super.key,
    required this.email,
    required this.vToken,
  });

  @override
  MainWrapperState<ResetPasswordWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _ResetPasswordWrapperState(email, vToken);
}

class _ResetPasswordWrapperState
    extends MainWrapperState<ResetPasswordWrapper> {
  final String email;
  final String vToken;

  _ResetPasswordWrapperState(this.email, this.vToken);

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
          ResetPasswordView(
            changeView: changePage,
            email: email,
            vToken: vToken,
          ),
        ]),
      ),
    );
  }
}
