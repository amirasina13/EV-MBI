import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/config.dart';
import '../../features/settings/checking_screen.dart';
import 'independent.dart';

/* Widget class for bottom menu. Will use mostly in independent/scaffold.dart (custom scaffold) */
class CustomBottomMenu extends StatelessWidget {
  final int menuIndex;
  final bool isShow;
  final bool canClick;

  // ignore: use_key_in_widget_constructors
  const CustomBottomMenu(this.menuIndex, this.isShow, this.canClick);

  BottomNavigationBarItem getItem(
    BuildContext context,
    String imageSelected,
    String image,
    String title,
    ThemeData theme,
    int index,
    bool isShow,
    IconData? icon,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          index != 2
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.028,
                  width: MediaQuery.of(context).size.height * 0.028,
                  padding: EdgeInsets.only(right: 0, top: 1),
                  child: ImageConverter(
                    imagePath: imageSelected,
                    isAssets: true,
                    fit: BoxFit.contain,
                    color: index == menuIndex && isShow == true
                        ? colorGreenGradient
                        : colorUsedGray,
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(13),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorGreenGradient, colorBlueGradient],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorGreenGradient.withValues(alpha: 0.2),
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0),
                      ),
                    ],
                  ),
                  child: ImageConverter(
                    imagePath: 'assets/icon/scan.svg',
                    isAssets: true,
                    color: colorWhite,
                    height: ScreenSize.height * 0.035,
                  ),
                ),
          index != 2
              ? Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: fontFamilyMain,
                      color: index == menuIndex && isShow == true
                          ? colorGreenGradient
                          : colorUsedGray,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Pass image icon, title, theme, index no and isShow
    List<BottomNavigationBarItem> menuItems = [
      getItem(
        context,
        imageSelected1,
        imageUnselected1,
        title1.tr(),
        theme,
        0,
        isShow,
        FontAwesomeIcons.house,
      ),
      getItem(
        context,
        imageSelected2,
        imageUnselected2,
        title2.tr(),
        theme,
        1,
        isShow,
        FontAwesomeIcons.mapLocationDot,
      ),
      getItem(
        context,
        '',
        imageUnselected3,
        title3.tr(),
        theme,
        2,
        isShow,
        null,
      ),
      getItem(
        context,
        imageSelected4,
        imageUnselected4,
        title4.tr(),
        theme,
        3,
        isShow,
        FontAwesomeIcons.chargingStation,
      ),
      getItem(
        context,
        imageSelected5,
        imageUnselected5,
        title5.tr(),
        theme,
        4,
        isShow,
        FontAwesomeIcons.userGear,
      ),
    ];

    // Custom design for bottom menu
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(color: colorLightGrey, spreadRadius: 0, blurRadius: 2),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          // Removes the grey circle "splash" effect
          splashColor: Colors.transparent,
          // Remove the "glow" effect
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: colorWhite,
          unselectedLabelStyle: TextStyle(
            height: 0,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamilyMain,
          ),
          selectedLabelStyle: TextStyle(
            height: 0,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamilyMain,
          ),
          selectedItemColor: isShow == true
              ? colorBlack
              : Colors.grey.withValues(alpha: 1.0),
          currentIndex: menuIndex,
          onTap: (value) async {
            if (value != menuIndex) {
              switch (value) {
                case 0:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.home,
                    (Route<dynamic> route) => false,
                  );

                  break;
                case 1:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.map,
                    (Route<dynamic> route) => false,
                  );

                  break;
                case 2:
                  Storage().fromPage = 'scan';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.account,
                    (Route<dynamic> route) => false,
                    arguments: CheckingParameters(fromPage: 'scan'),
                  );
                  break;
                case 3:
                  Storage().fromPage = 'history';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.account,
                    (Route<dynamic> route) => false,
                    arguments: CheckingParameters(fromPage: 'session'),
                  );

                  break;
                case 4:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.setting,
                    (Route<dynamic> route) => false,
                  );

                  break;
              }
            } else if (value == menuIndex && canClick == true) {
              switch (value) {
                case 0:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.home,
                    (Route<dynamic> route) => false,
                  );

                  break;
                case 1:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.map,
                    (Route<dynamic> route) => false,
                  );
                  break;
                case 2:
                  Storage().fromPage = 'scan';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.account,
                    (Route<dynamic> route) => false,
                    arguments: CheckingParameters(fromPage: 'scan'),
                  );
                  break;

                case 3:
                  Storage().fromPage = 'history';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.account,
                    (Route<dynamic> route) => false,
                    arguments: CheckingParameters(fromPage: 'session'),
                  );
                  break;

                case 4:
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.setting,
                    (Route<dynamic> route) => false,
                  );
                  break;
              }
            }
          },
          items: menuItems,
        ),
      ),
    );
  }
}
