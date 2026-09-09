import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../auth/auth.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'view/checking_view.dart';

class CheckingParameters {
  final String fromPage;

  const CheckingParameters({required this.fromPage});
}

class CheckingScreen extends StatefulWidget {
  final CheckingParameters parameters;

  const CheckingScreen({super.key, required this.parameters});

  @override
  State<CheckingScreen> createState() => _CheckingScreenState();
}

class _CheckingScreenState extends State<CheckingScreen> {
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
        leading:
            widget.parameters.fromPage == 'session' ||
                widget.parameters.fromPage == 'scan'
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.setting,
                    (Route<dynamic> route) => false,
                  );
                },
                icon: Icon(Icons.close),
              ),
        body: BlocProvider<AuthBloc>(
          create: (context) {
            /* --------------------------------------------------------------- Call AuthAppStarted() event in AuthBloc to get the details from API */
            return AuthBloc(userRepository: sl())..add(AuthAppStarted());
          },
          child: CheckingWrapper(fromPage: widget.parameters.fromPage),
        ),
        bottomMenuIndex: widget.parameters.fromPage == 'scan'
            ? 2
            : widget.parameters.fromPage == 'session'
            ? 3
            : 4,
        isShow: false,
        canClick: true,
        isCenterTitle: false,
      ),
    );
  }
}

class CheckingWrapper extends StatefulWidget {
  final String fromPage;

  const CheckingWrapper({super.key, required this.fromPage});

  @override
  MainWrapperState<CheckingWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _CheckingWrapperState(fromPage);
}

class _CheckingWrapperState extends MainWrapperState<CheckingWrapper> {
  final String fromPage;

  _CheckingWrapperState(this.fromPage);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (fromPage == 'profile') {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.profile,
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.historyList,
              (Route<dynamic> route) => false,
            );
          }
        }

        if (state is AuthTokenNotEmpty) {
          Navigator.of(context).pushNamed(MainRoutes.scan);
        }

        if (state is AuthSessionError) {
          sessionExpiredLogOut(state.error);
        }

        if (state is AuthMaintenanceError) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainRoutes.maintenanceScreen,
            (Route<dynamic> route) => false,
            arguments: MaintenanceParameters(message: state.message),
          );
        }

        if (state is AuthError) {
          showErrorToast(state.error, context);
        }
      },
      builder: (context, state) {
        fToast = FToast();
        fToast.init(context);

        if (state is AuthUnauthenticated) {
          return getPageView(<Widget>[CheckingView(changeView: changePage)]);
        }

        if (state is AuthError) {
          return SizedBox();
        }

        return Center(child: LoadingWidget());
      },
    );
  }
}
