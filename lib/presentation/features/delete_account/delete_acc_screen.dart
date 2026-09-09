import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/config.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../wrapper.dart';
import 'delete_acc.dart';

class DeleteAccScreen extends StatefulWidget {
  const DeleteAccScreen({super.key});

  @override
  State<DeleteAccScreen> createState() => _DeleteAccScreenState();
}

class _DeleteAccScreenState extends State<DeleteAccScreen> {
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
              MainRoutes.profile,
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),

        body: DeleteAccWrapper(),
        bottomMenuIndex: 4,
        isShow: false,
        canClick: false,
        isCenterTitle: false,
        showBottomNavigator: false,
      ),
    );
  }
}

class DeleteAccWrapper extends StatefulWidget {
  const DeleteAccWrapper({super.key});

  @override
  MainWrapperState<DeleteAccWrapper> createState() => _DeleteAccWrapperState();
}

class _DeleteAccWrapperState extends MainWrapperState<DeleteAccWrapper> {
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteAccBloc>(
      create: (context) {
        return DeleteAccBloc(userRepository: sl());
      },
      child: BlocConsumer<DeleteAccBloc, DeleteAccState>(
        listener: (context, state) {
          if (state is DeleteAccError) {
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          return getPageView(<Widget>[ReasonView(changeView: changePage)]);
        },
      ),
    );
  }
}
