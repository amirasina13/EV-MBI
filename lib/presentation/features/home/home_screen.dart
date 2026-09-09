import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBlack,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: CustomScaffold(
        toolbarHeight: ScreenSize.height * 0.19,
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
          constraints: BoxConstraints(minHeight: ScreenSize.height * 0.2),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: ScreenSize.height * 0.06,
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
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(color: colorWhite),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'home-title'.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(color: colorWhite),
                    ),
                  ),
                  Text(
                    'home-subtitle'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colorWhite),
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: HomeWrapper(),
        bottomMenuIndex: 0,
        isShow: true,
      ),
    );
  }
}

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  MainWrapperState<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends MainWrapperState<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(HomeLoad()),
      child: BlocListener<HomeBloc, HomeState>(
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
        child: getPageView(<Widget>[HomeView(changeView: changePage)]),
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
