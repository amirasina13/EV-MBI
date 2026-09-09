import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../config/config.dart';
import '../independent/independent.dart';

class LaunchMapDialog extends StatelessWidget {
  final dynamic detail;
  final List<AvailableMap> availableMaps;

  const LaunchMapDialog({
    super.key,
    required this.detail,
    required this.availableMaps,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: availableMaps.length > 1
                ? ScreenSize.height * 0.35
                : ScreenSize.height * 0.25,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: CustomScrollView(
              primary: false,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ScreenSize.width,
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        color: colorWhite,
                        child: Text(
                          'open-with'.tr(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        color: colorWhite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Wrap(
                              children: <Widget>[
                                for (var map in availableMaps)
                                  ListTile(
                                    onTap: () => map.showDirections(
                                      destination: Coords(
                                        double.parse(detail.latitude!),
                                        double.parse(detail.longitude!),
                                      ),
                                      destinationTitle: detail.fullAddress,
                                      directionsMode: DirectionsMode.driving,
                                    ),
                                    title: Text(
                                      map.mapName,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    leading: SvgPicture.asset(
                                      map.icon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future showModalBottom(BuildContext context, dynamic detail) async {
    final availableMaps = await MapLauncher.installedMaps;

    return showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      backgroundColor: colorWhite,
      builder: (context) {
        return LaunchMapDialog(detail: detail, availableMaps: availableMaps);
      },
    );
  }
}
