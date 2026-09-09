import 'package:ev_charger/config/config.dart';
import 'package:ev_charger/presentation/widgets/independent/independent.dart';
import 'package:flutter/material.dart';

import '../../../../data/data.dart';

/* Extension class for point location list  */
extension View on LocationHome {
  Widget getLocationTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: ScreenSize.width * 0.63,
      child: Padding(
        padding: const EdgeInsets.only(right: 25),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorGreyBox,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageConverter(
                      imagePath: imagePath!,
                      isAssets: false,
                      fit: BoxFit
                          .cover, // Image will now respect its natural height
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place ?? "",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5, top: 3),
                              child: ImageConverter(
                                imagePath: 'assets/icon/map.svg',
                                isAssets: true,
                                width: ScreenSize.width * 0.035,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                fullAddress!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: colorDarkGray),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4, top: 3),
                            child: ImageConverter(
                              imagePath: 'assets/icon/distance.svg',
                              isAssets: true,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${distance!} KM',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colorDarkGray),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildConnectorIcon(
                              context,
                              'assets/icon/availableEV.svg',
                              connectors!.available,
                              colorGreenGradient,
                            ),
                            const SizedBox(width: 20),
                            _buildConnectorIcon(
                              context,
                              'assets/icon/notAvailableEV.svg',
                              connectors!.unavailable,
                              colorIconGrey,
                            ),
                            const SizedBox(width: 20),
                            _buildConnectorIcon(
                              context,
                              'assets/icon/inUseEVnoCircle.svg',
                              connectors!.inuse,
                              colorBlueGradient,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectorIcon(
    BuildContext context,
    String path,
    dynamic count,
    Color textColor,
  ) {
    return Row(
      children: [
        ImageConverter(
          imagePath: path,
          isAssets: true,
          width: ScreenSize.width * 0.05,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: textColor),
        ),
      ],
    );
  }
}
