import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../widgets/extensions/home/location_view.dart';
import '../../../widgets/independent/independent.dart';
import '../home.dart';

class HomeView extends StatefulWidget {
  final Function changeView;
  const HomeView({super.key, required this.changeView});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  geoloc.LocationAccuracyStatus? accuracy;
  String? currentLatitude,
      currentLongitude,
      saveCurrentLatitude,
      saveCurrentLongitude;

  List<LocationHome> listLocation = [];
  Total? homepageHeader = Total();

  var locationTiles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 15),
                    totalSection(context, state),
                    SizedBox(height: 20),
                  ]),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody:
                    false, // Allows the white box to be as tall as the screen
                child: Container(
                  padding: EdgeInsets.all(marginHorizontal),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: const BorderRadius.only(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: ScreenSize.width * 0.01,
                            height: ScreenSize.height * 0.028,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [colorGreenGradient, colorBlueGradient],
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Text(
                            'station-title'.tr(),
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: Platform.isAndroid ? 320 : 315,
                        child: _buildLocationList(context, state),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget totalSection(BuildContext context, HomeState homeState) {
    if (homeState is HomeLoaded) {
      homepageHeader = homeState.homePage.total;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TOP SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CustomContainer(
                title: homepageHeader?.locations?.toString() ?? '0',
                subtitle: 'home-label-1'.tr(),
                header: Expanded(
                  child: ImageConverter(
                    imagePath: 'assets/icon/map.svg',
                    isAssets: true,
                    color: colorGreenGradient,
                    height: ScreenSize.height * 0.03,
                  ),
                ),
              ),
            ),
            SizedBox(width: ScreenSize.width * 0.04),
            Expanded(
              child: CustomContainer(
                title: homepageHeader?.connectors?.toString() ?? '0',
                subtitle: 'home-label-2'.tr(),
                padding: EdgeInsets.symmetric(vertical: 10),
                header: Expanded(
                  child: ImageConverter(
                    imagePath: 'assets/icon/ev.svg',
                    isAssets: true,
                    height: ScreenSize.height * 0.035,
                  ),
                ),
              ),
            ),
            SizedBox(width: ScreenSize.width * 0.04),
            Expanded(
              child: CustomContainer(
                title: homepageHeader?.available?.toString() ?? '0',
                subtitle: 'home-label-3'.tr(),
                padding: EdgeInsets.symmetric(vertical: 10),
                header: Expanded(
                  child: ImageConverter(
                    imagePath: 'assets/icon/availableEV.svg',
                    isAssets: true,
                    height: ScreenSize.height * 0.036,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationList(BuildContext context, HomeState homeState) {
    if (homeState is HomeLoaded) {
      listLocation = homeState.homePage.locations!;
    }

    if (homeState is HomeEmpty || listLocation.isEmpty) {
      return Center(
        child: Container(
          color: colorWhite,
          margin: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenSize.width * 0.2,
                width: ScreenSize.width * 0.2,
                child: ImageConverter(
                  imagePath: 'assets/icon/location.svg',
                  isAssets: true,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: ScreenSize.height * 0.03),
              Text(
                "No Available Locations",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: colorUsedGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    locationTiles = listLocation
        .map(
          (locationList) => locationList.getLocationTile(
            context: context,
            onTap: () {
              Navigator.of(context).pushNamed(
                MainRoutes.locationDetail,
                arguments: LocationDetailParameters(uuid: locationList.uuid!),
              );
            },
          ),
        )
        .toList(growable: false);

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: listLocation.length,
      itemBuilder: (BuildContext context, int index) {
        return locationTiles[index];
      },
    );
  }
}
