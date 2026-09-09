import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../widgets/data_driven/launch_map_dialog.dart';
import '../../../widgets/independent/independent.dart';
import '../../home/home.dart';

class MapView extends StatefulWidget {
  final Function changeView;

  const MapView({super.key, required this.changeView});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<LocationHome> listLocation = [];
  LatLng? selectedMarker;
  bool isSelected = false;

  LatLng? currentLocation;

  MapboxMap? mapboxMap;
  PointAnnotationManager? pointManager;

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: geo.LocationAccuracy.high,
    );

    if (!mounted) return;
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> addMarkers(
    List<LocationHome> locations,
    Uint8List imageData,
  ) async {
    if (mapboxMap == null) return;

    pointManager ??= await mapboxMap!.annotations
        .createPointAnnotationManager();

    // Clear existing annotations if necessary
    await pointManager!.deleteAll();

    List<PointAnnotationOptions> options = locations.map((item) {
      return PointAnnotationOptions(
        // Ensure your LocationHome model has lat/lng fields
        geometry: Point(
          coordinates: Position(
            double.parse(item.longitude!),
            double.parse(item.latitude!),
          ),
        ),
        image: imageData,
        textOffset: [0, 2.0],
        iconSize: 3,
      );
    }).toList();

    // Add the annotation to the map
    await pointManager!.createMulti(options);

    // Set up the listener
    // ignore: deprecated_member_use
    pointManager!.addOnPointAnnotationClickListener(
      MarkerClickListener((annotation) {
        final clicked = listLocation.firstWhere(
          (loc) =>
              double.parse(loc.longitude!) ==
                  annotation.geometry.coordinates.lng &&
              double.parse(loc.latitude!) ==
                  annotation.geometry.coordinates.lat,
        );
        launchMapInfo(clicked);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoaded) {
          listLocation = state.homePage.locations!;

          return Center(
            child: currentLocation == null
                ? const LoadingWidget()
                : MapWidget(
                    key: const ValueKey(
                      "mapbox_map",
                    ), // Keeps the widget state stable
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          currentLocation!.longitude,
                          currentLocation!.latitude,
                        ),
                      ),
                      zoom: 13,
                    ),
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    onMapCreated: (mapboxMap) async {
                      this.mapboxMap = mapboxMap;

                      // Load the image from assets
                      final ByteData bytes = await rootBundle.load(
                        'assets/icon/inUseEVnoCircle_small.png',
                      );
                      final Uint8List imageData = bytes.buffer.asUint8List();

                      mapboxMap.location.updateSettings(
                        LocationComponentSettings(
                          enabled: true,
                          pulsingEnabled: true,
                          // You can even change the puck to a 2D or 3D model here
                          puckBearingEnabled: true,
                        ),
                      );

                      addMarkers(listLocation, imageData);
                    },
                  ),
          );
        }
        return Center(child: LoadingWidget());
      },
    );
  }

  launchMapInfo(LocationHome station) async {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Your station title
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: marginHorizontal,
                          ),
                          child: Text(
                            station.place!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: marginHorizontal,
                          ),
                          color: colorWhite,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                  top: 3,
                                ),
                                child: ImageConverter(
                                  imagePath: 'assets/icon/map.svg',
                                  isAssets: true,
                                  width: ScreenSize.width * 0.035,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${station.address}, ${station.addressTwo}, ${station.postCode} ${station.city}, ${station.state}, ${station.country}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: marginHorizontal,
                          ),
                          color: colorWhite,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4,
                                  top: 3,
                                ),
                                child: ImageConverter(
                                  imagePath: 'assets/icon/distance.svg',
                                  isAssets: true,
                                  width: ScreenSize.width * 0.035,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${station.distance!} KM',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: marginHorizontal,
                          ),
                          color: colorWhite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    ImageConverter(
                                      imagePath: 'assets/icon/availableEV.svg',
                                      isAssets: true,
                                      width: ScreenSize.width * 0.06,
                                    ),
                                    Text(
                                      '${station.connectors!.available}',
                                      style: TextStyle(
                                        color: colorGreenGradient,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    ImageConverter(
                                      imagePath:
                                          'assets/icon/notAvailableEV.svg',
                                      isAssets: true,
                                      width: ScreenSize.width * 0.06,
                                    ),
                                    Text(
                                      '${station.connectors!.unavailable}',
                                      style: TextStyle(
                                        color: colorIconGrey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ImageConverter(
                                      imagePath:
                                          'assets/icon/inUseEVnoCircle.svg',
                                      isAssets: true,
                                      width: ScreenSize.width * 0.06,
                                    ),
                                  ),
                                  Text(
                                    '${station.connectors!.inuse}',
                                    style: TextStyle(
                                      color: colorBlueGradient,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            marginHorizontal,
                            10,
                            marginHorizontal,
                            50,
                          ),
                          color: colorWhite,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomStyleButton(
                                  title: 'details-btn'.tr(),
                                  textColor: colorWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: ScreenSize.height / 22,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      MainRoutes.locationDetail,
                                      arguments: LocationDetailParameters(
                                        uuid: station.uuid!,
                                      ),
                                    );
                                  },
                                  backgroundColor: colorGreenGradient,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: CustomStyleButton(
                                  title: 'navigate-btn'.tr(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: ScreenSize.height / 22,
                                  onPressed: () {
                                    Navigator.pop(context);

                                    LaunchMapDialog.showModalBottom(
                                      context,
                                      station,
                                    );
                                  },
                                  backgroundColor: colorBlueGradient,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((onValue) {
      setState(() {
        selectedMarker = null;
      });
    });
  }
}

// ignore: deprecated_member_use
class MarkerClickListener extends OnPointAnnotationClickListener {
  final Function(PointAnnotation) onClick;

  MarkerClickListener(this.onClick);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
  }
}
