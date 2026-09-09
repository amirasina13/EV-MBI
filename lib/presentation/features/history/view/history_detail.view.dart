import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/config.dart';
import '../../../widgets/independent/independent.dart';
import '../history.dart';

class HistoryDetailView extends StatefulWidget {
  final Function? changeView;

  const HistoryDetailView({super.key, this.changeView});

  @override
  State<HistoryDetailView> createState() => _HistoryDetailViewState();
}

class _HistoryDetailViewState extends State<HistoryDetailView> {
  String detailId = '', detailStatus = '';
  Timer? refreshTimer;
  final bool _enabled = true;

  var dateFormat = DateFormat(appDateFormat);
  var timeFormat = DateFormat(appTimeFormat);

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
  }

  void autoRefresh() {
    if (refreshTimer?.isActive ?? false) return;

    refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Trigger the Bloc event every 30 seconds
      context.read<HistoryBloc>()
        ..isRefresh = true
        ..add(HistoryDetailsLoad(id: detailId));
    });
  }

  @override
  void dispose() {
    // Cancel the timer when leaving the page
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          MainRoutes.historyList,
          (Route<dynamic> route) => false,
        );
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            marginHorizontal - 5,
            10,
            marginHorizontal - 5,
            20,
          ),
          child: BlocConsumer<HistoryBloc, HistoryState>(
            listener: (context, state) async {
              fToast = FToast();
              fToast.init(context);

              var token =
                  await Storage().secureStorage.read(key: 'token') ?? '';

              if (state is HistoryError) {
                if (!mounted) return;
                showErrorToast(state.error, this.context);

                if (token.isNotEmpty) {
                  if (!mounted) return;
                  Navigator.of(this.context).pushNamedAndRemoveUntil(
                    MainRoutes.historyList,
                    (Route<dynamic> route) => false,
                    arguments: state.error,
                  );
                } else {
                  Navigator.of(this.context).pushNamedAndRemoveUntil(
                    MainRoutes.home,
                    (Route<dynamic> route) => false,
                    arguments: state.error,
                  );
                }
              }

              if (state is HistoryDetailsLoaded) {
                // Update your variables from the state
                detailId = state.historyDetails.terminalTranId ?? '';
                detailStatus = state.historyDetails.status ?? '';

                // Check if need to start refreshing
                if (detailStatus != '0' && detailStatus != '1') {
                  autoRefresh();
                } else {
                  // If status changed to something else, stop refreshing
                  refreshTimer?.cancel();
                }
              }
            },
            builder: (context, state) {
              if (state is HistoryDetailsLoading) {
                return _historyLoading();
              }

              if (state is HistoryDetailsLoaded) {
                /* decalre the detail and id */
                var detail = state.historyDetails;
                detailId = detail.terminalTranId!;

                detailStatus = detail.status!;

                if (detailId.isNotEmpty) {
                  List<String> energyLabelPart = detail.energyLabel!.split(' ');
                  String rawSoc = detail.soc!;
                  double socValue = double.tryParse(rawSoc) ?? 0.0;
                  int percentage = socValue.round(); // 81

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Box 1st
                        Container(
                          width: ScreenSize.width,
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(18),
                            // border: Border.all(color: colorLightGrey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: detail.status == '0'
                                      ? Colors.red.shade50
                                      : detail.status == '1'
                                      ? colorGreenWhite
                                      : detail.status == '3'
                                      ? colorBlueWhite
                                      : Colors.yellow.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  detail.status == '0'
                                      ? 'hist-status-fail'.tr()
                                      : detail.status == '1'
                                      ? 'hist-status-complete'.tr()
                                      : detail.status == '3'
                                      ? 'hist-status-charge'.tr()
                                      : 'Pending',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: detail.status == '0'
                                            ? colorTextRed
                                            : detail.status == '1'
                                            ? colorGreenGradient
                                            : detail.status == '3'
                                            ? colorBlueGradient
                                            : Colors.yellow.shade600,
                                      ),
                                ),
                              ),
                              Text(
                                '${'txn-id'.tr()}: ${detail.terminalTranId}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              detail.connectorLabel!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        detail.connectorLabel!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        // Box 2nd
                        Container(
                          width: ScreenSize.width,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                          decoration: BoxDecoration(
                            // color: colorGoldPerak,
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.green.shade700, Colors.blue],
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  detail.status == '3'
                                      ? 'estimate-energy'.tr()
                                      : 'energy-consumed'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorWhite,
                                      ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: colorBlack),
                                  children: [
                                    TextSpan(
                                      text: energyLabelPart[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontSize: 40,
                                            color: colorWhite,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' ${energyLabelPart[1]}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: colorWhite,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Box 3rd
                        Container(
                          width: ScreenSize.width,
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'charging-session'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorIconGrey,
                                      ),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                isThreeLine: false,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/startTime.svg',
                                  isAssets: true,
                                  width: 23,
                                  color: colorIconGrey,
                                ),
                                title: Text(
                                  'start-time'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorIconGrey,
                                      ),
                                ),
                                trailing: Text(
                                  '${dateFormat.format(DateTime.parse(detail.startCharge!))}, ${timeFormat.format(DateTime.parse(detail.startCharge!))}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/startTime.svg',
                                  isAssets: true,
                                  width: 23,
                                  color: colorIconGrey,
                                ),
                                title: Text(
                                  'end-time'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorIconGrey,
                                      ),
                                ),
                                trailing: Text(
                                  '${dateFormat.format(DateTime.parse(detail.endCharge!))}, ${timeFormat.format(DateTime.parse(detail.endCharge!))}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/duration.svg',
                                  isAssets: true,
                                  width: 23,
                                  color: colorIconGrey,
                                ),
                                title: Text(
                                  detail.status == '3'
                                      ? 'estimate-duration'.tr()
                                      : 'duration'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorIconGrey,
                                      ),
                                ),
                                trailing: Text(
                                  detail.durationLabel!,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/connectionType.svg',
                                  isAssets: true,
                                  width: 23,
                                  color: colorIconGrey,
                                ),
                                title: Text(
                                  'connector-type'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorIconGrey,
                                      ),
                                ),
                                trailing: Text(
                                  detail.connectorType!,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/powerDraw.svg',
                                  isAssets: true,
                                  width: 23,
                                  color: colorIconGrey,
                                ),
                                title: Text(
                                  'power-draw'.tr(),
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorIconGrey,
                                      ),
                                ),
                                trailing: Text(
                                  detail.powerDraw ?? '-',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              detail.chargerType == 'DC'
                                  ? ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath: 'assets/icon/soc.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'soc'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: Text(
                                        '$percentage%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    )
                                  : SizedBox(),
                              detail.chargerType == 'DC'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey[200], // Background
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor:
                                                  socValue /
                                                  100, // Your SOC / 100
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  // The two-color gradient
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.green.shade900,
                                                      Colors.blue,
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '0%',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color: colorLightGrey,
                                                    ),
                                              ),
                                              Text(
                                                '100%',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      color: colorLightGrey,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        // Box 4th - PAYMENT
                        detail.status != '3' && detail.status != '2'
                            ? Container(
                                width: ScreenSize.width,
                                padding: EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                margin: EdgeInsets.only(
                                  top: 15,
                                  left: 5,
                                  right: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 2.0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        'payment-details'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      isThreeLine: false,
                                      leading: ImageConverter(
                                        imagePath: 'assets/icon/powerDraw.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        detail.rateLabel!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: Text(
                                        detail.rate!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath: 'assets/icon/totalPrice.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'total-price'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: Text(
                                        '${detail.currency} ${detail.salesAmount!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorGreenGradient,
                                            ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath:
                                            'assets/icon/reference_id.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'reference-id'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: SizedBox(
                                        width: ScreenSize.width * 0.43,
                                        child: Text(
                                          detail.referenceId!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath: 'assets/icon/payment_id.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'payment-id'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: SizedBox(
                                        width: ScreenSize.width * 0.45,
                                        child: Text(
                                          detail.paymentId ?? '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath:
                                            'assets/icon/payment_gateaway.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'payment-gateaway'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: Text(
                                        detail.paymentGateway ?? '-',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: ImageConverter(
                                        imagePath:
                                            'assets/icon/paymentStatus.svg',
                                        isAssets: true,
                                        width: 23,
                                        color: colorIconGrey,
                                      ),
                                      title: Text(
                                        'payment-status'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorIconGrey,
                                            ),
                                      ),
                                      trailing: Container(
                                        width: ScreenSize.width * 0.25,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: colorGreenGradient,
                                              size: 20,
                                            ),
                                            Text(
                                              'paid-text'.tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: colorGreenGradient,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        // Box 5th
                        Container(
                          width: ScreenSize.width,
                          padding: EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 15,
                          ),
                          margin: EdgeInsets.only(
                            top: 15,
                            left: 5,
                            right: 5,
                            bottom: 30,
                          ),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  'station-loc'.tr(),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                leading: ImageConverter(
                                  imagePath: 'assets/icon/map.svg',
                                  isAssets: true,
                                  color: colorIconGrey,
                                  width: 22,
                                ),
                                title: Text(
                                  detail.locationName!,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              return _historyLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _historyLoading() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        height: ScreenSize.height,
        color: colorTransparent,
        child: Shimmer.fromColors(
          baseColor: colorGreyBox,
          highlightColor: colorWhiteGrey,
          enabled: _enabled,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Box 1
                Container(
                  height: ScreenSize.height * 0.13,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                // Box 2
                Container(
                  height: ScreenSize.height * 0.127,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                // Box 3
                Container(
                  height: ScreenSize.height * 0.127,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                // Box 4
                Container(
                  height: ScreenSize.height * 0.25,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  margin: EdgeInsets.only(top: 15, left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
