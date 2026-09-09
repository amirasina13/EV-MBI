import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../widgets/extensions/history/history_view.dart';
import '../../../widgets/independent/independent.dart';
import '../history.dart';

class HistoryListView extends StatefulWidget {
  final Function? changeView;

  const HistoryListView({super.key, this.changeView});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  History? history;
  var transactionHistoryTiles = [];
  List<HistoryList> records = <HistoryList>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state is HistoryError) {
          showErrorToast(state.error, context);
        }
        if (state is HistorySessionError) {}
      },
      builder: (context, state) {
        return _buildHistoryList(context);
      },
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: ((context, state) {
        if (state is HistoryListStop) {
          showPaginationToast('no-more-txn'.tr(), context);
        }
      }),
      builder: (context, state) {
        if (state is HistoryLoading) {
          return LoadingWidget();
        }

        if (state is HistoryLoaded) {
          // first check if api returns any historical records,
          if (state.history.records != null &&
              state.history.records!.isNotEmpty) {
            // if history.records is neither null or empty
            // append to the global records variable (List<HistoryList>)
            records.addAll(state.history.records!);
            BlocProvider.of<HistoryBloc>(context).isFetching = false;
            BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
          }

          // comment: instead of working with the records from api,
          // records.add(state.history.records);
          // comment: work with the global variable that has the records from API added above
          transactionHistoryTiles = records;
          BlocProvider.of<HistoryBloc>(context).isFetching = false;
          BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
        }

        if (state is HistoryEmpty) {
          return emptyHistoryWidget();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            marginHorizontal - 5,
            10,
            marginHorizontal - 5,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(child: _buildTransactionList(context, state)),
              ),
              state is HistoryNextLoading
                  ? SizedBox(child: LoadingWidget())
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionList(BuildContext context, HistoryState state) {
    if (state is HistoryLoaded) {
      history = state.history;
    }

    if (history != null) {
      transactionHistoryTiles = records
          .map(
            (historyList) => historyList.getTransactionTile(
              context: context,
              onTap: () {
                Navigator.of(context).pushNamed(
                  MainRoutes.historyDetail,
                  arguments: HistoryDetailParameters(
                    id: historyList.terminalTranId!,
                  ),
                );
              },
            ),
          )
          .toList(growable: false);

      ScrollController scrollController = ScrollController();
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          if (!BlocProvider.of<HistoryBloc>(context).isFetching) {
            BlocProvider.of<HistoryBloc>(context)
              ..isFetching = true
              ..add(HistoryListLoad());
            BlocProvider.of<HistoryBloc>(context).isFirstShow = false;
          }
        }
      });

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 50),
        shrinkWrap: true,
        controller: scrollController,
        itemCount: records.length,
        itemBuilder: (BuildContext context, int index) {
          return transactionHistoryTiles[index];
        },
      );
    }

    return Container();
  }

  Widget emptyHistoryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorGreenGradient, colorBlueGradient],
            ),
          ),
          child: const Icon(Icons.receipt, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          'no-charge-session'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'no-charge-desc'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            color: colorIconGrey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
