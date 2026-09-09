import 'package:easy_localization/easy_localization.dart';
import 'package:ev_charger/config/config.dart';
import 'package:ev_charger/presentation/widgets/independent/independent.dart';
import 'package:flutter/material.dart';

import '../../../../data/data.dart';

/* Extension class for point transaction list. Will use in extensions/history_view.dart  */
extension View on ConnectorDetail {
  Widget getconnectorTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    // status = 0 OFFLINE | status = 1 AVAILABLE | status = 2 IN USE
    bool isAvailable = status == "1";
    bool isOffline = status == "0";
    bool isAC = chargerType == "AC";
    Color themeColor = isAvailable
        ? colorGreenGradient
        : isOffline
        ? colorGreyBox
        : colorBlueGradient;
    Color iconColor = isAvailable
        ? colorGreenGradient
        : isOffline
        ? colorIconGrey
        : colorBlueGradient;
    Color textColor = isAvailable
        ? colorBlack
        : isOffline
        ? colorIconGrey
        : colorBlack;
    Color statusColor = isAvailable
        ? colorGreenGradient
        : isOffline
        ? colorIconGrey
        : colorBlueGradient;
    Color statusBgColor = isAvailable
        ? colorGreenWhite
        : isOffline
        ? colorWhiteGrey
        : colorBlueWhite;
    String chargeType = isAC ? 'assets/icon/ac.svg' : 'assets/icon/dc.svg';
    String statusText = isAvailable
        ? 'status-available'.tr()
        : isOffline
        ? 'status-offline'.tr()
        : 'status-in-use'.tr();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: statusBgColor, // Light tinted background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                ImageConverter(
                  imagePath: 'assets/icon/ev.svg',
                  isAssets: true,
                  color: iconColor,
                  width: ScreenSize.width * 0.08,
                ),
                SizedBox(width: 12),
                // Name and Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chargePointIdentity ?? "Unknown",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          isOffline
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: colorWhiteGrey,
                                  ),
                                  child: ImageConverter(
                                    imagePath: chargeType,
                                    isAssets: true,
                                  ),
                                )
                              : ImageConverter(
                                  imagePath: chargeType,
                                  isAssets: true,
                                ),
                          SizedBox(width: 8),
                          Text(
                            connectorType ?? "",
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM SECTION: Max Power and Rate (White box)
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(
                  'max-power'.tr(),
                  ratedPower ?? "-",
                  textColor,
                ),
                _buildInfoColumn('rate'.tr(), rate ?? "-", textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
