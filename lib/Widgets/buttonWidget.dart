import 'package:flutter/material.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';

ButtonWidget({required String buttonName,
  required double buttonWidth,
  required Color  buttonColor,
  required dynamic fontSize,
  required FontWeight fontweight,
  required Color  fontColor,
  Color? borderColor


}){
  return
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:Border.all(color:borderColor!=null ? borderColor : buttonColor ),
          color: buttonColor
      ),
      width:buttonWidth ,
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 10),
        child:Center(child: textWidget(text: buttonName, fontsize: fontSize, fontWeight: fontweight, fontColor: fontColor, Spacing: null)
        ),

      ),

    );
}