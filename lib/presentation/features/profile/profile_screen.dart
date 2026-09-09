import 'package:ev_charger/presentation/features/country/country_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance.dart';
import '../wrapper.dart';
import 'profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorTransparent,
      ),
      child: CustomScaffold(
        // appBarColor: colorBlack,
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainRoutes.setting,
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        body: ProfileWrapper(),
        bottomMenuIndex: 4,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }
}

class ProfileWrapper extends StatefulWidget {
  const ProfileWrapper({super.key});

  @override
  MainWrapperState<ProfileWrapper> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends MainWrapperState<ProfileWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
        BlocProvider<CountryBloc>(create: (context) => CountryBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                showErrorToast(state.error, context);
                // BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }

              if (state is ProfileSessionError) {
                sessionExpiredLogOut(state.error);
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
        ],
        child: getPageView(<Widget>[Profileview(changeView: changePage)]),
      ),
    );
  }
}
