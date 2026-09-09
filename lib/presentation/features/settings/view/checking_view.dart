import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../config/config.dart';
import '../../../widgets/independent/independent.dart';
import '../../register/register.dart';

class CheckingView extends StatefulWidget {
  final Function changeView;
  const CheckingView({super.key, required this.changeView});

  @override
  State<CheckingView> createState() => _CheckingViewState();
}

class _CheckingViewState extends State<CheckingView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(marginHorizontal, 0, marginHorizontal, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(top: 30, bottom: 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorWhite,
                border: Border.all(color: colorWhite, width: 2),
              ),
              child: ClipOval(
                child: ImageConverter(
                  imagePath: 'assets/icon/no_photo.webp',
                  isAssets: true,
                ),
              ),
            ),
            Text(
              'profile-checking'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CustomStyleButton(
              height: ScreenSize.height / 18,
              borderRadius: 30,
              title: 'create-acc'.tr(),
              textColor: colorWhite,
              iconColor: colorWhite,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  MainRoutes.register,
                  arguments: RegisterParameters(referralCode: ''),
                );
              },
              icon: Icons.person_add_alt_1,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'have-acc'.tr(),
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    CustomStyleButton(
                      height: ScreenSize.height / 18,
                      borderRadius: 30,
                      title: 'signin-btn'.tr(),
                      onPressed: () {
                        Navigator.of(context).pushNamed(MainRoutes.login);
                      },
                      backgroundColor: colorTransparent,
                      borderColor: colorBlack,
                      textColor: colorBlack,
                      // icon: Icons.person_add_alt_1,
                    ),
                    SizedBox(height: 10),
                    CustomButtonText(
                      'guest-btn'.tr(),
                      color: colorOrange,
                      // fontSize: 16,
                      fontWeight: FontWeight.bold,
                      onClick: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          MainRoutes.home,
                          (route) => false,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
