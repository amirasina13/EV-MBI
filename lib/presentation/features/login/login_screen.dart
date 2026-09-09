import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../auth/auth.dart';
import '../wrapper.dart';
import 'login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.setting,
              (Route<dynamic> route) => false,
            );
          },
          icon: Icon(Icons.close),
        ),
        body: LoginWrapper(),
        bottomMenuIndex: 4,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }
}

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({super.key});

  @override
  MainWrapperState<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends MainWrapperState<LoginWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        userRepository: sl(),
        authenticationBloc: AuthBloc(userRepository: sl()),
      ),
      child: getPageView(<Widget>[LoginView(changeView: changePage)]),
    );
  }
}
