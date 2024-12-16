import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trasnport_portal/Services/dbService.dart';
import 'package:trasnport_portal/Services/loading.dart';
import 'package:trasnport_portal/Widgets/buttonWidget.dart';
import 'package:trasnport_portal/Widgets/dropdownWidget.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';

import 'package:trasnport_portal/common/common_colors.dart';

class Assignstudents extends StatefulWidget {
  const Assignstudents({super.key});

  @override
  State<Assignstudents> createState() => _AssignstudentsState();
}

class _AssignstudentsState extends State<Assignstudents> {
  late double divHeight, divWidth;
  TextEditingController driverName = TextEditingController();
  List routes = [];


  String? selectedDriver;
  List<String> driverNameWithVanNo = [];
  String? selectedRoute;
  DBService dbservice = DBService();
  bool  clicked=false;
 Map driverFullData={};
  Map routeWithDroplocations={};
  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width;
    divHeight = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: dbservice.getDrivers(),
        builder: (context, driverDetails) {
          if (!driverDetails.hasData) return Loading();
          QuerySnapshot driverDetailsQuery = driverDetails.data;
          List<DocumentSnapshot> driverDetailsdocuments = driverDetailsQuery .docs;
          List<String> driverData = [];

          for (int i = 0; i < driverDetailsdocuments.length; i++) {
            Map<String, dynamic> data =
                driverDetailsdocuments[i].data() as Map<String, dynamic>;
            String DriverNameWithVanNo=data["driverName"] + " - " + "Van No " + data["vechileID"];
            driverData.add(DriverNameWithVanNo);
            driverFullData[DriverNameWithVanNo]=data;
          }
          driverNameWithVanNo = driverData;
          return StreamBuilder(
              stream: dbservice.routes(),
              builder: (context, routeDetails) {
                if (!routeDetails.hasData) {
                  return Loading();
                }
                QuerySnapshot routequerySnapshot = routeDetails.data as QuerySnapshot;
                List<DocumentSnapshot> routedocumentSnapshot = routequerySnapshot.docs;
                int doclen = routedocumentSnapshot.length;
                List<String> fetchedRoutes=[];

                for (int i = 0; i < doclen; i++) {
                  Map<String, dynamic> routeData =
                  routedocumentSnapshot[i].data() as Map<String, dynamic>;
                  String routeName=routedocumentSnapshot[i].id;
                  fetchedRoutes.add(routeName);
                  routeWithDroplocations[routeName]=routeData["droplocations"];


                }

                  routes = fetchedRoutes;

                return Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                              text: 'Assign Students ',
                              fontsize: divWidth * 0.015,
                              fontWeight: FontWeight.bold,
                              fontColor: Colors.black,
                              ),
                          SizedBox(
                            height: divHeight * 0.02,
                          ),
                          Wrap(
                            spacing: 5,
                            children: [
                              Container(
                                  width: divWidth * 0.15,
                                  padding: const EdgeInsets.all(10),
                                  child: dropDownWidget(
                                      Items: driverNameWithVanNo,
                                      Onchange: (newValue) {
                                        setState(() {
                                          selectedDriver = newValue;
                                        });
                                      },
                                      lableSize: divWidth * 0.008,
                                      hintText: "Select Driver",
                                      Value: selectedDriver,
                                      OnClear: () {
                                        setState(() {
                                          selectedDriver = null;
                                        });
                                      })),
                              Container(
                                  width: divWidth * 0.15,
                                  padding: const EdgeInsets.all(10),
                                  child: dropDownWidget(
                                      Items: routes,
                                      Onchange: (newValue) {
                                        setState(() {
                                          selectedRoute = newValue;
                                        });
                                      },
                                      lableSize: divWidth * 0.008,
                                      hintText: "Select Route",
                                      Value: selectedRoute,
                                      OnClear: () {
                                        setState(() {
                                          selectedRoute = null;
                                        });
                                      })),
                              InkWell(
                                  onTap: () {
                                    if (selectedRoute != null &&
                                        selectedDriver != null) {
                                      setState(() {
                                        clicked=true;
                                      });
                                    }
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ButtonWidget(
                                          buttonName: "Search",
                                          buttonWidth: divWidth * 0.1,
                                          buttonColor: red,
                                          fontSize: divWidth * 0.008,
                                          fontweight: FontWeight.w500,
                                          fontColor: white)))
                            ],
                          ),
                          SizedBox(
                            height: divHeight * 0.02,
                          ),
                          clicked ?StreamBuilder(
                                  stream: dbservice.getStudents(
                                      route: selectedRoute!),
                                  builder: (context, snapshots) {
                                    if (!snapshots.hasData) {
                                      return Center(child: textWidget(
                                        text: "Loading . . .",
                                        fontsize: divWidth * 0.014,
                                        fontWeight: FontWeight.w700,
                                        fontColor: black,
                                        Spacing: null),
                                    );
                                    }
                                    // QuerySnapshot querySnapshot=snapshots.data;
                                    QuerySnapshot querySnapshot =
                                        snapshots.data as QuerySnapshot;
                                    List<DocumentSnapshot> documentSnapshot =
                                        querySnapshot.docs;
                                    int doclen = documentSnapshot.length;

                                    return
                                        Column(children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width:divWidth*0.35,
                                                child:Center(child:textWidget(
                                                  text: "Not Assigned",
                                                  fontsize: divWidth * 0.014,
                                                  fontWeight: FontWeight.w700,
                                                  fontColor: black,
                                                ),)),
                                              SizedBox(width: divWidth*0.02,),
                                              SizedBox(
                                                width:divWidth*0.35,
                                                child:Center(child:textWidget(
                                                  text: "Assigned",
                                                  fontsize: divWidth * 0.014,
                                                  fontWeight: FontWeight.w700,
                                                  fontColor: black,
                                                ),),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children:[SizedBox(width:divWidth*0.35,child:Center(child:Column(children:[

                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  Map<String,dynamic> studentDatas=documentSnapshot[index].data() as Map<String,dynamic>;

                                                  return studentDatas['assignedVechile']==false ? studentBox(studentData:studentDatas):SizedBox();
                                                },
                                                itemCount: doclen,
                                              )
                                              ]
                                            ),
                                            )
                                            ),
                                              SizedBox(width: divWidth*0.02,),
                                              SizedBox(width:divWidth*0.35,child:Center(child:Column(children:[
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  Map<String,dynamic> studentDatas=documentSnapshot[index].data() as Map<String,dynamic>;

                                                  return studentDatas['assignedVechile']==true ? studentBox(studentData:studentDatas):SizedBox();
                                                },
                                                itemCount: doclen,
                                              )

                                    ]
                                              )
                                              )
                                              )
                                              ]
                                        )
                                            ]
                                        );
                                  }) : Text(""),
                          SizedBox(
                            height: divHeight * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Card studentBox({required Map studentData}) {
   // String status = ticketData["status"];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: divWidth * 0.35,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(
                    text: studentData["studentName"],
                    fontWeight: FontWeight.w500,
                    fontsize: divHeight * 0.017,
                    fontColor: Colors.black,

                  ),
                  textWidget(
                      text: studentData["classAndSec"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: green,
                      Spacing: null),
                ],
              ),
            ),
            Expanded(
              child:Center(child:
                  textWidget(
                      text: studentData["studentId"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black,
                      Spacing: null),

              )


            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: studentData["route"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black,
                      Spacing: null),
                  textWidget(
                      text: studentData["droplocation"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black,
                      Spacing: null),
                ],
              ),
            ),
            Expanded(
              child: Center(child:studentData["assignedVechile"]==false ? InkWell(
                  onTap: ()async{

                    Map selectedDriverData=driverFullData[selectedDriver!];
                    if(selectedDriverData['route']==null){
                      await dbservice.assignRouteToDrivers(uid: selectedDriverData["uid"], routeName: selectedRoute!,droplocations:routeWithDroplocations[selectedRoute!]);
                    }
                    await dbservice.assignStudentsToVan(studentData: studentData, VanNo:selectedDriverData["vechileID"] , vanId: selectedDriverData["uid"]);
                  },
                  child:Icon(Icons.check_box_outline_blank_rounded)) : Row(children:[InkWell(
                  onTap: (){},
                  child:Icon(Icons.check_box,color: green,)),
                SizedBox(width: divWidth*0.02,),
                InkWell(
                    onTap: () async{

                     // Map selectedDriverData=driverFullData[selectedDriver!];
                      await dbservice.deleteAssignedStudents(studentData: studentData, vanId: studentData["vechileID"]);
                    },
                    child:Icon(Icons.delete_outline_outlined,color: red,)),
              ]))
            ),
          ],
        ),
      ),
    );
  }
}
