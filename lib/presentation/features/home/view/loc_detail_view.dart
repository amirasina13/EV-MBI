import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../../../widgets/data_driven/data_driven.dart';
import '../../../widgets/extensions/home/connector_view.dart';
import '../../../widgets/independent/independent.dart';
import '../home.dart';

class LocationDetailView extends StatefulWidget {
  final Function? changeView;

  const LocationDetailView({super.key, this.changeView});

  @override
  State<LocationDetailView> createState() => _LocationDetailViewState();
}

class _LocationDetailViewState extends State<LocationDetailView> {
  var connectorTiles = [];
  final bool _enabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LocationDetailsLoaded) {
            var detail = state.details;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: ScreenSize.height * 0.38,
                  collapsedHeight: ScreenSize.height * 0.38,
                  floating: false,
                  pinned: false,
                  // snap: true,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor:
                        colorTransparent, // this one will make the statusbar transparent
                    statusBarIconBrightness: Brightness
                        .light, //this will take care of the icon color
                  ),
                  flexibleSpace: Stack(
                    children: <Widget>[
                      // ----------------------------------------------------------- Image
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ScreenSize.height * 0.17,
                          ),
                          child: Container(
                            width: ScreenSize.width,
                            alignment:
                                Alignment.center, // where to position the child
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [colorGreenGradient, colorBlueGradient],
                              ),
                            ),
                            child: ImageConverter(
                              imagePath: detail.imagePath!,
                              isAssets: false,
                              fit: BoxFit.cover,
                              width: double
                                  .infinity, // Tells the image to be as wide as possible
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      // ----------------------------------------------------------- Detail box
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: ScreenSize.height * 0.22,
                          margin: EdgeInsets.symmetric(
                            horizontal: marginHorizontal,
                          ),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: colorWhite,
                            border: Border.all(color: colorGreyBox),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 3.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                detail.place!,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: colorBlack),
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: ImageConverter(
                                      imagePath: 'assets/icon/map.svg',
                                      isAssets: true,
                                      width: ScreenSize.width * 0.04,
                                      color: colorIconGrey,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      detail.fullAddress!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: colorIconGrey),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Distance Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorWhiteGrey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: ScreenSize.height * 0.04,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 3,
                                          ),
                                          child: ImageConverter(
                                            imagePath:
                                                'assets/icon/distance.svg',
                                            isAssets: true,
                                            color: colorBlueGradient,
                                          ),
                                        ),
                                        Text(
                                          '${double.parse(detail.distance ?? '0').toStringAsFixed(2)} km',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorBlueGradient,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      LaunchMapDialog.showModalBottom(
                                        context,
                                        detail,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorWhiteGrey,
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            colorGreenGradient,
                                            colorBlueGradient,
                                          ],
                                        ),
                                      ),
                                      height: ScreenSize.height * 0.04,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                        color: colorWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'available-connector'.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        detail.connectors!.isNotEmpty
                            ? Text(
                                '${detail.connectors!.length} ${'connector'.tr()}',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(color: colorIconGrey),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildConnectorList(context, detail.connectors!),
                ),
              ],
            );
          }

          return _historyLoading();
        },
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
                  height: ScreenSize.height * 0.21,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  color: colorWhite,
                ),
                // Box 2
                Container(
                  height: ScreenSize.height * 0.19,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                ),
                // Box 3
                Container(
                  height: ScreenSize.height * 0.04,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  color: colorWhite,
                ),
                // Box 4
                Container(
                  height: ScreenSize.height * 0.2,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                // Box 5
                Container(
                  height: ScreenSize.height * 0.2,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
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

  Widget _buildConnectorList(
    BuildContext context,
    List<ConnectorDetail> connectors,
  ) {
    if (connectors.isEmpty) {
      return Center(
        child: Container(
          height: ScreenSize.height * 0.35,
          color: colorWhite,
          margin: EdgeInsets.only(bottom: ScreenSize.height * 0.15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenSize.width * 0.2,
                width: ScreenSize.width * 0.2,
                child: ImageConverter(
                  imagePath: 'assets/icon/notAvailableEV.svg',
                  isAssets: true,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: ScreenSize.height * 0.03),
              Text(
                'no-available-connector'.tr(),
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

    connectorTiles = connectors
        .map(
          (historyList) =>
              historyList.getconnectorTile(context: context, onTap: () {}),
        )
        .toList(growable: false);

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 50),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: connectors.length,
      itemBuilder: (BuildContext context, int index) {
        return connectorTiles[index];
      },
    );
  }
}
