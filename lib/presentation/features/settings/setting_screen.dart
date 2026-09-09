import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/toast_dialog.dart';
import '../auth/auth.dart';
import '../maintenance/maintenance.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'view/setting_view.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorTransparent,
      ),
      child: SettingWrapper(),
    );
  }
}

class SettingWrapper extends StatefulWidget {
  const SettingWrapper({super.key});

  @override
  MainWrapperState<SettingWrapper> createState() => _SettingWrapperState();
}

class _SettingWrapperState extends MainWrapperState<SettingWrapper> {
  bool isEnglish = true;
  int languageValue = 0, currentLangIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userRepository: sl()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
      ],
      child: Builder(
        builder: (innerContext) {
          return MultiBlocListener(
            listeners: [
              BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  fToast.init(context);

                  if (state is ProfileError) {
                    showErrorToast(state.error, context);
                  }
                  if (state is ProfileSessionError) {
                    showErrorToast(state.error, context);
                  }
                  if (state is ProfileMaintenanceError) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainRoutes.maintenanceScreen,
                      (Route<dynamic> route) => false,
                      arguments: MaintenanceParameters(message: state.message),
                    );
                  }
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  fToast.init(context);

                  if (state is AuthError) {
                    showErrorToast(state.error, context);
                  }
                  if (state is AuthSessionError) {
                    sessionExpiredLogOut(state.error);
                  }

                  if (state is AuthUnauthenticated) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainRoutes.setting,
                      (Route<dynamic> route) => false,
                    );
                  }
                  if (state is AuthMaintenanceError) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainRoutes.maintenanceScreen,
                      (Route<dynamic> route) => false,
                      arguments: MaintenanceParameters(message: state.message),
                    );
                  }
                },
              ),
            ],
            child: getPageView(<Widget>[SettingView(changeView: changePage)]),
          );
        },
      ),
    );
  }
}
