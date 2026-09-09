import 'package:easy_localization/easy_localization.dart';
import 'package:ev_charger/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';
import 'firebase_options.dart';
import 'locator.dart' as service_locator;
import 'presentation/features/home/home.dart';
import 'presentation/features/notification/notification.dart';
import 'presentation/widgets/independent/independent.dart';
import 'service/app_router.dart';
import 'service/navigation_service.dart';

RemoteMessage? globalInitialMessage; // Global variable to store initial message

class SimpleBlocDelegate extends BlocObserver {
  @override
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // ignore: avoid_print
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print(error);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.instance.initialize();
  NotificationService.instance.getDeviceToken();

  String accessToken = mapBoxToken;
  MapboxOptions.setAccessToken(accessToken);

  globalInitialMessage = await FirebaseMessaging.instance.getInitialMessage();

  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('lang') ?? 'en';

  await service_locator.init();

  // Setup Configurations
  _initSystemUI();

  // Global State / Observer
  Bloc.observer = SimpleBlocDelegate();
  HomeBloc homeBloc = HomeBloc();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ms', 'MY')],
      path: 'assets/language', // where the translation files
      fallbackLocale: Locale('en', 'US'),
      startLocale: savedLang == 'ms'
          ? const Locale('ms', 'MY')
          : const Locale('en', 'US'),
      child: MultiBlocProvider(
        providers: [BlocProvider.value(value: homeBloc)],
        child: EVChargerApp(),
      ),
    ),
  );
}

void _initSystemUI() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

class EVChargerApp extends StatelessWidget {
  const EVChargerApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    Future.wait([
      initializeDateFormatting('en_US', null),
      initializeDateFormatting('ms_MY', null),
    ]);
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

    return MaterialApp(
      navigatorKey: sl<NavigationService>().navigatorKey,
      navigatorObservers: [NavigationHistoryObserver(), routeObserver],
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      title: appName,
      localizationsDelegates: [
        ...context.localizationDelegates,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: MainTheme.of(context),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
