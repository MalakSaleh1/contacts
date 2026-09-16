import 'package:flutter/material.dart';

import '../core/app_colors.dart';
class CustomTextField extends StatelessWidget {
   CustomTextField({super.key,required this.controller,required this.hint,required this.onSubmitted,required this.onChanged});


  TextEditingController controller;
  String hint;
   final Function(String) onSubmitted;
   final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      controller: controller,
      style: TextStyle(
          color: AppColors.gold,
          fontSize: 16,
          fontWeight: FontWeight.w400
      ),
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColors.lightBlue,
              fontSize: 16,
              fontWeight: FontWeight.w400
          ),
          enabledBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.gold,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.gold,
              )
          )
      ),
    );
  }
}
