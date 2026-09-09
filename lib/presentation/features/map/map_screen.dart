import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';
import '../home/home.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBlack,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: CustomScaffold(
        toolbarHeight: ScreenSize.height * 0.08,
        // toolbarHeight: kToolbarHeight,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorGreenGradient, colorBlueGradient],
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                height: ScreenSize.height * 0.06,
                // margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: colorWhite.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ImageConverter(
                  imagePath: 'assets/logo/app_logo.png',
                  isAssets: true,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'EV@MBI',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w800,
                  color: colorWhite,
                ),
              ),
            ],
          ),
        ),
        body: MapWrapper(),
        bottomMenuIndex: 1,
        isShow: true,
      ),
    );
  }
}

class MapWrapper extends StatefulWidget {
  const MapWrapper({super.key});

  @override
  MainWrapperState<MapWrapper> createState() => _MapWrapperState();
}

class _MapWrapperState extends MainWrapperState<MapWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(create: (context) => MapBloc()..add(MapCheck())),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(HomeLoad()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MainRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }

              // If location is not enable, popup dialog
              if (state is HomeLocationRequested) {
                YesNoDialog.showYesNoDialog(
                  context,
                  'Enable Location Service',
                  Platform.isAndroid ? androidLocText : iosLocText,
                  colorBlack,
                  TextAlign.justify,
                  _buildEnableButton(context),
                );
              }
            },
          ),
          BlocListener<MapBloc, MapState>(
            listener: (context, state) {
              if (state is MapStarted) {}
            },
          ),
        ],
        child: getPageView(<Widget>[MapView(changeView: changePage)]),
      ),
    );
  }

  // For enable buton in location dialog
  Widget _buildEnableButton(BuildContext context) {
    return CustomStyleButton(
      title: 'Continue',
      backgroundColor: colorBlack,
      onPressed: () async {
        BlocProvider.of<HomeBloc>(context).add(HomeLocationEnable());
        Navigator.pop(context);
      },
    );
  }
}
