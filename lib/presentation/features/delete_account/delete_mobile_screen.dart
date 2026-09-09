import 'package:flutter/services.dart';

import '../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../wrapper.dart';
import 'delete_acc.dart';

class DeleteAccMobileScreen extends StatefulWidget {
  const DeleteAccMobileScreen({super.key});

  @override
  State<DeleteAccMobileScreen> createState() => _DeleteAccMobileScreenState();
}

class _DeleteAccMobileScreenState extends State<DeleteAccMobileScreen> {
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainRoutes.deleteAccount,
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        body: DeleteAccMobileWrapper(),
        bottomMenuIndex: 4,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }
}

class DeleteAccMobileWrapper extends StatefulWidget {
  const DeleteAccMobileWrapper({super.key});

  @override
  MainWrapperState<DeleteAccMobileWrapper> createState() =>
      _DeleteAccMobileWrapperState();
}

class _DeleteAccMobileWrapperState
    extends MainWrapperState<DeleteAccMobileWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteAccBloc>(
      create: (context) {
        return DeleteAccBloc(userRepository: sl());
      },
      child: BlocConsumer<DeleteAccBloc, DeleteAccState>(
        listener: (context, state) {},
        builder: (context, state) {
          return getPageView(<Widget>[
            DeleteMobileView(changeView: changePage),
          ]);
        },
      ),
    );
  }
}
