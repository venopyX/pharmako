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
    checkColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return TColors.darkGrey;
      }
      return TColors.textWhite;
    }),
    fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return TColors.buttonDisabled;
      }
      if (states.contains(WidgetState.selected)) {
        return TColors.buttonColor;
      }
      return TColors.light;
    }),
    side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
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
    checkColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return TColors.darkGrey;
      }
      return TColors.textWhite;
    }),
    fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return TColors.darkerGrey;
      }
      if (states.contains(WidgetState.selected)) {
        return TColors.buttonColor;
      }
      return TColors.light;
    }),
    side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return const BorderSide(color: TColors.darkGrey);
      }
      return const BorderSide(color: TColors.primary);
    }),
  );
}
