import 'package:easy_localization/easy_localization.dart';
import 'package:ev_charger/presentation/widgets/independent/independent.dart';
import 'package:flutter/material.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';

/* Extension class for point transaction list. Will use in extensions/history_view.dart  */
extension View on HistoryList {
  Widget getTransactionTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    var dateFormat = DateFormat(appDateFormat).format(DateTime.parse(created!));
    var timeFormat = DateFormat(appTimeFormat).format(DateTime.parse(created!));

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
          padding: EdgeInsets.all(marginHorizontal),
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0.0, 2.0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chargePointIdentity!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: status == '0'
                          ? Colors.red.shade50
                          : status == '1'
                          ? Colors.green.shade50
                          : status == '3'
                          ? Colors.blue.shade50
                          : colorWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status == '0'
                          ? 'hist-status-fail'.tr()
                          : status == '1'
                          ? 'hist-status-complete'.tr()
                          : status == '3'
                          ? 'hist-status-charge'.tr()
                          : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: status == '0'
                            ? colorTextRed
                            : status == '1'
                            ? colorGreenGradient
                            : status == '3'
                            ? colorBlueGradient
                            : colorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ImageConverter(
                        imagePath: 'assets/icon/map.svg',
                        isAssets: true,
                        color: colorIconGrey,
                        width: 18,
                      ),
                    ),
                    Text(
                      locationName!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorIconGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    ImageConverter(
                      imagePath: chargerType == 'DC'
                          ? 'assets/icon/dc.svg'
                          : 'assets/icon/ac.svg',
                      isAssets: true,
                    ),
                    SizedBox(width: 3),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                      decoration: BoxDecoration(
                        color: colorWhiteGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        connectorType!,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: colorDarkGray),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: colorWhiteGrey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'energy'.tr(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: colorIconGrey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            energyLabel!,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  color: colorGreenGradient,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'duration'.tr(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: colorIconGrey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            durationLabel!,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'RM $salesAmount',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 22),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$dateFormat, $timeFormat',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorWhiteGrey,
                        border: Border.all(color: colorGreyBox),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(Icons.arrow_forward_ios, size: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}
