import 'package:flutter/material.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late double divWidth;
  @override
  Widget build(BuildContext context) {
    divWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: textWidget(
            text: "Loading . . .",
            fontsize: divWidth * 0.014,
            fontWeight: FontWeight.w700,
            fontColor: black,
            Spacing: null),
      ),
    );
  }
}
