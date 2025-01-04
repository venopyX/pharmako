import 'package:flutter/material.dart';
import 'package:pharmako/utils/constants/color.dart';
import 'package:pharmako/utils/constants/sizes.dart';

///-- Light & Dark Checkbox Themes
class TCheckboxTheme {
  TCheckboxTheme._();

  ///-- Light Theme
  static final lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TSizes.checkboxRadius),
    ),
    checkColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return TColors.darkGrey;
      }
      return TColors.textWhite;
    }),
    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return TColors.buttonDisabled;
      }
      if (states.contains(MaterialState.selected)) {
        return TColors.buttonColor;
      }
      return TColors.light;
    }),
    side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return const BorderSide(color: TColors.darkGrey);
      }
      return const BorderSide(color: TColors.primary);
    }),
  );

  ///-- Dark Theme
  static final darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(TSizes.checkboxRadius),
    ),
    checkColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return TColors.darkGrey;
      }
      return TColors.textWhite;
    }),
    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return TColors.darkerGrey;
      }
      if (states.contains(MaterialState.selected)) {
        return TColors.buttonColor;
      }
      return TColors.light;
    }),
    side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return const BorderSide(color: TColors.darkGrey);
      }
      return const BorderSide(color: TColors.primary);
    }),
  );
}
