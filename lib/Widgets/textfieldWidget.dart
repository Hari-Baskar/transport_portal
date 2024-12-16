import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textfieldWidget({
  required String hintText,
  required  dynamic control,
  void Function()? OnClick,
  bool? readonly,
  double? size,
  Icon? icon,  Icon? suffixIcon
}){
  return TextField(
    onTap: OnClick,
    controller: control,
    readOnly: readonly!=null ? readonly :false,
    decoration: InputDecoration(
        hintText:hintText ,
        hintStyle: GoogleFonts.poppins(

          fontSize: size,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        )
    ),
  );
}
