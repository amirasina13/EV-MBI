import 'package:flutter/material.dart';

import '../../../config/config.dart';
/* Class for dropdown value. Will use in features/delete_account/view/delete_view.dart, features/forgot_pass/view/forgot_view.dart, 
features/login/login_screen.dart, features/register/profile_view.dart, features/settings/view/profile_view.dart */

class CustomSelectValue<T> extends StatefulWidget {
  final List<T> availableValues;
  final T selectedValue;
  final String? hint;
  final Function(T) onClick;
  final String? error;
  final double width;
  final InputBorder? border;
  final Color? dropdownColor;

  const CustomSelectValue({
    super.key,
    required this.availableValues,
    required this.selectedValue,
    this.hint,
    required this.onClick,
    this.error,
    required this.width,
    this.border,
    this.dropdownColor = colorBlack,
  });

  @override
  CustomSelectValueState<T> createState() => CustomSelectValueState<T>();
}

class CustomSelectValueState<T> extends State<CustomSelectValue<T>> {
  late T selectedValue;
  String? error;
  bool isChecked = false;

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    error = widget.error;

    return Column(
      children: <Widget>[
        Container(
          color: colorTransparent,
          height: MediaQuery.of(context).size.height / 20,
          width: widget.width,
          child: Container(
            color: colorWhite,
            child: Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: _buildDropDown(context),
            ),
          ),
        ),
        error == null
            ? Container()
            : Text(
                error!,
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                  fontFamily: fontFamilyMain,
                ),
              ),
      ],
    );
  }

  DropdownButtonHideUnderline _buildDropDown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton(
          isDense: true,
          iconSize: 20,
          iconEnabledColor: colorDarkGray,
          items: widget.availableValues.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: SizedBox(
                width: widget.width - 20,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: colorBlack,
                    fontSize: 14,
                    fontFamily: fontFamilyMain,
                  ),
                ),
              ),
            );
          }).toList(),
          isExpanded: false,
          value: selectedValue,
          onChanged: (dynamic newValue) {
            _updateSelectedValue(newValue);
          },
          hint: Text(widget.hint!),
          style: TextStyle(
            color: colorDarkGray,
            fontSize: 16,
            fontFamily: fontFamilyMain,
          ),
        ),
      ),
    );
  }

  void _updateSelectedValue(T newValue) {
    selectedValue = newValue;
    setState(() {});
    widget.onClick(selectedValue);
  }
}
