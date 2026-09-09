import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'home.dart';

class LocationDetailParameters {
  final String uuid;

  const LocationDetailParameters({required this.uuid});
}

class LocationDetailScreen extends StatefulWidget {
  final LocationDetailParameters parameters;

  const LocationDetailScreen({super.key, required this.parameters});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBlack,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: CustomScaffold(
        toolbarHeight: kToolbarHeight - 20,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorGreenGradient, colorBlueGradient],
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            highlightColor: colorBlack,
            child: Icon(Icons.arrow_back_ios, color: colorWhite),
          ),
        ),
        body: LocDetailWrapper(uuid: widget.parameters.uuid),
        bottomMenuIndex: 0,
        isShow: false,
        canClick: true,
      ),
    );
  }
}

class LocDetailWrapper extends StatefulWidget {
  final String uuid;

  const LocDetailWrapper({super.key, required this.uuid});

  @override
  MainWrapperState<LocDetailWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _LocDetailWrapperState(uuid);
}

class _LocDetailWrapperState extends MainWrapperState<LocDetailWrapper> {
  final String uuid;

  _LocDetailWrapperState(this.uuid);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc()..add(LocationDetailsLoad(uuid: uuid)),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }
        },
        child: getPageView(<Widget>[
          LocationDetailView(changeView: changePage),
        ]),
      ),
    );
  }
}
