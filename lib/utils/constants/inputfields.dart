import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final String? Function(String?)? validate;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.validate,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        validator: validate,
        cursorColor: AppColors.primary,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: height * 0.025, horizontal: width * 0.06),
          filled: true,
          // fillColor: kwhiteBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(width: 1, color: AppColors.inputBorder),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: AppColors.primary,
            ),
          ),
          labelText: labelText,
          // Pass the label text here
          labelStyle: const TextStyle(
            color: AppColors.inputBorder,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
