import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/data_driven/webview.dart';
import '../../../widgets/independent/independent.dart';
import '../../auth/auth.dart';
import '../../profile/profile.dart';
import '../checking_screen.dart';

class SettingView extends StatefulWidget {
  final Function changeView;
  const SettingView({super.key, required this.changeView});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isTokenEmpty = false;
  Widget? image;
  String profileImage = '', name = 'Unknown', code = '', langParam = '';
  int languageValue = 0, currentLangIndex = 0;

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('lang') ?? 'en';
    setState(() {
      languageValue = lang == 'en' ? 0 : 1;
      currentLangIndex = languageValue;

      langParam = currentLangIndex == 0 ? 'en' : 'bm';
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _setProfileData(state);
        }
        if (state is ProfileTokenEmpty || state is ProfileSessionError) {
          isTokenEmpty = true;
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorGreenGradient, colorBlueGradient],
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isTokenEmpty
                  ? SizedBox(
                      child: Text(
                        'settings'.tr(),
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontSize: 40, color: colorWhite),
                      ),
                    )
                  : Row(
                      children: [
                        Container(
                          height: ScreenSize.height * 0.08,
                          decoration: BoxDecoration(
                            color: colorWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: ScreenSize.width * 0.008,
                              color: colorLightGrey,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipOval(child: image),
                          ),
                        ),
                        SizedBox(width: 7),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 3, top: 10),
                              child: Text(
                                name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: colorWhite),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 3),
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                code,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: colorWhite),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              ToggleSwitch(
                minWidth: 50.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [colorGreenGradient],
                  [colorGreenGradient],
                ],
                activeFgColor: colorWhite,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: currentLangIndex,
                totalSwitches: 2,
                labels: ['EN', 'BM'],
                radiusStyle: true,
                onToggle: (index) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    languageValue = 0;
                    currentLangIndex = index!;
                  });

                  langParam = currentLangIndex == 0 ? 'en' : 'bm';

                  if (index == 0) {
                    await prefs.setString('lang', 'en');
                    // ignore: use_build_context_synchronously
                    context.setLocale(const Locale('en', 'US'));
                  } else if (index == 1) {
                    await prefs.setString('lang', 'ms');
                    // ignore: use_build_context_synchronously
                    context.setLocale(const Locale('ms', 'MY'));
                  }
                },
              ),
            ],
          ),
          bottomMenuIndex: 4,
          isShow: true,
          body: Container(
            padding: EdgeInsets.only(top: 20),
            height: height * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              // Optional: Add a subtle shadow to make it look like it's sliding over the background
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    0,
                    marginHorizontal,
                    5,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'my-account'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorDarkGray),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomMenuLine(
                    title: 'my-account'.tr(),
                    icon: Icon(Icons.person),
                    onTap: (() {
                      Storage().fromPage = 'profile';
                      Navigator.of(context).pushNamed(
                        MainRoutes.account,
                        // (Route<dynamic> route) => false,
                        arguments: CheckingParameters(fromPage: 'profile'),
                      );
                    }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    20,
                    marginHorizontal,
                    5,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'reason-6'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorDarkGray),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CustomMenuLine(
                        title: 'app-walkthrough'.tr(),
                        icon: Icon(Icons.lightbulb),
                        onTap: (() => {
                          Navigator.push(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) {
                                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                return WidgetWebView(
                                  widgetUrl: '$urlWalkthrough?lang=$langParam',
                                  title: 'app-walkthrough'.tr(),
                                );
                              },
                            ),
                          ),
                        }),
                      ),
                      CustomMenuLine(
                        title: 'charging-guide'.tr(),
                        icon: Icon(Icons.charging_station_outlined),
                        onTap: (() => {
                          Navigator.push(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) {
                                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                return WidgetWebView(
                                  widgetUrl:
                                      '$urlChargingGuide?lang=$langParam',
                                  title: 'charging-guide'.tr(),
                                );
                              },
                            ),
                          ),
                        }),
                      ),
                      CustomMenuLine(
                        title: 'terms-use'.tr(),
                        icon: Icon(Icons.article),
                        onTap: (() => {
                          Navigator.push(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) {
                                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                return WidgetWebView(
                                  widgetUrl: urlTerm,
                                  title: 'terms-use'.tr(),
                                );
                              },
                            ),
                          ),
                        }),
                      ),
                      CustomMenuLine(
                        title: 'privacy-policy'.tr(),
                        icon: Icon(Icons.security),
                        onTap: (() => {
                          Navigator.push(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) {
                                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                return WidgetWebView(
                                  widgetUrl: urlPolicy,
                                  title: 'privacy-policy'.tr(),
                                );
                              },
                            ),
                          ),
                        }),
                      ),
                      isTokenEmpty
                          ? SizedBox()
                          : BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                if (state is AuthUnauthenticated) {
                                  showSuccessToast(
                                    'Successfully Logout',
                                    context,
                                  );

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    MainRoutes.home,
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return CustomMenuLine(
                                  title: 'logout'.tr(),
                                  icon: Icon(Icons.login),
                                  onTap: (() {
                                    BlocProvider.of<AuthBloc>(
                                      context,
                                    ).add(AuthLoggedOut());
                                  }),
                                );
                              },
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

  void _setProfileData(ProfileState state) {
    var profile = (state as ProfileLoaded).userProfile;

    // ignore: unnecessary_null_comparison
    if (profile != null) {
      profileImage = profile.image!;
      name = profile.name!.isEmpty ? 'Unknown' : profile.name!;
      code = profile.code!;

      if (profileImage.isNotEmpty) {
        image = ImageConverter(
          imagePath: profileImage,
          isAssets: false,
          fit: BoxFit.fitWidth,
        );
      } else {
        image = ImageConverter(
          imagePath: 'assets/icon/no_photo.svg',
          isAssets: true,
        );
      }
    }
  }
}
