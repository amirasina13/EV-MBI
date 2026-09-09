import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/config.dart';
import '../../../../data/model/global/country_list.dart';
import '../../../helper/helper.dart';
import '../../../widgets/data_driven/connectivity_check.dart';
import '../../../widgets/data_driven/value_select.dart';
import '../../../widgets/independent/independent.dart';
import '../../country/country.dart';
import '../../maintenance/maintenance.dart';
import '../../photo/photo.dart';
import '../profile.dart';

class Profileview extends StatefulWidget {
  final Function changeView;
  const Profileview({super.key, required this.changeView});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  bool error = false, profileEvalid = false, hasProfileData = false;
  bool isProcessing = false;

  Widget? image;
  late File _image;
  var photoBloc = PhotoBloc();
  String? path, imageBytes;

  String errorfield = '',
      errorFullName = '',
      errorFirstName = '',
      errorLastName = '',
      errorEmail = '',
      errorContact = '',
      profileImage = '';

  String selectedCode = '60';

  List<String> getCode = [];

  final ImagePicker _picker = ImagePicker();

  late FocusNode nickFocus, firstFocus, lastFocus, emailFocus, contactFocus;

  final MyConnectivity _connectivity = MyConnectivity.instance;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<CustomInputFieldState> _fullNameKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> _firstNameKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> _lastNameKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> _emailKey = GlobalKey();
  final GlobalKey<CustomInputFieldState> _contactKey = GlobalKey();
  final GlobalKey<CustomSelectValueState> codeKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    nickFocus = FocusNode();
    firstFocus = FocusNode();
    lastFocus = FocusNode();
    emailFocus = FocusNode();
    contactFocus = FocusNode();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();

