// import 'package:flutter/material.dart';
// import 'package:pharmako/utils/constants/colors.dart';
// import 'package:pharmako/utils/constants/sizes.dart';

// ///-- Light & Dark Checkbox Themes
// class TCheckboxTheme {
//   TCheckboxTheme._();

//   ///-- Light Theme
//   static final lightCheckboxTheme = CheckboxThemeData(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(AppSizes.checkboxRadius),
//     ),
//     checkColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return AppColors.darkGrey;
//       }
//       return AppColors.textWhite;
//     }),
//     fillColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return AppColors.buttonDisabled;
//       }
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.buttonColor;
//       }
//       return AppColors.light;
//     }),
//     side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return const BorderSide(color: AppColors.darkGrey);
//       }
//       return const BorderSide(color: AppColors.primary);
//     }),
//   );

//   ///-- Dark Theme
//   static final darkCheckboxTheme = CheckboxThemeData(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(AppSizes.checkboxRadius),
//     ),
//     checkColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return AppColors.darkGrey;
//       }
//       return AppColors.textWhite;
//     }),
//     fillColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return AppColors.darkerGrey;
//       }
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.buttonColor;
//       }
//       return AppColors.light;
//     }),
//     side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
//       if (states.contains(WidgetState.disabled)) {
//         return const BorderSide(color: AppColors.darkGrey);
//       }
//       return const BorderSide(color: AppColors.primary);
//     }),
//   );
// }
