import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

dropDownWidget({required List<dynamic>Items,
  required Onchange,
  required dynamic lableSize,
  required String hintText,
  required Value,
  required void Function() OnClear,
}) => DropdownButtonFormField(
  hint: Align(
    alignment: Alignment.center,
    child: Text(
      hintText,
      style: GoogleFonts.poppins(fontSize: lableSize),
    ),

  ),
  decoration:InputDecoration(
    suffixIcon:Value!= null ?  IconButton(onPressed: OnClear, icon: const Icon(Icons.clear)):null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),

  ),
  value: Value,

  items: Items.map((e)=>DropdownMenuItem<dynamic>(value:e,child: Text(e,style: GoogleFonts.poppins(
      fontSize:lableSize
  ),),
  )).toList(), onChanged: Onchange,);