    // Clean up the focus node when the Form is disposed.
    nickFocus.dispose();
    firstFocus.dispose();
    lastFocus.dispose();
    emailFocus.dispose();
    contactFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sizeBetween = ScreenSize.height / 20;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _setProfileData(state);
        }
        if (state is ProfileError) {
          setProcessingStatus(false);
          // ignore: unnecessary_null_comparison
          state.error != null ? error = true : error = false;
          showErrorToast(state.error, context);
        }

        if (state is ProfileEditLoaded) {
          errorfield = state.errorField;
        }
        if (state is ProfileUpdated) {
          setProcessingStatus(false);
          // FocusScope.of(context).unfocus();

          BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());

          // if (hasProfileData) {
          //   showSuccessToast(state.message, context);
          // } else {
          showSuccessToast(state.message, context);

          Navigator.of(context).pushNamedAndRemoveUntil(
            MainRoutes.home,
            (Route<dynamic> route) => false,
          );
          // }
        }
        if (state is ProfilePhotoUpdated) {
          BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          showSuccessToast(state.message, context);
        }

        if (state is ProfileMaintenanceError) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainRoutes.maintenanceScreen,
            (Route<dynamic> route) => false,
            arguments: MaintenanceParameters(message: state.message),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainRoutes.setting,
                (Route<dynamic> route) => false,
              );
            },
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: errorfield == '' ? colorDarkGray : colorRed,
                ),
              ),

              child: SingleChildScrollView(
                child: Container(
                  color: colorWhite,
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BlocProvider<PhotoBloc>.value(
                        value: photoBloc,
                        child: BlocConsumer<PhotoBloc, PhotoState>(
                          listener: (context, photoState) {
                            if (photoState is PhotoSet) {
                              _showPhotoConfirmDialog(
                                context,
                                photoState.photo,
                              );
                            }
                          },
                          builder: (context, photoState) {
                            Widget? image;

                            if (profileImage.isNotEmpty) {
                              image = ImageConverter(
                                imagePath: profileImage,
                                isAssets: false,
                                fit: BoxFit.fitWidth,
                              );
                              // image = Image.network(
                              //   profileImage!,
                              //   fit: BoxFit.fitWidth,
                              // );
                            } else {
                              image = ImageConverter(
                                imagePath: 'assets/icon/user.svg',
                                isAssets: true,
                              );
                              // image = Image.asset('assets/icons/no_photo.png');
                            }

                            return Center(
                              child: Stack(
                                children: [
                                  Container(
                                    height: ScreenSize.height / 5.8,
                                    color: colorWhite,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: colorBabyBlue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: ScreenSize.width * 0.008,
                                            color: colorLightGrey,
                                          ),
                                        ),
                                        child: ClipOval(child: image),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 6,
                                    bottom: 0.0,
                                    child: InkWell(
                                      onTap: () =>
                                          _showSelectionDialog(context),
                                      child: Container(
                                        height: ScreenSize.height * 0.05,
                                        width: ScreenSize.height * 0.05,
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: ScreenSize.width * 0.008,
                                            color: colorLightGrey,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: colorGreenGradient,
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: sizeBetween * 0.5),
                      /* ----------------------------------------------------------- Nickname input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'name-display-title'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      CustomRoundField(
                        horizontalPadding: 0,
                        focusBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: error
                                ? colorRed
                                : errorfield == 'error' ||
                                      errorfield == 'errornick'
                                ? colorRed
                                : colorUsedGray,
                          ),
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        key: _fullNameKey,
                        controller: _fullNameController,
                        labelStyle: TextStyle(
                          color: error
                              ? colorRed
                              : errorfield == 'error' ||
                                    errorfield == 'errornick'
                              ? colorRed
                              : colorUsedGray,
                          fontSize: 13,
                        ),
                        validator: Validator.valueExists,
                        keyboard: TextInputType.text,
                        border: InputBorder.none,
                        focusNode: nickFocus,
                        onValueChanged: (value) {
                          if (state is ProfileEditLoaded && value != '') {
                            errorfield = '';
                            BlocProvider.of<ProfileBloc>(
                              context,
                            ).add(ProfileEditLoad(errorField: errorfield));
                          }
                        },
                      ),
                      errorfield == 'error' || errorfield == 'errornick'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorFullName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                            errorfield == 'errornick'
                                      ? colorRed
                                      : colorGreyBox,
                                ),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Firstname/Forename input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          'name-first-title'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: CustomRoundField(
                          focusBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                        errorfield == 'errorfirst'
                                  ? colorRed
                                  : colorUsedGray,
                            ),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          key: _firstNameKey,
                          controller: _firstNameController,
                          labelStyle: TextStyle(
                            color: error
                                ? colorRed
                                : errorfield == 'error' ||
                                      errorfield == 'errorfirst'
                                ? colorRed
                                : colorUsedGray,
                            fontSize: 13,
                          ),
                          validator: Validator.valueExists,
                          keyboard: TextInputType.text,
                          border: InputBorder.none,
                          focusNode: firstFocus,
                          onValueChanged: (value) {
                            if (state is ProfileEditLoaded && value != '') {
                              errorfield = '';
                              BlocProvider.of<ProfileBloc>(
                                context,
                              ).add(ProfileEditLoad(errorField: errorfield));
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorfirst'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorFirstName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                            errorfield == 'errorfirst'
                                      ? colorRed
                                      : colorGreyBox,
                                ),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Last Name/ Surname input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          'name-last-title'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: CustomRoundField(
                          focusBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                        errorfield == 'errorlast'
                                  ? colorRed
                                  : colorUsedGray,
                            ),
                            // borderRadius: BorderRadius.circular(25.0),
                          ),
                          key: _lastNameKey,
                          controller: _lastNameController,
                          labelStyle: TextStyle(
                            color: error
                                ? colorRed
                                : errorfield == 'error' ||
                                      errorfield == 'errorlast'
                                ? colorRed
                                : colorUsedGray,
                            fontSize: 13,
                          ),
                          validator: Validator.valueExists,
                          keyboard: TextInputType.text,
                          border: InputBorder.none,
                          focusNode: lastFocus,
                          onValueChanged: (value) {
                            if (state is ProfileEditLoaded && value != '') {
                              errorfield = '';
                              BlocProvider.of<ProfileBloc>(
                                context,
                              ).add(ProfileEditLoad(errorField: errorfield));
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorlast'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorLastName,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                            errorfield == 'errorlast'
                                      ? colorRed
                                      : colorGreyBox,
                                ),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Mobile No input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          'mobile-title'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          border: Border.all(
                            color: error
                                ? colorRed
                                : errorfield == 'error' ||
                                      errorfield == 'errorcontact'
                                ? colorRed
                                : colorUsedGray,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            BlocProvider<CountryBloc>(
                              create: (context) {
                                // creditRecords.clear();
                                return CountryBloc()..add(CountryLoad());
                              },
                              child: BlocConsumer<CountryBloc, CountryState>(
                                listener: (context, state) {
                                  if (state is CountryError) {
                                    showErrorToast(state.error, context);
                                    // ErrorDialog.showErrorDialog(
                                    //     context, state.error);
                                  }
                                },
                                builder: (context, state) {
                                  if (state is CountryListLoaded) {
                                    getCode = _getCodes(state.countries);
                                  }

                                  if (state is CountryNetworkError) {
                                    _connectivity.initialise();
                                    _connectivity.myStream.listen((
                                      source,
                                    ) async {
                                      var connectionResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (connectionResult.contains(
                                            ConnectivityResult.mobile,
                                          ) &&
                                          connectionResult.contains(
                                            ConnectivityResult.wifi,
                                          )) {
                                        if (!context.mounted) return;
                                        BlocProvider.of<CountryBloc>(
                                          context,
                                        ).add(CountryLoad());
                                      }
                                    });
                                  }

                                  return CustomSelectValue(
                                    key: codeKey,
                                    availableValues: getCode,
                                    selectedValue: selectedCode,
                                    hint: 'Code',
                                    onClick: ((String selectedValue) => {
                                      selectedCode = selectedValue,
                                    }),
                                    width: ScreenSize.width * 0.25,
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: CustomRoundField(
                                key: _contactKey,
                                controller: _contactController,
                                // hint: 'Example: 123456789',
                                validator: Validator.valueExists,
                                borderColor: colorWhite,
                                keyboard: TextInputType.number,
                                border: InputBorder.none,
                                // focusNode: contactFocus,
                                focusBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorWhite),
                                  // borderRadius: BorderRadius.circular(25.0),
                                ),
                                onValueChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      errorfield = '';
                                      error = false;
                                      _contactKey.currentState?.validate();
                                      // _contactKey.currentState.
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorcontact'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorContact,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                            errorfield == 'errorcontact'
                                      ? colorRed
                                      : colorGreyBox,
                                ),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Email input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          'email-title'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      _buildVerifiedEmail(state),
                      SizedBox(height: ScreenSize.height * 0.03),
                      /* ----------------------------------------------------------- Save changes button */
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(top: 20),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: CustomStyleButton(
                            height: ScreenSize.height / 18,
                            borderRadius: 30,
                            title: 'update-btn'.tr(),
                            textColor: colorWhite,
                            onPressed: () {
                              _validateAndUpdatePersonal();
                            },
                            backgroundColor: isProcessing ? processing : null,
                            // borderColor: colorGoldPerak,
                            // textColor: colorBlack,
                            // icon: Icons.person_add_alt_1,
                          ),
                        ),
                      ),
                      /* ----------------------------------------------------------- Acc Deletion button */
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: Text(
                            'delete-my-acc'.tr(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red.shade700,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        onTap: () {
                          if (!context.mounted) return;
                          Navigator.of(
                            context,
                          ).pushNamed(MainRoutes.deleteAccount).then((value) {
                            // if (!context.mounted) return;
                            // BlocProvider.of<ProfileBloc>(
                            //   context,
                            // ).add(ProfileLoad());
                          });
                        },
                      ),
                      SizedBox(height: ScreenSize.height * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerifiedEmail(ProfileState profileState) {
    return Container(
      margin: EdgeInsets.only(top: 17),
      child: CustomRoundField(
        focusBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: error
                ? colorRed
                : errorfield == 'error' || errorfield == 'erroremail'
                ? colorRed
                : colorUsedGray,
          ),
          // borderRadius: BorderRadius.circular(25.0),
        ),
        key: _emailKey,
        controller: _emailController,
        labelStyle: TextStyle(
          color: error
              ? colorRed
              : errorfield == 'error' || errorfield == 'erroremail'
              ? colorRed
              : colorUsedGray,
          fontSize: 13,
        ),
        validator: Validator.valueExists,
        keyboard: TextInputType.text,
        border: InputBorder.none,
        // suffixIcon: Container(
        //   margin: EdgeInsets.only(right: 10),
        //   child: _buildVerifyEmail(context, profileState),
        // ),
        readOnly: true,
        readOnlyColor: colorLightGrey,
        textAlignVertical: TextAlignVertical.center,
        focusNode: emailFocus,
        onValueChanged: (value) {
          if (profileState is ProfileEditLoaded && value != '') {
            errorfield = '';
            BlocProvider.of<ProfileBloc>(
              context,
            ).add(ProfileEditLoad(errorField: errorfield));
          }
        },
      ),
    );
  }

  Future _showSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select-photo'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: colorBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'take-photo'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'pick-gallery'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'cancel-btn'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorRed,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 300,
        maxWidth: 300,
      );

      if (pickedFile != null) {
        _cropImage(File(pickedFile.path));
      }
    } catch (e) {
      // print("Error picking image: $e");
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: colorBlack,
          backgroundColor: colorBlack,
          hideBottomControls: true,
          statusBarLight: true,
          toolbarWidgetColor: colorWhite,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          dimmedLayerColor: colorTransparent,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Image Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(width: 520, height: 520),
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
        photoBloc.add(GetPhoto(photo: _image));
      });
    }
  }

  Future _showPhotoConfirmDialog(BuildContext context, File photo) {
    var bytes = photo.readAsBytesSync();
    imageBytes = base64Encode(bytes);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Column(
            children: [
              Text(
                'upload-photo-confirmation'.tr(),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Divider(thickness: 1, color: Colors.grey.shade300),
            ],
          ),
          content: Container(
            color: colorWhite,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: ScreenSize.height / 5.5,
                    height: ScreenSize.height / 5.5,
                    decoration: BoxDecoration(
                      color: colorTransparent,
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.file(photo).image,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomStyleButton(
                          // backgroundColor: colorGoldPerak,
                          height: ScreenSize.height / 18,
                          width: ScreenSize.width,
                          title: 'update-photo'.tr(),
                          onPressed: _confirmUpdatePhoto,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5, top: 10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: colorRed,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmUpdatePhoto() {
    Navigator.pop(context);

    BlocProvider.of<ProfileBloc>(
      context,
    ).add(ProfilePhotoUpdate(image: imageBytes!));
  }

  List<String> _getCodes(List<CountryList> countries) {
    List<String> codes = [];
    for (var value in countries) {
      codes.add(value.callCode ?? '');
    }

    return codes;
  }

  // Widget _buildVerifyEmail(BuildContext context, ProfileState profileState) {
  //   if (!profileEvalid) {
  //     return Container(
  //       // color: colorBackground,
  //       width: MediaQuery.of(context).size.width * 0.16,
  //       alignment: Alignment.centerRight,
  //       child: CustomTextButton(
  //         text: 'Verify Email',
  //         // fontSize: 10,
  //         // color: colorBlueGradient,
  //         padding: EdgeInsets.zero,
  //         onPressed: () {
  //           // Navigator.of(context).pushNamed(
  //           //   MainRoutes.verifyEmail,
  //           //   arguments: VerifyEmailParameters(email: Storage().verifyEmail),
  //           // );
  //         },
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       // color: colorLightBlue,
  //       width: MediaQuery.of(context).size.width * 0.16,
  //       alignment: Alignment.centerRight,
  //       child: Text(
  //         'Verified',
  //         style: TextStyle(fontSize: 10, color: colorGreenGradient),
  //       ),
  //     );
  //   }
  // }

  void _validateAndUpdatePersonal() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (_fullNameController.text.isEmpty) {
      errorfield = 'errornick';
      nickFocus.requestFocus();
      errorFullName = 'Nickname is required!';
      // showErrorToast('Nickname cannot be empty', context);

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_firstNameController.text.isEmpty) {
      errorfield = 'errorfirst';
      firstFocus.requestFocus();
      errorFirstName = 'First Name is required!';
      // showErrorToast('First Name/ Forname cannot be empty', context);

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_lastNameController.text.isEmpty) {
      errorfield = 'errorlast';
      lastFocus.requestFocus();
      errorLastName = 'Last Name is required!';
      // showErrorToast('Last Name/ Surname cannot be empty', context);
      // ErrorDialog.showErrorDialog(
      //     context, 'Last Name/ Surname cannot be empty');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_emailController.text.isEmpty) {
      errorfield = 'erroremail';
      emailFocus.requestFocus();

      errorEmail = 'Email cannot be empty';
      // showErrorToast('Email cannot be empty', context);
      // ErrorDialog.showErrorDialog(context, 'Email cannot be empty');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else if (_contactController.text.isEmpty) {
      errorfield = 'errorcontact';
      contactFocus.requestFocus();
      errorContact = 'Please enter a valid mobile number';
      // showErrorToast('Please enter a valid mobile number', context);
      // ErrorDialog.showErrorDialog(context, 'Email cannot be empty');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else {
      setProcessingStatus(true);
      BlocProvider.of<ProfileBloc>(context).add(
        ProfileUpdate(
          surname: _lastNameController.text.trim(),
          forename: _firstNameController.text.trim(),
          name: _fullNameController.text.trim(),
          contact: '$selectedCode-${_contactController.text.trim()}',
          // email: _emailController.text.trim(),
          // dob: _dobController.text.trim(),
          // gender: _genderController.text.trim(),
        ),
      );
    }
  }

  void _setProfileData(ProfileState state) {
    var profile = (state as ProfileLoaded).userProfile;

    // ignore: prefer_typing_uninitialized_variables
    // var dateFormate;

    // print('PROFILE LOADED: $state');

    // if (profile!.dob!.isNotEmpty) {
    //   late var formatter = DateFormat(appDateFormat);
    //   dateFormate = formatter.format(DateTime.parse(profile.dob!));
    // } else {
    //   var dateNow = DateTime.now();
    //   late var formatter = DateFormat(appDateFormat);
    //   dateFormate = formatter.format(
    //     DateTime(dateNow.year - minAgeDOB, dateNow.month, dateNow.day),
    //   );
    // }

    // ignore: unnecessary_null_comparison
    if (profile != null) {
      _fullNameController.text = profile.name ?? '';
      _firstNameController.text = profile.forename ?? '';
      _lastNameController.text = profile.surname ?? '';
      // _dobController.text = dateFormate;
      _emailController.text = profile.email ?? '';
      // _contactController.text = profile.contact ?? '';
      _contactController.text = profile.contact!.substring(
        profile.contact!.indexOf("-") + 1,
      );
      // _genderController.text = profile.gender ?? '';
      profileEvalid = profile.eValid!;
      // Storage().verifyEmail = profile.email!;
      profileImage = profile.image!;

      if (profileImage.isNotEmpty) {
        image = ImageConverter(
          imagePath: profileImage,
          isAssets: false,
          fit: BoxFit.fitWidth,
        );
        // image = Image.network(profileImage!, fit: BoxFit.fitWidth);
      } else {
        image = ImageConverter(
          imagePath: 'assets/icon/user.svg',
          isAssets: true,
        );
      }

      // Create a list of the fields you want to check
      List<String> fieldsToCheck = [
        profile.name!,
        profile.surname!,
        profile.forename!,
        profile.contact!,
      ];

      hasProfileData = fieldsToCheck.any((value) => value.isNotEmpty);
    }
  }
}
