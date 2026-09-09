import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'history.dart';

class HistoryDetailParameters {
  final String id;

  const HistoryDetailParameters({required this.id});
}

class HistoryDetailScreen extends StatefulWidget {
  final HistoryDetailParameters parameters;

  const HistoryDetailScreen({super.key, required this.parameters});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBlack,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: CustomScaffold(
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
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.historyList,
              (Route<dynamic> route) => false,
            );
          },
          highlightColor: colorBlack,
          child: Icon(Icons.arrow_back_ios, color: colorWhite),
        ),
        isCenterTitle: true,
        title: Text(
          'Transaction Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            color: colorWhite,
            fontWeight: FontWeight.w400,
          ),
        ),
        body: HistoryDetailWrapper(id: widget.parameters.id),
        bottomMenuIndex: 2,
        showBottomNavigator: false,
        isShow: false,
        canClick: false,
      ),
    );
  }
}

class HistoryDetailWrapper extends StatefulWidget {
  final String id;

  const HistoryDetailWrapper({super.key, required this.id});

  @override
  MainWrapperState<HistoryDetailWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _HistoryDetailWrapperState(id);
}

class _HistoryDetailWrapperState
    extends MainWrapperState<HistoryDetailWrapper> {
  final String id;

  _HistoryDetailWrapperState(this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (context) => HistoryBloc()..add(HistoryDetailsLoad(id: id)),
      child: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }
        },
        child: getPageView(<Widget>[HistoryDetailView(changeView: changePage)]),
      ),
    );
  }
}
