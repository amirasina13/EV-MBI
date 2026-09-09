import 'package:flutter/material.dart';

import '../config/config.dart';
import '../presentation/features/delete_account/delete_acc.dart';
import '../presentation/features/forgot_password/forgot_password.dart';
import '../presentation/features/history/history.dart';
import '../presentation/features/home/home.dart';
import '../presentation/features/login/login.dart';
import '../presentation/features/maintenance/maintenance.dart';
import '../presentation/features/map/map.dart';
import '../presentation/features/otp/otp.dart';
import '../presentation/features/profile/profile.dart';
import '../presentation/features/register/register.dart';
import '../presentation/features/scan/scan.dart';
import '../presentation/features/settings/checking_screen.dart';
import '../presentation/features/settings/setting_screen.dart';
import '../presentation/helper/helper.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get the route name for the switch
    final String? routeName = settings.name;

    // Get the actual object passed in 'arguments'
    final dynamic args = settings.arguments;

    switch (routeName) {
      case MainRoutes.locationDetail:
        return NoAnimationPageRoute(
          builder: (context) {
            return LocationDetailScreen(
              parameters: args as LocationDetailParameters,
            );
          },
          settings: settings,
        );

      case MainRoutes.map:
        return NoAnimationPageRoute(
          builder: (context) {
            return MapScreen();
          },
          settings: settings,
        );

      case MainRoutes.scan:
        return NoAnimationPageRoute(
          builder: (context) {
            return ScanScreen();
          },
          settings: settings,
        );
      case MainRoutes.account:
        return NoAnimationPageRoute(
          builder: (context) {
            return CheckingScreen(parameters: args as CheckingParameters);
          },
          settings: settings,
        );
      case MainRoutes.login:
        return NoAnimationPageRoute(
          builder: (context) {
            return LoginScreen();
          },
          settings: settings,
        );

      case MainRoutes.forgotPassword:
        return NoAnimationPageRoute(
          builder: (context) {
            return ForgotPasswordScreen();
          },
          settings: settings,
        );

      case MainRoutes.resetPassword:
        return NoAnimationPageRoute(
          builder: (context) {
            return ResetPasswordScreen(parameters: args as ResetPassParameters);
          },
          settings: settings,
        );

      case MainRoutes.register:
        return NoAnimationPageRoute(
          builder: (context) {
            return CheckingRegisterScreen(
              parameters: args as RegisterParameters,
            );
          },
          settings: settings,
        );

      case MainRoutes.otpVerify:
        return NoAnimationPageRoute(
          builder: (context) {
            return OtpVerifyScreen(parameters: args as OtpVerifyParameters);
          },
          settings: settings,
        );

      case MainRoutes.profile:
        return NoAnimationPageRoute(
          builder: (context) {
            return ProfileScreen();
          },
          settings: settings,
        );

      case MainRoutes.setting:
        return NoAnimationPageRoute(
          builder: (context) {
            return SettingScreen();
          },
          settings: settings,
        );

      case MainRoutes.historyList:
        return NoAnimationPageRoute(
          builder: (context) {
            return HistoryListScreen();
          },
          settings: settings,
        );

      case MainRoutes.historyDetail:
        return NoAnimationPageRoute(
          builder: (context) {
            return HistoryDetailScreen(
              parameters: args as HistoryDetailParameters,
            );
          },
          settings: settings,
        );

      case MainRoutes.deleteAccount:
        return NoAnimationPageRoute(
          builder: (context) {
            return DeleteAccScreen();
          },
          settings: settings,
        );

      case MainRoutes.deleteMobile:
        return NoAnimationPageRoute(
          builder: (context) {
            return DeleteAccMobileScreen();
          },
          settings: settings,
        );

      case MainRoutes.maintenanceScreen:
        return NoAnimationPageRoute(
          builder: (context) {
            return MaintenanceScreen(parameters: args as MaintenanceParameters);
          },
          settings: settings,
        );
    }
    return NoAnimationPageRoute(builder: (_) => const HomeScreen());
  }
}
