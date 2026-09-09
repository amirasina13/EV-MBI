import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'scan.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorTransparent,
      ),
      child: CustomScaffold(
        appBarColor: colorBlack,
        background: colorWhite,
        toolbarHeight: kToolbarHeight,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorGreenGradient, colorBlueGradient],
            ),
          ),
        ),
        title: InkWell(
          onTap: () {
            // Navigator.of(context).pop();
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.home,
              (Route<dynamic> route) => false,
            );
          },
          highlightColor: colorBlack,
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: colorWhite, size: 17),
              Text('back-btn'.tr(), style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
        // leading: InkWell(
        //   onTap: () {
        //     // Navigator.of(context).pop();
        //     Navigator.of(context).pushNamedAndRemoveUntil(
        //       MainRoutes.home,
        //       (Route<dynamic> route) => false,
        //     );
        //   },
        //   highlightColor: colorBlack,
        //   child: Row(
        //     children: [
        //       Icon(Icons.arrow_back_ios, color: colorWhite),
        //       Text('back-btn'.tr()),
        //     ],
        //   ),
        // ),
        body: ScanWrapper(),
        bottomMenuIndex: 2,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }
}

class ScanWrapper extends StatefulWidget {
  const ScanWrapper({super.key});

  @override
  MainWrapperState<ScanWrapper> createState() => _ScanWrapperState();
}

class _ScanWrapperState extends MainWrapperState<ScanWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScanBloc>(
          create: (context) => ScanBloc(historyRepository: sl()),
        ),
        // BlocProvider<CountryBloc>(create: (context) => CountryBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ScanBloc, ScanState>(
            listener: (context, state) {
              if (state is ScanError) {
                showErrorToast(state.error, context);
                // BlocProvider.of<ScanBloc>(context).add(ScanLoad());
              }

              // if (state is ScanSessionError) {
              //   sessionExpiredLogOut(state.error);
              // }
              if (state is ScanMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[ScanView(changeView: changePage)]),
      ),
    );
  }
}
