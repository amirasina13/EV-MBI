import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'history.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
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
        isCenterTitle: true,
        title: Column(
          children: [
            Text(
              'transactions'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: colorWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'charge-history'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colorWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        body: HistoryListWrapper(),
        bottomMenuIndex: 3,
        isShow: true,
        canClick: true,
      ),
    );
  }
}

class HistoryListWrapper extends StatefulWidget {
  const HistoryListWrapper({super.key});

  @override
  MainWrapperState<HistoryListWrapper> createState() =>
      _HistoryListWrapperState();
}

class _HistoryListWrapperState extends MainWrapperState<HistoryListWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryBloc>(
      create: (context) => HistoryBloc()..add(HistoryListLoad()),
      child: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            showErrorToast(state.error, context);

            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.historyList,
              (Route<dynamic> route) => false,
            );
          }

          if (state is HistoryMaintenanceError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainRoutes.maintenanceScreen,
              (Route<dynamic> route) => false,
              arguments: MaintenanceParameters(message: state.message),
            );
          }
        },
        child: getPageView(<Widget>[HistoryListView(changeView: changePage)]),
      ),
    );
  }
}
