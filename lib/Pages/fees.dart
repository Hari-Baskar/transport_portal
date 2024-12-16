import 'package:flutter/material.dart';
import 'package:trasnport_portal/Widgets/buttonWidget.dart';
import 'package:trasnport_portal/Widgets/dropdownWidget.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/Widgets/textfieldWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';
class Fees extends StatefulWidget {
  const Fees({super.key});

  @override
  State<Fees> createState() => _FeesState();
}

class _FeesState extends State<Fees> {
  late double divHeight,divWidth;
  TextEditingController searchName=TextEditingController();
  List<String> Classes=[
    "I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"
  ];
  List<String> status=[
    "paid",
    "unpaid"
  ];
  String? selectedClass;
  String? selectedStatus;
  @override
  Widget build(BuildContext context) {
    divHeight=MediaQuery.of(context).size.height;
    divWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(child:Padding(padding:const EdgeInsets.all(15), child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: 'Students Fees',
              fontsize: divWidth * 0.015,
              fontWeight: FontWeight.bold,
              fontColor: Colors.black,
              Spacing: null),
          SizedBox(height: divHeight*0.02,),
          Wrap(
            spacing: 5,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: divWidth*0.15,
                child:textfieldWidget(hintText: "Search by name", control: searchName,size:divWidth * 0.008 ),),
              Container(
                  width: divWidth*0.15,
                  padding: const EdgeInsets.all(10),
                  child:  dropDownWidget(Items: Classes, Onchange: (newValue){
                    setState(() {
                      selectedClass=newValue;
                    });
                  }, lableSize:divWidth * 0.008 , hintText: "Select Class", Value: selectedClass, OnClear: () {  })),
               Container(
                  width: divWidth*0.15,
                  padding: const EdgeInsets.all(10),
                  child:  dropDownWidget(Items: status, Onchange: (newValue){
                    setState(() {
                      selectedStatus=newValue;
                    });
                  }, lableSize:divWidth * 0.008 , hintText: "Select Status", Value:selectedStatus, OnClear: () {  })),
               Padding(
                   padding: const EdgeInsets.all(10),
                   child:ButtonWidget(buttonName: "Search", buttonWidth: divWidth*0.1, buttonColor: red, fontSize: divWidth*0.008, fontweight: FontWeight.w500, fontColor: white))

            ],),
           SizedBox(height: divHeight*0.01,),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                  children: [
                    NormalCell(heading: "Name", size: divWidth*0.008, fontColor: red, weight: FontWeight.w500),
                    NormalCell(heading: "Class", size: divWidth*0.008, fontColor: red, weight: FontWeight.w500),
                    NormalCell(heading: "Status", size: divWidth*0.008, fontColor: red, weight: FontWeight.w500),
                    NormalCell(heading: "Phone", size: divWidth*0.008, fontColor: red, weight: FontWeight.w500),

                  ]
              ),
              TableRow(
                  children: [
                    NormalCell(heading: "Praveen", size: divWidth*0.008, fontColor: black, weight: FontWeight.w500),
                    NormalCell(heading: "V", size: divWidth*0.008, fontColor: black, weight: FontWeight.w500),
                    NormalCell(heading: "Paid", size: divWidth*0.008, fontColor: green, weight: FontWeight.w500),
                    NormalCell(heading: "89076542", size: divWidth*0.008, fontColor: black, weight: FontWeight.w500),

                  ]
              ),
            ],
          )
        ],
      ))),
    );
  }
  NormalCell(
      {required String heading,
        required double size,
        required Color fontColor,
        required FontWeight weight,
        Color? boxColor}) {
    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: boxColor != null ? boxColor : Colors.white,
        ),
        child: Center(
          child: textWidget(
              text: heading,
              fontsize: size,
              fontWeight: weight,
              fontColor: fontColor,
              Spacing: null),
        ));
  }
}
