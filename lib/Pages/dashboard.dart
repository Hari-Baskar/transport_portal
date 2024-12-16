import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trasnport_portal/Pages/filterHistory.dart';
import 'package:trasnport_portal/Services/dbService.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late double divHeight,divWidth;
  @override
  Widget build(BuildContext context) {
    divHeight=MediaQuery.of(context).size.height;
   divWidth=MediaQuery.of(context).size.width;
   DBService dbservice=DBService();
    return  StreamBuilder(stream:dbservice.getStudentLocation(), builder: (context,snapshots)
    {
      return Scaffold(
          body: Padding(padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: "Transport Overview",
                    fontsize: divWidth * 0.015,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.black,
                    Spacing: null),
                SizedBox(
                  height: divHeight * 0.02,
                ),
                overview(),
                SizedBox(height: divHeight * 0.03,),

                 /* Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(text: "Today's Tickets",
                          size: divWidth * 0.012,
                          weight: FontWeight.w700,
                          fontColor: black,
                          Spacing: null,),
                        SizedBox(height: divHeight * 0.01,),
                        ticketBox(userid: "uid", ticketData: {
                          "amount": "2500",
                          "date": "15-11-2024",
                          "status": "Pending",
                          "ticketName": "Vechile Service",
                          "time": "09-20 AM",
                          "uid": "OGzKqdVA4JYuay6eVF8NmceoHa53",
                          "driverName": "Praveen",
                          "vanNo": "18"
                        }),
                      ]
                  ),*/
                  SizedBox(width: divWidth * 0.02,),

                  StreamBuilder(stream: dbservice.getDrivers(), builder: (context,snapshots) {
                    if(!snapshots.hasData) return Center(
                      child: textWidget(
                          text: "Loading . . .",
                          fontsize: divWidth * 0.014,
                          fontWeight: FontWeight.w700,
                          fontColor: black,
                          Spacing: null),
                    );
                    QuerySnapshot querySnapshot =snapshots.data;
                    List<DocumentSnapshot> documentSnapshot=querySnapshot.docs;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(text: "Current Drivers ",
                          fontsize: divWidth * 0.012,
                         fontWeight: FontWeight.w700,
                          fontColor: black,
                          Spacing: null,),
                        SizedBox(height: divHeight * 0.01,),
                       SizedBox(width: divWidth*0.3,child: ListView.builder(
                          shrinkWrap:true,
                          itemBuilder: (context,index){
                          Map<String,dynamic> driverDetails=documentSnapshot[index].data() as Map<String,dynamic>;
                          return InkWell(onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterHistory(userId: driverDetails["uid"])));
                          },child:attendance(driverDetails:driverDetails ));
                        },itemCount: documentSnapshot.length,),
                       ),
                        //attendance(driverDetails: driversDetails)
                      ],
                    );
                  }
                  )


              ],
            ),
          )
      );
    }
    );
  }
  overview(){
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 0.5,color: Colors.grey)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            items(Img: "Assets/students.png", title: "Students", count: '300'),

            divide(),
            items(Img: "Assets/driver.png", title: "Drivers", count: '6'),

            divide(),
            items(Img: "Assets/vechiles.png", title: "Vechiles", count: '6'),

            divide(),
            items(Img: "Assets/balanceAca.png", title: "Expenses", count: '50,000'),


          ],
        ),
      ),


    );
  }
  // Speed Limit
  // tickey
  //allowances
  // Google Maps
  // attendance
  items({
    required String Img,
    required String title,
    required String count,

  }){
    return Padding(padding:EdgeInsets.all(20), child: Row(

        children:[
          Image.asset(Img,width: divWidth*0.04,height: divWidth*0.04,),
          SizedBox(width: divWidth*0.02,),
          Column(children:[
            textWidget(text: title, fontsize: divWidth*0.01, fontWeight: FontWeight.bold, fontColor: Colors.black45, Spacing: null) ,
            textWidget(text: count, fontsize: divWidth*0.01, fontWeight: FontWeight.bold, fontColor: Colors.black, Spacing: null),
          ]
          ),
        ]
    )
        );
  }
  divide(){
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),

      width: 4,
      height: divHeight*0.07,
    );
  }
  Card ticketBox({required String userid, required Map ticketData}) {
    String status = ticketData["status"];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: divWidth*0.45,
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
                      text: ticketData["ticketName"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: Colors.black, Spacing: null, ),
                  textWidget(
                      text: "₹ " + ticketData["amount"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: green, Spacing: null),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: ticketData["date"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null),
                  textWidget(
                      text: ticketData["time"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: ticketData["driverName"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null),
                  textWidget(
                      text: ticketData["vanNo"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: status,
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: status == "Pending"
                          ? orange
                          : green, Spacing: null),
                  status == "Pending"
                      ? IconButton(
                      onPressed: () {
                       
                      },
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        color: red,
                      ))
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  attendance({required driverDetails}){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: divWidth*0.27,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(
                    text: driverDetails["driverName"],
                    fontWeight: FontWeight.w500,
                    fontsize: divHeight * 0.017,
                    fontColor: Colors.black, Spacing: null, ),
                  textWidget(
                      text: driverDetails["vechileID"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null),

                ],
              ),


             Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: "View History",
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: blue, Spacing: null),

                ],
              ),


          ],
        ),
      ),

    );
}
}
